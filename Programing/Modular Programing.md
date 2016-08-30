# 模块化编程

所有相关函数定义在一个module内
* 主要目的是根据模块功能定义公共函数，公共函数个数越少越好，功能可以适当增加
* 部分函数为模块私有函数，为公共函数提供辅助作用

## 不同语言模块化编程示例

**Fortran**

Fortran语言的模块可以为单一文件，用关键字`module`声明，函数引用时使用`use`关键字

libUntily.f90

```
module libUntily

<usr types>
type usrType1
    ...
end type

<golbal variable in module>
MAX_LEN = 50
PI = 3.1415926

<define public methods>
public: function1, sub1

<methods>
contains

    function fun1
        ...
    end function

    subroutine sub1
        ...
    end subroutine
```

**C**

c中同一个模块函数写在同一个`LibUntily.c`文件内，公共函数在头文件`LibUntily.h`里声明。

**Matlab**

Matlab每个文件只能有一个公共函数（函数名与文件名相同），其余函数都是子函数。模块则使用`+LibUntily`文件夹将所有相关函数进行封装。引用时使用`LibUntily.函数名`进行调用。
