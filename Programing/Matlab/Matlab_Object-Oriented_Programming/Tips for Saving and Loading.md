# Tips for Saving and Loading

### Using Default Property Values to Reduce Storage
When loading an object, MATLAB® creates a new object and assigns the stored property values. For properties that had default values at the time you saved the object, MATLAB loads the saved default values, even if the class definition defines new default values for those properties.

See Defining Default Values for more information on how MATLAB evaluates default value expressions.

**Reducing Object Storage**
If a property is often set to the same value, define a default value for that property. When the object is saved to a MAT-file, MATLAB does not save the default value, thereby, saving storage space.

**Implementing Forward and Backward Compatibility**
Default property values can help you implement version compatibility for saved objects. For example, if you add a new property to version 2 of your class, having a default value enables MATLAB to assign a value to the new property when loading a version 1 object.

Similarly, if version 2 of your class removes a property, then if a version 2 object is saved and loaded into version 1, your loadobj method can use the default value from version 1 for the version 2 object.

### Avoiding Property Initialization Order Dependency
**Use a Dependent property when the property value needs to be calculated at runtime.** Whenever you can use a dependent property in your class definition you save storage for saved objects. Dependent is a property attribute (see Property Attributes for a complete list.)

**Controlling Property Loading**
If your class design is such that **setting one property value causes other property values to be updated**, then you can use dependent properties to ensure objects load properly. For example, consider the following Odometer class. It defines two public properties: TotalDistance and Units. Whenever Units is modified, the TotalDistance is modified to reflect the change. There is also a private property, PrivateUnits, and a constant property ConversionFactor.

```
classdef Odometer
   properties(Constant)
      ConversionFactor = 1.6
   end
   properties
      TotalDistance = 0
   end
   properties(Dependent)
      Units
   end
   properties(Access=private)
      PrivateUnits = 'mi'
   end
   methods
      function unit = get.Units(obj)
         unit = obj.PrivateUnits;
      end
      function obj = set.Units(obj, newUnits)
         % validate newUnits to be a string
         switch(newUnits)
            case 'mi'
               if strcmp(obj.Units, 'km')
                  obj.TotalDistance = obj.TotalDistance / ...
                     obj.ConversionFactor;
                  obj.PrivateUnits = newUnits;
               end
            case 'km'
               if strcmp(obj.Units, 'mi')
                  obj.TotalDistance = obj.TotalDistance * ...
                     obj.ConversionFactor;
                  obj.PrivateUnits = newUnits;
               end
            otherwise
               error('Odometer:InvalidUnits', ...
                  'Units ''%s'' is not supported.', newUnits);
         end
      end
   end
end
```

Suppose you create an instance of Odometer with the following property values:

    odObj = Odometer;
    odObj.Units = 'km';
    odObj.TotalDistance = 16;

When you save the object, the following happens to property values:

* ConversionFactor is not saved because it is a Constant property.
* TotalDistance is saved.
* Units is not saved because it is a Dependent property.
* PrivateUnits is saved and provides the storage for the current value of Units.

When you load the object, the following happens to property values:

* ConversionFactor is obtained from the class definition.
* TotalDistance is loaded from the saved object.
* Units is not loaded so its set method is not called.
* PrivateUnits is loaded and contains the value that is used if the Units get method is called.

If the `Units` property was not `Dependent`, loading it calls its set method and causes the TotalDistance property to be set again.

### When to Use Transient Properties

The value of a Transient property is never stored when an object is saved to a file, but instances of the class do allocate storage to hold a value for this property. These two characteristics make a Transient property useful for cases where data needs to be stored in the object temporarily as an intermediate computation step, or for faster retrieval. (See Property Attributes for a complete list of properties.)

You can use Transient properties to reduce storage space and simplify the load process in cases where:

* The property data can be easily reproduced at run-time.
* The property represent intermediate state that you can discard

### Calling Constructor When Loading

MATLAB does not call the class constructor when loading an object from a MAT-file. However, if you set the ConstructOnLoad class attribute to true, load does call the constructor with no arguments.

Enabling ConstructOnLoad is useful when you do not want to implement a loadobj method, but do need to perform some actions at construction time, such as registering listeners for another object. You must be sure that the class constructor can be called with no arguments without generating an error. See No Input Argument Constructor Requirement.

In cases where the class constructor sets only some property values based on input arguments, then using ConstructOnLoad is probably not useful. See Passing Arguments to Constructors During Load for an alternative.
