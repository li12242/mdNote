#Matlab Object-Oriented Programming

##MATLAB Classes Overview

###MATLAB Classes — Key Terms

* Class definition — Description of what is common to every instance of a class.
* Properties — Data storage for class instances
* Methods — Special functions that implement operations that are usually
performed only on instances of the class
* Events — Messages that are defined by classes and broadcast by class instances when some specific action occurs
* Attributes — Values that modify the behavior of properties, methods, events, and classes
* Listeners — Objects that respond to a specific event by executing a callback function when the event notice is broadcast
* Objects — Instances of classes, which contain actual data values stored in the objects’ properties
* Subclasses — Classes that are derived from other classes and that inherit the methods, properties, and events from those classes (subclasses facilitate the reuse of code defined in the superclass from which they are derived).
* Superclasses — Classes that are used as a basis for the creation of more specifically defined classes (i.e., subclasses).
* Packages — Folders that define a scope for class and function naming

###Example 1. bank account
银行账户具有属性

* An account number
* An account balance
* A current status (open, closed, etc.)

银行账户具有操作

* Deposit money
* Withdraw money

---

##Building on Other Classes

###Constructing Subclasses

**subclass 在构造函数中一定要调用 superclass 的构造函数**

**Subclass constructor functions must explicitly call superclass constructors if the superclass constructors require input arguments.** The subclass constructor must specify these arguments in the call to the superclass constructor using the constructor output argument and the returned object must be assigned to the constructor output argument. Here is the syntax:

```
classdef MyClass < SuperClass 
   function obj = MyClass(arg)
      obj = obj@SuperClass(ArgumentList);
         ...
   end
end
```

The class constructor must make all calls to superclass constructors before any other references to the object, such as assigning property values or calling ordinary class methods. Also, a subclass constructor can call a superclass constructor only once.

Reference Only Specified Superclasses
The constructor cannot call a superclass constructor with this syntax if the classdef does not specify the class as a superclass.

    classdef MyClass < SuperClass

MATLAB calls any uncalled constructors in the left-to-right order in which they are specified in the classdef line. MATLAB passes no arguments to these functions.

**Make No Conditional Calls to Superclass Constructors**

Calls to superclass constructors must be unconditional and you can have only one call for any given superclass. You must initialize the superclass portion of the object by calling the superclass constructors before you can use the object (for example., to assign property values or call class methods).

In cases where you need to call superclass constructors with different arguments depending on some condition, you can conditionally build a cell array of arguments and provide one call to the constructor.

For example, in the following example the superclass shape constructor is called using some default values when the cube constructor has been called with no arguments:

```
classdef cube < shape
   properties
      SideLength = 0;
      Color = [0 0 0];
   end
   methods
      function cube_obj = cube(length,color,upvector,viewangle) 
         if nargin == 0 % Provide default values if called with no arguments
            super_args{1} = [0 0 1];
            super_args{2} = 10;
         else
            super_args{1} = upvector;
            super_args{2} = viewangle;
         end
         cube_obj = cube_obj@shape(super_args{:});
         if nargin > 0 % Use value if provided
            cube_obj.SideLength = length;
            cube_obj.Color = color;
         end
      ...
   end
   ...
end
```

**Zero or More Superclass Arguments**

If you are calling the superclass constructor from the subclass constructor and you need to support the case where you call the superclass constructor with no arguments, you must explicitly provide for this syntax.

Suppose in the case of the cube class example above, all property values in the shape superclass and the cube subclass have initial values specified in the class definitions that create a default cube. Then you could create an instance of cube without specifying any arguments for the superclass or subclass constructors. Here is how you can implement this behavior in the cube constructor:

```
function obj = cube(length,color,upvector,viewangle) 
   if nargin == 0 
% Create empty cell array if no input argsuments
      super_args = {}; 
   else
% Use specified argsuments
      super_args{1} = upvector;
      super_args{2} = viewangle;
   end
% Call the superclass constructor with the 
% empty cell array (no arguments) if nargin == 0
% otherwise cell array is not empty
   cube_obj = cube_obj@shape(super_args{:});
   if nargin > 0 
      cube_obj.SideLength = length;
      cube_obj.Color = color;
   end
   ...
end
```

###Modifying Superclass Methods

An important concept in class design is that a subclass object is also an object of its superclass. Therefore, you can pass a subclass object to a superclass method and have the method execute properly. At the same time, you can apply special processing to the unique aspects of the subclass. Some useful techniques include:

**Calling a superclass method from within a subclass method**

Redefining in the subclass protected methods called from within a public superclass method
Defining the same named methods in both super and subclass, but using different implementations

**Extending Superclass Methods**

Subclass methods can call superclass methods of the same name. This fact enables you to extend a superclass method in a subclass without completely redefining the superclass method. For example, suppose that both superclass and subclass defines a method called foo. The method names are the same so the subclass method can call the superclass method. However, the subclass method can also perform other steps before and after the call to the superclass method. It can operate on the specialized parts to the subclass that are not part of the superclass.

