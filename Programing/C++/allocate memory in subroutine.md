#在C语言内子函数中申请内存

Fortran 语言中，可以通过调用模块内子函数为变量申请内存空间，如

```
program main
implicit none

real, allocatable :: x

call allocateMemory(x, 4)

end program

subroutine allocateMemory(x, num)
real, allocatable :: x
integer :: num

allocate(x(num))

end subroutine
```

C 语言中，这一方法变得不可行。如下，函数返回后，指针 concentration 仍为 NULL

```c
int InitConst(structMesh *mesh, physics *phy, double **concentration){

    concentration = BuildMatrix(np, np); // allocate memory
    
    for (irow=0; irow< mesh->ny; irow++) {
        for (icol=0; icol< mesh->nx; icol++) {
            concentration[irow][icol] = exp(-pow(mesh->x[icol] - 0.5, 2.0)/phy->Dx
                                            - pow(mesh->y[irow] - 0.5, 2.0)/phy->Dy);
        }
    }

    return 0;

}

```

主要原因是，C 语言在调用子函数时按值传递。在调用子函数前，会将指针 concentration 的值 NULL 复制，然后传给子函数作为实参。子函数调用结束后，所有参数会销毁，实参 concentration 所储存的地址也会丢失。返回函数后，指针内容仍未 NULL。

修正方法就是把指针作为返回值传递给调用函数，例如
MKL
```c
double** InitConst(structMesh *mesh, physics *phy, double **concentration){

    concentration = BuildMatrix(np, np); // allocate memory
    
    for (irow=0; irow< mesh->ny; irow++) {
        for (icol=0; icol< mesh->nx; icol++) {
            concentration[irow][icol] = exp(-pow(mesh->x[icol] - 0.5, 2.0)/phy->Dx
                                            - pow(mesh->y[irow] - 0.5, 2.0)/phy->Dy);
        }
    }

    return concentration;

}

```

或者，也可以用传递指针地址的方法修改指针内容，如

```c
int InitConst(structMesh *mesh, physics *phy, double ***concentration){

    concentration = BuildMatrix(np, np); // allocate memory
    
    for (irow=0; irow< mesh->ny; irow++) {
        for (icol=0; icol< mesh->nx; icol++) {
            (*concentration)[irow][icol] = exp(-pow(mesh->x[icol] - 0.5, 2.0)/phy->Dx
                                            - pow(mesh->y[irow] - 0.5, 2.0)/phy->Dy);
        }
    }

    return 0;

}

```