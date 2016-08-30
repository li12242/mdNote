#Matlab object array

构造 Matlab 对象数组

**注意，目前没有找到实现在 Matlab 类中添加对象数组属性的方法**

###Initialize Object Arrays

**Calls to Constructor**

During the creation of object arrays, MATLAB® can call the class constructor with no arguments, even if the constructor does not build an object array. For example, suppose that you define the following class:

```
classdef SimpleValue
   properties
      Value
   end
   methods
      function obj = SimpleValue(v)
         obj.Value = v;
      end
   end
end
```

Execute the following statement to create an array:

```
>>a(1,7) = SimpleValue(7)

    Error using SimpleValue (line 7)
    Not enough input arguments.
```

This error occurs because MATLAB calls the constructor with no arguments to initialize elements 1 through 6 in the array.

Your class must support the no input argument constructor syntax. A simple solution is to test nargin and let the case when nargin == 0 execute no code, but not error:

```
classdef SimpleValue
   properties
      Value
   end
   methods
      function obj = SimpleValue(v)
         if nargin > 0
            obj.Value = v;
         end
      end
   end
end
```

Using the revised class definition, the previous array assignment statement executes without error:

    a(1,7) = SimpleValue(7)


The object assigned to array element a(1,7) uses the input argument passed to the constructor as the value assigned to the property:

```
>>a(1,7)
ans = 
  SimpleValue with properties:

    Value: 7
```

MATLAB created the objects contained in elements a(1,1:6) with no input argument. The default value for properties empty []. For example:

```
a(1,1)
ans = 
  SimpleValue with properties:

    Value: []
```

MATLAB calls the SimpleValue constructor once and copies the returned object to each element of the array.

---

总结：为使能够构造对象数组，该对象构造函数必需能够在无输入参数情况下调用
