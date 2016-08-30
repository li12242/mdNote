#Matlab指针

第一印象貌似是Matlab中不存在指针，所有函数都是按值传递的，没有办法修改参数，其实Matlab提供了句柄作为指针代替品。只要我们利用对象+句柄的方法，就可以像使用指针一样来操作数据。

*Matlab Object-Oriented Programming* 

ch5. Value or Handle Class

>A value class constructor returns an instance that is associated with the variable to which it is assigned. If you reassign this variable, MATLAB creates a copy of the original object. If you pass this variable to a function, the function must return the modified object.

>A handle class constructor returns a handle object that is a reference to the object created. You can assign the handle object to multiple variables or pass it to functions without causing MATLAB to make a copy of the original object. A function that modifies a handle object passed as an input argument does not need to return the object.

首先给个类的文件`@Filewriter/Filewriter.m`

```matlab
classdef Filewriter < handle
    properties(SetAccess=private, GetAccess=public)
        numMatlab
    end

    methods
    % Construct an object and set num
        function obj = Filewriter(num)
            obj.num = num;
        end

        function addOne(obj)
            obj.num = obj.num +1;
        end
        
    end % methods
end % class
```

我们通过如下语句使用这个自定义的对象：
	
	file = Filewriter(1)
	
这句代码实现了两个功能，将类实例化为一个对象（object），并将该对象的句柄赋给变量`file`。

毫无疑问，我们调用`file.addOne`就可以对变量`file`自身进行操作，这就类似一种指针。

但是我们还是不放心，假如我调用下面语句，我是将句柄给了`other_file`，还是另外为其实例化了一个对象？

	other_file = file;
	
用下面方法验证


```matlab
>> other_file = file

other_file = 

  Filewriter with properties:

    num: 2

>> other_file.addOne
>> file

file = 

  Filewriter with properties:

    num: 3
```

可以看到，通过句柄`other_file`对实例化的对象进行的操作直接作用在`file`所指对象上。因此，Matlab 中句柄作用和指针类似。