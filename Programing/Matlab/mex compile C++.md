# mex compile C++

**目标：使用混合编译的方法，在Matlab中调用 Polylib**

### mex函数
使用c添加mex接口函数

```c
#include "mex.h"
void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  double *p_c, *p_d;
  double *p_a, *p_b;

  int c_rows, c_cols;
  int d_rows, d_cols;

  int numEl;
  int n;

  mxAssert(nlhs==2 && nrhs==2, "Error: number of variables");

  c_rows = mxGetM(prhs[0]);// get rows of c
  c_cols = mxGetN(prhs[0]);// get cols of c
  d_rows = mxGetM(prhs[1]);// get rows of d
  d_cols = mxGetN(prhs[1]);// get cols of d

  mxAssert(c_rows==d_rows && c_cols==d_cols, "Error: cols and rows");

  // create output buffer
  plhs[0] = mxCreateDoubleMatrix(c_rows, c_cols, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(c_rows, c_cols, mxREAL);

  // get buffer pointers
  p_a = (double*)mxGetData(plhs[0]);
  p_b = (double*)mxGetData(plhs[1]);
  p_c = (double*)mxGetData(prhs[0]);
  p_d = (double*)mxGetData(prhs[1]);

  // compute a = c + d; b = c - d;
  numEl = c_rows*c_cols;
  for (n = 0; n < numEl; n++)
  {
    p_a[n] = p_c[n] + p_d[n];
    p_b[n] = p_c[n] - p_d[n];
  }
}
```

### 动态链接库
**使用gcc编译为动态链接库，使用Matlab写接口对应的函数**

```shell
CC=gcc-4.6

target:
  ${CC} -c polylib.c
  ${CC} -shared -fPIC -o libpolylib.dyld polylib.o
```

在Matlab中查看动态库包含指令
```
>> loadlibrary('libpolylib.dyld');
>> list = libfunctions('libpolylib','-full')

list =

    '[doublePtr, doublePtr, doublePtr] Dgj(doublePtr, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Dglj(doublePtr, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Dgrjm(doublePtr, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Dgrjp(doublePtr, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Imgj(doublePtr, doublePtr, doublePtr, int32, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Imglj(doublePtr, doublePtr, doublePtr, int32, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Imgrjm(doublePtr, doublePtr, doublePtr, int32, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] Imgrjp(doublePtr, doublePtr, doublePtr, int32, int32, double, double)'
    '[double, doublePtr] hgj(int32, double, doublePtr, int32, double, double)'
    '[double, doublePtr] hglj(int32, double, doublePtr, int32, double, double)'
    '[double, doublePtr] hgrjm(int32, double, doublePtr, int32, double, double)'
    '[double, doublePtr] hgrjp(int32, double, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr] jacobd(int32, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr, doublePtr] jacobfd(int32, doublePtr, doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr] zwgj(doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr] zwglj(doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr] zwgrjm(doublePtr, doublePtr, int32, double, double)'
    '[doublePtr, doublePtr] zwgrjp(doublePtr, doublePtr, int32, double, double)'
```

想要调用的是`zwgj`函数，输入参数类型为(doublePtr, doublePtr, int32, double, double)，注意Matlab中对应变量类型

| C Type | Equivalent Matlab Type |
| --- | ---- |
| char,byte | int8 |
| unsigned char,byte | uint8 |
| short | int16 |
| unsigned short | uint16 |
| int | int32 |
| long(Windows®) | int32,long |
| long(Linux®) | int64,long |
| unsigned int | unit32 |
| unsigned long(Windows) | uint32,long |
| unsigned long (Linux)  |uint64,long |
| float | single |
| double | double |
| char * | 1xn char array |
| *char[] | cell array of strings |

其中`libfunctions`函数显示的变量类型对应为

| C Pointer Type | Argument Data Type | Equivalent Matlab Type |
| --- | --- | --- |
| double * | doublePtr | double |
| float * | singlePtr | single |
| integer pointer types (int *) | (u)int(size)Ptr | (u)int(size) |
| Matrix of signed bytes | int8Ptr | int8 |
| Null-terminated string passed by value | cstring | 1xn char array |
| Array of pointers to strings (or one **char) | stringPtrPtr | cell array of strings |
| enum  | enumPtr | |
| type ** | Same as typePtr with an added Ptr (for example, double **  is doublePtrPtr) |  lib.pointer object |
| void * | voidPtr | |
| void ** | voidPtrPtr | lib.pointer object |
| C-style structure | structure  | MATLAB struct |
| mxArray * | MATLAB array | MATLAB array |
| mxArray ** | MATLAB arrayPtr | lib.pointer object |

对应的Matlab接口函数为

``` matlab
loadlibrary('libpolylib.dyld');
np = int32(5);
z = zeros(1,np); w = zeros(1,np);
[z, w] = calllib('libpolylib', 'zwgj', z, w,np,alpha,beta);
```

其中np转换为对应的`int32`类型变量
