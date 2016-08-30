# CMake 编译 Fortran 源程序

几个优点：
1. 无需像 Makefile 一样写繁琐的文件依赖关系，CMake 可以自动推导
2. ccmake 可以界面化选择编译器，预编译指令


```
cmake_minimum_required(VERSION 3.1)
PROJECT (FORTRAN)
enable_language(Fortran)
SET(SRC_LIST prePrint.f90 main.f90 print.f90)

SET_SOURCE_FILES_PROPERTIES(main.f90
      PROPERTIES COMPILE_FLAGS "-fpp -DA")
# for precompile, ifort need "-fpp" flags, gfortran need "-cpp" flags

ADD_EXECUTABLE(hello ${SRC_LIST})
```