For example, this subclass defines a foo method, which calls the superclass foo method
```
classdef sub < super
   methods
      function foo(obj)
         preprocessing steps 
         foo@super(obj); % Call superclass foo method
         postprocessing steps
      end 
   end
end
```
See Invoking Superclass Methods in Subclass Methods for more on this syntax.

**Completing Superclass Methods**

A superclass method can define a process that executes in a series of steps using a protected method for each step (Access attribute set to protected). Subclasses can then create their own versions of the protected methods that implement the individual steps in the process.

Implement this technique as shown here:
```
classdef super
   methods 
      function foo(obj)
         step1(obj)
         step2(obj)
         step3(obj)
      end
   end
   methods (Access = protected)
      function step1(obj)
         superclass version
      end
      ...
   end
end
```

The subclass does not reimplement the foo method, it reimplements only the methods that carry out the series of steps (step1(obj), step2(obj), step3(obj)). That is, the subclass can specialize the actions taken by each step, but does not control the order of the steps in the process. When you pass a subclass object to the superclass foo method, MATLAB® calls the subclass step methods because of the dispatching rules.

```
classdef sub < super
   ...
   methods (Access = protected)
      function step1(obj)
         subclass version
      end
      ...
   end
end
```

**Redefining Superclass Methods**

You can completely redefine a superclass method. In this case, both the superclass and the subclass would define the same named method.

**Modifying Superclass Properties**

There are two separate conditions under which you can redefine superclass properties:

**The value of the superclass property Abstract attribute is true**

The values of the superclass property SetAccess and GetAccess attributes are private
In the first case, the superclass is just requesting that you define a concrete version of this property to ensure a consistent interface. In the second case, only the superclass can access the private property, so the subclass is free to reimplement it in any way.

**Private Local Property Takes Precedence in Method**

When a subclass property has the same name as a superclass private property, and a method of the superclass references the property name, MATLAB always accesses the property defined by the calling method's class. For example, given the following classes, Sub and Super:

```
classdef Super
   properties (Access = private)
      Prop = 2;
   end
   methods
      function p = superMethod(obj)
         p = obj.Prop; 
      end
   end
end
classdef Sub < Super
   properties 
      Prop = 1;
   end
end
```

If you create an instance of the subclass and use it to call the superclass method, MATLAB access the private property of the method's class:

```
subObj = Sub
subObj = 

  Sub with properties:

    Prop: 1

subObj.superMethod
ans =

     2
```

###Subclassing Multiple Classes

####Class Member Compatibility

When you create a subclass derived from multiple classes, the subclass inherits the properties, methods, and events defined by all specified superclasses. If more than one superclass defines a property, method, or event having the same name, there must be an unambiguous resolution to the multiple definitions. You cannot derive a subclass from any two or more classes that define incompatible class members.

There are various situations where you can resolve name and definition conflicts, as described in the following sections.

Property Conflicts
If two or more superclasses define a property with the same name, then at least one of the following must be true:

All, or all but one of the properties must have their SetAccess and GetAccess attributes set to private
The properties have the same definition in all superclasses (for example, when all superclasses inherited the property from a common base class)
Method Conflicts
If two or more superclasses define methods with the same name, then at least one of the following must be true:

The method's Access attribute is private so only the defining superclass can access the method.
The method has the same definition in all subclasses. This situation can occur when all superclasses inherit the method from a common base class and none of the superclasses override the inherited definition.
The subclass redefines the method to disambiguate the multiple definitions across all superclasses. This means that the superclass methods must not have their Sealed attribute set to true.
Only one superclass defines the method as Sealed, in which case, the subclass adopts the sealed method definition.
The superclasses define the methods as Abstract and rely on the subclass to define the method.
Event Conflicts
If two or more superclasses define events with the same name, then at least one of the following must be true:

The event's ListenAccess and NotifyAccess attributes must be private.
The event has the same definition in all superclasses (for example, when all superclasses inherited the event from a common base class)
Using Multiple Inheritance
Resolving the potential conflicts involved when defining a subclass from multiple classes often reduces the value of this approach. For example, problems can arise when you enhance superclasses in future versions and introduce new conflicts.

Reduce potential problems by implementing only one unrestricted superclass. In all other superclasses, all methods are abstract and must be defined by a subclass or inherited from the unrestricted superclass.

In general, when using multiple inheritance, ensure that all superclasses remain free of conflicts in definition.

See Defining a Subclass for the syntax used to derive a subclass from multiple superclasses.

See Supporting Both Handle and Value Subclasses for techniques that provide greater flexibility when using multiple superclasses.

###Defining Abstract Classes

####Abstract Classes

Abstract classes are useful for describing functionality that is common to a group of classes, but requires unique implementations within each class.

Abstract Class Terminology:
* abstract class — A class that cannot be instantiated, but that defines class components used by subclasses.

