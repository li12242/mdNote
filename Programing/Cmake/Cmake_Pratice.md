# Cmake Pratice

# 0. 前言
一个多月前，由于工程项目的需要，匆匆的学习了一下cmake的使用方法，现在有时间拿出来整理一下。本文假设你已经学会了cmake的使用方法，如果你还不会使用cmake，请参考相关资料之后再继续向下看。
本文中介绍的是生成可执行程序的方法和步骤，生成动态库和静态库的方法与此有所不同，随后会介绍动态库和静态库项目中cmake的编写方法。
本文参考《CMake Practice》这篇文章完成，旨在指导用户快速使用CMake，如果需要更详细的内容，请通读《CMake Practice》这篇文章。下载路径：<http://sewm.pku.edu.cn/src/paradise/reference/CMake%20Practice.pdf>
# 1. 项目目录结构
我们项目的名称为CRNode，假设我们项目的所有文件存放再~/workspace/CRNode，之后没有特殊说明的话，我们所指的目录都以此目录为相对路径。
我们的目录结构如下：

```
~/workspace/CRNode
  ├─ src
  │  ├─ rpc
  │  │  ├─ CRMasterCaller.h
  │  │  ├─ CRMasterCaller.cc
  │  │  ├─ CRNode.h
  │  │  ├─ CRNode.cc
  │  │  ├─ Schd_constants.h
  │  │  ├─ Schd_constants.cc
  │  │  ├─ CRMaster.h
  │  │  ├─ CRMaster.cc
  │  │  ├─ CRNode_server.skeleton.h
  │  │  ├─ CRNode_server.skeleton.cc
  │  │  ├─ Schd_types.h
  │  │  └─ Schd_types.cc
  │  ├─ task
  │  │  ├─ TaskExecutor.h
  │  │  ├─ TaskExecutor.cc
  │  │  ├─ TaskMonitor.h
  │  │  └─ TaskMonitor.cc
  │  ├─ util
  │  │  ├─ Const.h
  │  │  ├─ Const.cc
  │  │  ├─ Globals.h
  │  │  ├─ Globals.cc
  │  │  ├─ Properties.h
  │  │  ├─ Properties.cc
  │  │  ├─ utils.h
  │  │  └─ utils.cc
  │  ├─ main.cc
  │  └─ CMakeLists.txt
  ├─ doc
  │  └─ crnode.txt
  ├─ COPYRIGHT
  ├─ README
  ├─ crnode.sh
  └─ CMakeLists.txt
```

其中，src存放源代码文件和一个CMakeLists.txt文件，CMakeLists文件的编写我们稍候介绍；doc目录中存放项目 的帮助文档，该文档以及COPYRIGHT和README一起安装到`/usr/share/doc/crnode`目录中；COPYRIGHT文件存放项目 的版权信息，README存放一些说明性文字；crnode.sh 存放CRNode的启动命令；CMakeLists.txt文件稍候介绍。
除此之外，项目还依赖两个外部库：Facebook开发的thrift库，其头文件存放在`/usr/include/thrift`目录中；log4cpp库，其头文件存放再`/usr/include`下。

# 2. CMakeLists.txt文件
本工程中使用了两个CMakeLists.txt文件，分别项目的根目录（即~/workspace/CRNode目录，下同）和src目录中 （参考以上目录结构）。我们先给出两个CMakeLists.txt的内容，在下一节中再对两个CMakeLists.txt进行详细介绍。两个 CMakeLists.txt文件的内容分别如下：

## 2.1 根目录中CMakeLists内容

```
cmake_minimum_required (VERSION 2.6)

project (CRNode)

ADD_SUBDIRECTORY(src bin)

#SET(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR})
SET(CMAKE_INSTALL_PREFIX /usr/local)

INSTALL(PROGRAMS crnode.sh DESTINATION bin)

INSTALL(FILES COPYRIGHT README DESTINATION share/doc/crnode)

INSTALL(DIRECTORY doc/ DESTINATION share/doc/crnode)
```

## 2.2 src/CMakeLists.txt内容

