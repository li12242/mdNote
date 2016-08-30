MATLAB Function Reference
# function_handle (@)
MATLAB data type that is a handle to a function

### Syntax

    handle = @functionname
### Description

    handle = @functionname

returns a handle to the specified MATLAB function.

### Remarks
For nonoverloaded functions, subfunctions, and private functions, a function handle references just the one function specified in the @functionname syntax.

When you evaluate an overloaded function through its handle, the arguments the handle is evaluated with determine the actual function that MATLAB dispatches to.

The function handle is a standard MATLAB data type. As such, you can manipulate and operate on function handles in the same manner as on other MATLAB data types. This includes using function handles in arrays, structures, and cell arrays.

Function handles enable you to do all of the following:

* Pass function access information to other functions
* Allow wider access to subfunctions and private functions
* Ensure reliability when evaluating functions
* Reduce the number of files that define your functions
* Improve performance in repeated operations

### Examples
The following example creates a function handle for the humps function and assigns it to the variable, fhandle.

    fhandle = @humps;
Pass the handle to another function in the same way you would pass any argument. This example passes the function handle just created to fminbnd, which then minimizes over the interval [0.3, 1].
```
x = fminbnd(fhandle, 0.3, 1)
x =
    0.6370
```

The fminbnd function evaluates the @humps function handle using feval. A small portion of the fminbnd M-file is shown below. In line 1, the funfcn input parameter receives the function handle, @humps, that was passed in. The feval statement, in line 113, evaluates the handle.
```
1    function [xf,fval,exitflag,output] = ...
         fminbnd(funfcn,ax,bx,options,varargin)
            .
            .
            .
113  fx = feval(funfcn,x,varargin{:});
```

### 函数接口

可以使用函数句柄方法来构造接口函数，避免超长API引用。

```
>> Np = @(x)mesh.Shape.MassMatrix
>> Np()

ans =

  Columns 1 through 5

    0.0261    0.0040   -0.0051    0.0058   -0.0060
    0.0040    0.1558    0.0125   -0.0141    0.0146
   -0.0051    0.0125    0.2584    0.0181   -0.0188
    0.0058   -0.0141    0.0181    0.3261    0.0211
   -0.0060    0.0146   -0.0188    0.0211    0.3497
    0.0058   -0.0141    0.0181   -0.0204    0.0211
   -0.0051    0.0125   -0.0161    0.0181   -0.0188
    0.0040   -0.0097    0.0125   -0.0141    0.0146
   -0.0016    0.0040   -0.0051    0.0058   -0.0060

  Columns 6 through 9

    0.0058   -0.0051    0.0040   -0.0016
   -0.0141    0.0125   -0.0097    0.0040
    0.0181   -0.0161    0.0125   -0.0051
   -0.0204    0.0181   -0.0141    0.0058
    0.0211   -0.0188    0.0146   -0.0060
    0.3261    0.0181   -0.0141    0.0058
    0.0181    0.2584    0.0125   -0.0051
   -0.0141    0.0125    0.1558    0.0040
    0.0058   -0.0051    0.0040    0.0261
```
