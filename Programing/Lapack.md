# Lapack 库 C 接口 Lapacke 介绍

介绍 Lapack 库及其对应的 C 语言接口

## 1.介绍

本文描述 Lapack 库不同层次C语言接口，包括高级函数接口与中级函数接口。高级接口工作空间使用内存都在内部申请，而中级接口需要提供工作数组给原始 Fortran 接口。
所有接口的原型及宏与类型定义都包含在`lapack.h`头文件内。

### 1.1.命名结构

所有高级接口都是使用 Fortran Lapack 子程序名，并且在前面加前缀`LAPACK_`，例如 LAPACK 库中子函数`DGEREF`的函数名变为`LAPACK_dgetrf`。

对中级接口，还要使用后缀`_work`，例如`DGETRF`变为`LAPACKE dgetrf work`。

### 1.2.复数类型

复数类型使用宏 `lapack_complex_float` 和 `lapack_complex_double` 定义。

### 1.3.数组变量

数组通过指针传递，而非指针的指针。所有 Lapacke 函数都会接收一个指针和一个附加整数变量，这个变量必须为 `LAPACK_ROW_MAJOR` 或 `LAPACK_COL_MAJOR` 中的一种，表示数组是按行排列或是按列排列的。若是传入多个数组，它们必须按照相同方式排列。

注意使用行优先排列方式可能会比列优先方式占用更多内存，因为函数必须先进行转置，随后传给对应的 Lapack 函数。

### 1.4.变量化名

### 1.5.INFO 参数

LAPACKE 接口函数会返回 lapack_int 类型参数 INFO，包含错误以及结束条件信息等。这与 LAPACK 子例程不同，其返回int类型信息在 Fortran 参数内。

### 1.6.NAN 检查

默认会检查所有输入矩阵，查看其是否包含任何 NAN 元素。可以通过

### 1.7.整数型变量

### 1.8.逻辑类型

逻辑变量类型为 `lapack_logical` 类型，其定义与 `lapack_int` 相同。

### 1.9.内存管理

### 1.10.新的错误代码

## 2.函数列表

## 3.示例

## 4.编译方法

可以参考文件夹 `lapacke/exmple` 内 Makefile 相关编译指令。
目前只有gcc编译器可以完整编译链接 `lapacke` 函数库（采用gfortran链接），icc无法链接。