```
INCLUDE_DIRECTORIES(/usr/include/thrift)

SET(SRC_LIST main.cc
        rpc/CRMasterCaller.cpp
        rpc/CRNode_server.skeleton.cpp
        rpc/Schd_constants.cpp
        rpc/CRMaster.cpp
        rpc/CRNode.cpp
        rpc/Schd_types.cpp
        task/TaskExecutor.cpp
        task/TaskMoniter.cpp
        util/Const.cpp
        util/Globals.cc
        util/utils.cc
        util/Properties.cpp
        )

ADD_EXECUTABLE(crnode ${SRC_LIST})

TARGET_LINK_LIBRARIES(crnode log4cpp thrift)

INSTALL(TARGETS crnode
        RUNTIME DESTINATION bin)
```

# 3. CMake语法
1. 变量使用${}方式取值，但是在 IF 控制语句中是直接使用变量名；
2. 指令(参数 1 参数 2…)，参数使用括弧括起，参数之间使用空格或分号分开；
3. 指令是大小写无关的，参数和变量是大小写相关的。但推荐你全部使用大写指令。

# 4. CMakeLists.txt剖析
## 4.1 cmake_minimum_required命令

```
cmake_minimum_required (VERSION 2.6)
```

规定cmake程序的最低版本。这行命令是可选的，我们可以不写这句话，但在有些情况下，如果CMakeLists.txt文件中使用了一些高版本cmake特有的一些命令的时候，就需要加上这样一行，提醒用户升级到该版本之后再执行cmake。

## 4.2 project命令

```
project (CRNode)
```

指定项目的名称。项目最终编译生成的可执行文件并不一定是这个项目名称，而是由另一条命令确定的，稍候我们再介绍。
但是这个项目名称还是必要的，在cmake中有两个预定义变量：`< projectname >_BINARY_DIR`以及`< projectname >_SOURCE_DIR`，在我们的项目中，两个变量分别为：`CRNode_BINARY_DIR`和`CRNode_SOURCE_DIR`。内部编译情况下两者相同，后面我们会讲到外部编译,两者所指代的内容会有所不同。要理解这两个变量的定义，我们首先需要了解什么是“外部构建（out-of-source build）”，我们将在下一小节中介绍“外部构建”。
同时cmake还预定义了`PROJECT_BINARY_DIR`和`PROJECT_SOURCE_DIR`变量。在我们的项目 中，`PROJECT_BINARY_DIR`等同于`CRNode_BINARY_DIR`，`PROJECT_SOURCE_DIR`等同于 `CRNode_SOURCE_DIR`。在实际的应用用，我强烈推荐使用`PROJECT_BINARY_DIR`和`PROJECT_SOURCE_DIR`变 量，这样即使项目名称发生变化也不会影响CMakeLists.txt文件。

## 4.3 外部构建
假设我们此时已经完成了两个CMakeLists.txt文件的编写，可以执行cmake命令生成Makefile文件了。此时我们由两种方法可以执行cmake、编译和安装：

```
cmake .
make
```
或者

```
mkdir build
cd build
cmake ..
make
```

两种方法最大的不同在于执行 cmake 和 make 的工作路径不同。第一种方法中，cmake生成的所有中间文件和可执行文件都会存放在项目 目录中；而第二种方法中，中间文件和可执行文件都将存放再build目录中。第二种方法的优点显而易见，它最大限度的保持了代码目录的整洁。同时由于第二 种方法的生成、编译和安装是发生在不同于项目目录的其他目录中，所以第二种方法就叫做“外部构建”。
回到之前的疑问，再外部构建的情况下，`PROJECT_SOURCE_DIR`指向的目录同内部构建相同，仍然为`~/workspace /CRNode`，而`PROJECT_BINARY_DIR`则有所不同，指向`~/workspace/CRNode/build`目录。
当然，cmake强烈推荐使用外部构建的方法。

## 4.4 ADD_SUBDIRECTORY命令

```
ADD_SUBDIRECTORY(src bin)
```

`ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL])`这个指令用于向当前工程添加存放源文件的子目录,并可以指定中间二进制和目标二进制存放的位置。 EXCLUDE_FROM_ALL 参数的含义是将这个目录从编译过程中排除。比如工程的 example,可能就需要工程构建完成后,再进入 example 目录单独进行构建。
在我们的项目中，我们添加了src目录到项目中，而把对应于src目录生成的中间文件和目标文件存放到bin目录下，在上一节举例中“外部构建”的情况下，中间文件和目标文件将存放在build/srcobj目录下。

