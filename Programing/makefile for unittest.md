# 单元测试 makefile 写法

基本要求：

单元测试中，每个测试程序通过调用静态库链接成单个测试程序。对应每个测试源程序文件`test_vdif_scal.F90`，都有一个可执行程序`test_vdif_scal`。

```
li12242:testing mac$ ls -al
total 264
drwx------    7 mac  staff     238  4 16 21:22 .
drwx------  488 mac  staff   16592  4 16 20:34 ..
-rw-r--r--@   1 mac  staff    6148  4 16 20:40 .DS_Store
-rw-r-----    1 mac  staff    1009  4 16 21:22 makefile
-rwxr-xr-x    1 mac  staff  114080  4 16 21:22 test_vdif_scal
-rw-r--r--    1 mac  staff     132  4 16 20:32 test_vdif_scal.F90
-rw-r--r--    1 mac  staff    1012  4 16 21:22 test_vdif_scal.o
```

makefile :

```
TEST_BINARIES= $(filter-out $(DISABLED_TESTS), $(basename $(wildcard *.F90)))

TEST_OBJS = $(patsubst %.F90,%.o,$(wildcard *.F90))

unittest: $(TEST_BINARIES)

$(TEST_BINARIES): $(TEST_OBJS)


.SUFFIXES:

%.o:    %.f90
    $(FC) $(FCFLAGS) $(FFLAGS) -c $<
    $(FC) $(LIBS) -L../ -lfvcom  $@  -o $(basename $@)
%.o:    %.F90
    $(FC) $(FCFLAGS) $(FFLAGS) -c $<
    $(FC) $(LIBS) -L../ -lfvcom  $@  -o $(basename $@)
.c.o:
    $(CC) $(CFLAGS) -c $<
.cpp.o:
    $(CXX) $(CXXFLAGS) -c $<


clean:
    rm -f $(TEST_BINARIES)
    rm -f *.o *.mod

```

说明：

1. ".SUFFIXES:" 含义是删除缺省的后缀列表，否则make命令会调用 gcc 编译目录下的 .o 文件
2. TEST_BINARIES 保存当前目录下所有文件名对应可执行程序文件名字符串，也就是把源程序文件名的后缀都去掉
3. TEST_OBJS 保存目录下所有*.F90 文件对应 *.o 文件名字符串，也就是把源程序文件名的后缀换成*.o
4. 隐式规则里，$@ 表示目标文件，$^ 表示所有的依赖文件，$< 表示第一个依赖文件
5. DISABLED_TESTS 保存当前目录下不编译的所有文件名

这样，生成 %.o 文件过程中，就会把目标文件`test_vdif_scal.o`和静态库`libfvcom.a`，一起生成不包含后缀名的可执行程序`test_vdif_scal`
