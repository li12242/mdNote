# Implementing Operators

重载操作符方法

**Overloading Operators**
You can implement MATLAB operators (+, *, >, etc.) to work with objects of your class. Do this by defining the relevant functions as class methods.

Each built-in MATLAB operator has an associated function (e.g., the + operator has an associated plus.m function). You can overload any operator by creating a class method with the appropriate name.

Overloading enables operators to handle different types and numbers of input arguments and perform whatever operation is appropriate for the highest precedence object.

**Object Precedence**
User-defined classes have a higher precedence than built-in classes. For example, if q is an object of class double and p is a user-defined class, MyClass, both of these expressions:

    q+p
    p+q

generate a call to the plus method in the MyClass, if it exists. Whether this method can add objects of class double and class MyClass depends on how you implement it.

When p and q are objects of different classes, MATLAB applies the rules of precedence to determine which method to use.

“Object Precedence in Expressions Using Operators” on page 7-30 provides information on how MATLAB determines which overloaded method to call.

**Examples of Overloaded Operators**
“Defining Arithmetic Operators for DocPolynom” on page 16-14 provides examples of overloaded operators.
