# 在子函数中申请内存

Fortran 语言中，可以通过调用模块内子函数为变量申请内存空间，如

```
program main
    implicit none

    real, allocatable :: x
    call allocateMemory(x, 4)
    deallocate(x);
end program

subroutine allocateMemory(x, num)
    real, allocatable :: x
    integer :: num

    allocate(x(num))
end subroutine
```

C 语言中，这一方法变得不可行。如下，函数返回后，指针`vec`的值仍为 NULL

```
int main(int argc, char *argv[]){
    double *vec=NULL;
    AllocateMem(vec, 5);
    free(vec);
    return 0;
}

int AllocateMem(double *con, int N){
    con = (double *)calloc(N, sizeof(double));
    return 0;
}

```

主要原因是，C 语言在调用子函数时按值传递，而 Frotran 则传递的是变量地址（指针）。在调用子函数`AllocateMem`前，主函数会将指针`vec`的值`NULL`进行复制，然后传给变量`con`作为实参。子函数调用结束后，所有参数会销毁，`con`所申请的内存地址也会丢失。返回函数后，指针内容仍为`NULL`。

修正方法就是把指针作为返回值传递给调用函数，例如
```
double* AllocateMem(double *con, int N){
    con = (double *)calloc(N, sizeof(double));
    return con;
}

```

或者，也可以用传递指针地址的方法修改指针内容，如

```
int AllocateMem(double **con, int N){
    *con = (double *)calloc(N, sizeof(double));
    return 0;
}

```
