# Property Set Methods

set 函数使用方法

**Property Set Methods**
Property set methods have the following syntax, where PropertyName is the name of the property.

```
methods % No method attributes
    function obj = set.PropertyName(obj,value) % Value class
end
```

Here obj is the object whose property is being assigned a value and value is the new value that is assigned to the property.

Value class set functions must return the object with the new value for the property assigned. Value classes replace the object whose property is being assigned with the object returned by the set method. **Handle classes do not need to return the modified object.**

```
methods % No method attributes
    function set.PropertyName(obj,value) % Handle class
end
```

The property set method can perform actions like error checking on the input value before taking whatever action is necessary to store the new property value.

```
function obj = set.PropertyName(obj,value)
    if ~(value > 0)
        error('Property value must be positive')
    else
        obj.PropertyName = value;
    end
end
```

See “Restricting Properties to Specific Values” on page 2-25 for an example of a property set method.

**Set Method Behavior**
If a property set method exists, MATLAB calls it whenever a value is assigned to that property. However, MATLAB does NOT call property set methods
in the following cases:

* Assigning a value to a property from within its own property set method, which prevents recursive calling of the set method
* Specifying default values in class definitions do not invoke the set method
* Assigning a property to its default value, which is specified in the class
definition
* Copying a value object (that is, not derived from the handle class). Neither the set or get method is called when copying property values from one object to another.
* Assigning a property value that is the same as the current value when the property’s AbortSet attribute is true does not call the property’s set method. See “Aborting Set When Value Does Not Change” on page 9-31 for more information on this attribute.

When assigning a property value, the calling function’s copy of the object that has been passed to the set method reflects the changed value. Therefore, an assignment to even a single property is able to affect the whole object. This behavior enables a set method to change other properties in the object as well as its designated property.

For example, a graphics window object can have a Units property and a Size property. Changing the Units property can also require a change to the values of the Size property to reflect the new units.