##4.5 SET命令

```
SET(CMAKE_INSTALL_PREFIX /usr/local)
```

现阶段,只需要了解SET命令可以用来显式的定义变量即可。在以上的例子中，我们显式的将`CMAKE_INSTALL_PREFIX`的值定义为`/usr/local`，如此在外部构建情况下执行make install命令时，make会将生成的可执行文件拷贝到`/usr/local/bin`目录下。
当然，可执行文件的安装路径CMAKE_INSTALL_PREFIX也可以在执行cmake命令的时候指定，cmake参数如下：

```
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
```

如果cmake参数和CMakeLists.txt文件中都不指定该值的话，则该值为默认的/usr/local。

## 4.6 INCLUDE_DIRECTORIES命令

```
INCLUDE_DIRECTORIES(/usr/include/thrift)
```

INCLUDE_DIRECTORIES类似gcc中的编译参数“-I”，指定编译过程中编译器搜索头文件的路径。当项目需要的头文件不在 系统默认的搜索路径时，需要指定该路径。在我们的项目中，log4cpp所需的头文件都存放在/usr/include下，不需要指定；但thrift的 头文件没有存放在系统路径下，需要指定搜索其路径。

## 4.7 ADD_EXECUTABLE和ADD_LIBRARY

```
SET(SRC_LIST main.cc
        rpc/CRMasterCaller.cpp
        rpc/CRNode_server.skeleton.cpp
        rpc/Schd_constants.cpp
        rpc/CRMaster.cpp
        rpc/CRNode.cpp
        rpc/Schd_types.cpp
        task/TaskExecutor.cpp
        task/TaskMoniter.cpp
        util/Const.cpp
        util/Globals.cc
        util/utils.cc
        util/Properties.cpp
        )

ADD_EXECUTABLE(CRNode ${SRC_LIST})
```

ADD_EXECUTABLE定义了这个工程会生成一个文件名为 CRNode 的可执行文件,相关的源文件是 SRC_LIST 中定义的源文件列表。需要注意的是，这里的CRNode和之前的项目名称没有任何关系，可以任意定义。

## 4.8 EXECUTABLE_OUTPUT_PATH和LIBRARY_OUTPUT_PATH
我们可以通过 SET 指令重新定义 `EXECUTABLE_OUTPUT_PATH` 和 `LIBRARY_OUTPUT_PATH` 变量来指定最终的目标二进制的位置(指最终生成的CRNode可执行文件或者最终的共享库，而不包含编译生成的中间文件)。
命令如下：
```
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
```

需要注意的是，在哪里 ADD_EXECUTABLE 或 ADD_LIBRARY,如果需要改变目标存放路径,就在哪里加入上述的定义。

## 4.9 TARGET_LINK_LIBRARIES命令

```
TARGET_LINK_LIBRARIES(CRNode log4cpp thrift)
```

这句话指定在链接目标文件的时候需要链接的外部库，其效果类似gcc的编译参数“-l”，可以解决外部库的依赖问题。

## 4.10 INSTALL命令
在执行INSTALL命令的时候需要注意CMAKE_INSTALL_PREFIX参数的值。该参数在3.5中已经有所介绍。其命令形式如下：

```
INSTALL(TARGETS targets...
    [[ARCHIVE|LIBRARY|RUNTIME]
    [DESTINATION < dir >]
    [PERMISSIONS permissions...]
    [CONFIGURATIONS
    [Debug|Release|...]]
    [COMPONENT < component >]
    [OPTIONAL]
    ] [...])
```