* abstract members — Properties or methods declared in an abstract class, but implemented in subclasses.

* concrete members — Properties or methods that are fully implement by a class.

* concrete class — A class that can be instantiated. Concrete classes contain no abstract members.

* interface — An abstract class describing functionality that is common to a group of classes, but that requires unique implementations within each class. The abstract class defines the interface of each subclass without specifying the actual implementation.

An abstract class serves as a basis (that is, a superclass) for a group of related subclasses. An abstract class can define abstract properties and methods that subclasses must implement. Each subclass can implement the concrete properties and methods in a way that supports their specific requirements.

Abstract classes can define properties and methods that are not abstract, and do not need to define any abstract members. Abstract classes pass on their concrete members through inheritance.

Implementing a Concrete Subclass
A subclass must implement all inherited abstract properties and methods to become a concrete class. Otherwise, the subclass is itself an abstract class.

Declaring Classes as Abstract
A class is abstract when it declares:

####An abstract method

An abstract property
The Abstract class attribute
A subclass of an abstract class is itself abstract if it does not define concrete implementations for all inherited abstract methods or properties.

Abstract Methods
Define an abstract method:

```
methods (Abstract)
   abstMethod(obj)
end
```

For methods that declare the Abstract method attribute:

Do not use a function...end block to define an abstract method, use only the method signature.

Abstract methods have no implementation in the abstract class.
Concrete subclasses are not required to support the same number of input and output arguments and do not need to use the same argument names. However, subclasses generally use the same signature when implementing their version of the method.
Abstract Properties
Define an abstract property:

```
properties (Abstract)
   AbsProp
end
```

For properties that declare the Abstract property attribute:

Concrete subclasses must redefine abstract properties without the Abstract attribute, and must use the same values for the SetAccess and GetAccess attributes as those used in the abstract superclass.
Abstract properties cannot define set or get access methods (see Property Access Methods) and cannot specify initial values. The subclass that defines the concrete property can create set or get access methods and specify initial values.
Abstract Class
Declare a class as abstract in the classdef statement:

```
classdef (Abstract) AbsClass 
   ...
end
```

For classes that declare the Abstract class attribute:

Concrete subclasses must redefine any properties or methods that are declared as abstract.
The abstract class does not need to define any abstract methods or properties.
When you define any abstract methods or properties, MATLAB® automatically sets the class Abstract attribute to true.

Determine If a Class Is Abstract
Determine if a class is abstract by querying the Abstract property of its meta.class object. For example, the AbsClass defines two abstract methods:

```
classdef AbsClass
   methods(Abstract, Static)
      result = absMethodOne
      output = absMethodTwo
   end
end
```
Use the logical value of the meta.class Abstract property to determine if the class is abstract:
```
mc = ?AbsClass;
if ~mc.Abstract
   % not an abstract class
end
```

Display Abstract Member Names
Use the meta.abstractDetails function to display the names of abstract properties or methods and the names of the defining classes:

```
meta.abstractDetails('AbsClass');
Abstract methods for class AbsClass:
   absMethodTwo   % defined in AbsClass
   absMethodOne   % defined in AbsClass
```

Find Inherited Abstract Properties and Methods
The meta.abstractDetails function returns the names and defining class of any inherited abstract properties or methods that you have not implemented in your subclass. This can be useful if you want the subclass to be concrete and need to determine what abstract members the subclass inherits.

For example, suppose you subclass AbsClass, which is described in the Determine If a Class Is Abstract section:

```
classdef SubAbsClass < AbsClass
% Failed to implement absMethodOne
% defined as abstract in AbsClass
   methods (Static)
      function out = absMethodTwo(a,b)
         out = a + b;
      end
   end
end
```

Determine if you implemented all inherited class members using meta.abstractDetails:

```
meta.abstractDetails(?SubAbsClass)
```

Abstract methods for class SubAbsClass:

      absMethodOne   % defined in AbsClass

The SubAbsClass class itself is abstract because it has not implemented the absMethodOne defined in AbsClass.

---

**Defining Class-Related Functions**

在类文件内定义子函数 Subfunction

You can define functions that are not class methods in the file that contains the class definition (classdef). Define subfunctions outside of the classdef - end block, but in the same file as the class definition. Subfunctions defined in classdef files work like subfunctions. You can call these subfunctions from anywhere in the same file, but they are not visible outside of the file in which you define them.

Subfunctions in classdef files are useful for utility functions that you use only within that file. These functions can take or return arguments that are instances of the class but, it is not necessary, as in the case of ordinary methods. For example, the following code defines myUtilityFcn outside the classdef block:

```
classdef MyClass 
   properties
      PropName
   end 
   methods
      function obj = MyClass(arg1) 
         obj.PropName = arg1;
      end
   end % methods
end % classdef
function myUtilityFcn
...
end
```

You also can create package functions, which require you to use the package name when calling these functions. See “Create a Namespace with Packages” on page 4-21 for more information on packages