参数中的 TARGETS 后面跟的就是我们通过 ADD_EXECUTABLE 或者 ADD_LIBRARY 定义的目标文件,可能是可执行二进制、动态库、静态库。
DESTINATION 定义了安装的路径,如果路径以/开头,那么指的是绝对路径,这时候CMAKE_INSTALL_PREFIX 其实就无效了。如果你希望使用 CMAKE_INSTALL_PREFIX 来定义安装路径,就要写成相对路径,即不要以/开头,那么安装后的路径就是${CMAKE_INSTALL_PREFIX} /< destination 定义的路径>
**你不需要关心 TARGETS 具体生成的路径,只需要写上 TARGETS 名称就可以了。**
非目标文件的可执行程序安装(比如脚本之类):
```
INSTALL(PROGRAMS files... DESTINATION < dir >
    [PERMISSIONS permissions...]
    [CONFIGURATIONS [Debug|Release|...]]
    [COMPONENT < component >]
    [RENAME < name >] [OPTIONAL])
```
跟上面的 FILES 指令使用方法一样,唯一的不同是安装后权限为OWNER_EXECUTE, GROUP_EXECUTE, 和 WORLD_EXECUTE,即 755 权限目录的安装。
安装一个目录的命令如下：
```
INSTALL(DIRECTORY dirs... DESTINATION < dir >
    [FILE_PERMISSIONS permissions...]
    [DIRECTORY_PERMISSIONS permissions...]
    [USE_SOURCE_PERMISSIONS]
    [CONFIGURATIONS [Debug|Release|...]]
    [COMPONENT < component >]
    [[PATTERN < pattern > | REGEX < regex >]
    [EXCLUDE] [PERMISSIONS permissions...]] [...])
```
DIRECTORY 后面连接的是所在 Source 目录的相对路径,但务必注意:abc 和 abc/有很大的区别。如果目录名不以/结尾,那么这个目录将被安装为目标路径下的 abc,如果目录名以/结尾,代表将这个目录中的内容安装到目标路径,但不包括这个目录本身。我们来看一个例子:
```
INSTALL(DIRECTORY icons scripts/ DESTINATION share/myproj
    PATTERN "CVS" EXCLUDE
    PATTERN "scripts/*"
    PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
    GROUP_EXECUTE GROUP_READ)
```

这条指令的执行结果是:
将 icons 目录安装到 < prefix >/share/myproj,将 scripts/中的内容安装到< prefix >/share/myproj，不包含目录名为 CVS 的目录,对于 scripts/\*文件指定权限为 OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ。
因为crnode.txt 要安装到/< prefix >/share/doc/crnode,所以我们不能直接安装整个 doc 目录,这里采用的方式是安装 doc 目录中的内容,也就是使用”doc/”在工程文件中添加:

```
INSTALL(DIRECTORY doc/ DESTINATION share/doc/crnode)
```

# 5. 编译安装
编译安装结果如下：
```
[root@sim91 build]# cmake ..
-- Configuring done
-- Generating done
-- Build files have been written to: /home/fify/workspace/CRNode/build

[root@sim91 build]# make
Scanning dependencies of target crnode
[  7%] Building CXX object srcobj/CMakeFiles/crnode.dir/main.cc.o
[ 15%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/CRMasterCaller.cpp.o
[ 23%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/CRNode_server.skeleton.cpp.o
[ 30%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/Schd_constants.cpp.o
[ 38%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/CRMaster.cpp.o
[ 46%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/CRNode.cpp.o
[ 53%] Building CXX object srcobj/CMakeFiles/crnode.dir/rpc/Schd_types.cpp.o
[ 61%] Building CXX object srcobj/CMakeFiles/crnode.dir/task/TaskExecutor.cpp.o
[ 69%] Building CXX object srcobj/CMakeFiles/crnode.dir/task/TaskMoniter.cpp.o
[ 76%] Building CXX object srcobj/CMakeFiles/crnode.dir/util/Const.cpp.o
[ 84%] Building CXX object srcobj/CMakeFiles/crnode.dir/util/Globals.cc.o
[ 92%] Building CXX object srcobj/CMakeFiles/crnode.dir/util/utils.cc.o
[100%] Building CXX object srcobj/CMakeFiles/crnode.dir/util/Properties.cpp.o
Linking CXX executable crnode

[root@sim91 build]# make install
[100%] Built target crnode
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/bin/crnode.sh
-- Installing: /usr/local/share/doc/crnode/COPYRIGHT
-- Installing: /usr/local/share/doc/crnode/README
-- Installing: /usr/local/share/doc/crnode
-- Installing: /usr/local/share/doc/crnode/crnode.txt
-- Installing: /usr/local/bin/crnode
```
大功告成！更多内容请参考《CMake Practice》，再次对《CMake Practice》的作者表示感谢！
