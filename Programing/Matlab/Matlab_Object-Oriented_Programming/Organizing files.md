# Organizing files

### Organizing Files in Package

* +folder

The `+folder` piece is a MATLAB **package folder**. If you place `Tata.m` in a location like `+folder/Tata.m`, it will be known to MATLAB as the class `folder.Tata`. If you place it in a folder like `someOtherFolder/Tata.m`, or `someOtherFolder/@Tata/Tata.m`, it will be known to MATLAB as `Tata`.

**package folder: +folder**
MATLAB has a notion of packages which can be nested and include both classes and functions.

Just make a directory somewhere on your path with a + as the first character, like `+mypkg`. Then, if there is a class or function in that directory, it may be referred to as `mypkg.mything`. You can also import from a package using

      import mypkg.mysubpkg.*.

The one main gotcha about moving a bunch of functions into a package is that functions and classes do not automatically import the package they live in. This means that if you have a bunch of functions in different m-files that call each other, you may have to spend a while dropping imports in or qualifying function calls. Don't forget to put imports into subfunctions that call out as well.

**Accessing Class Members — Various Scenarios**
This section shows you how to access various package members from outside a package. Suppose you have a package mypack with the following contents:

+mypack
+mypack/myfcn.m
+mypack/@myfirstclass
+mypack/@myfirstclass/myfcn.m
+mypack/@myfirstclass/otherfcn.m
+mypack/@myfirstclass/myfirstclass.m
+mypack/@mysecondclass
+mypack/@mysecondclass/mysecondclass.m
+mypack/+mysubpack
+mypack/+mysubpack/myfcn.m
Invoke the myfcn function in mypack:

mypack.myfcn(arg)
Create an instance of each class in mypack:

obj1 = mypack.myfirstclass;
obj2 = mypack.mysecondclass(arg);
Invoke the myfcn function in mysubpack:

mypack.mysubpack.myfcn(arg1,arg2);
If mypack.myfirstclass has a method called myfcn, it is called as any method call on an object:

obj = mypack.myfirstclass;
myfcn(obj,arg);
If mypack.myfirstclass has a property called MyProp, it can be assigned using dot notation and the object:

obj = mypack.myfirstclass;
obj.MyProp = some_value;

### Organizing Classes in Folders

**Options for Class Folders**
There are two types of folders that can contain class definitions. Each behave differently in a number of respects.

* **@-folders** — Folder name begins with “@” and is not on the MATLAB path, but its parent folder is on the path. **Use this type of folder when you want to use multiple files for one class definition**. You can define only one class per folder and the name of the class must match the name of the folder, without the “@” symbol (@MyClass/MyClass.m, @MyClass/MyMethod.m, and so on).

* **path folders** — Folder name does not use an @ character and is itself on the MATLAB path. **Use this type of folder when you want multiple classes in one folder.** Define each class in one file only (MyClass1.m, MyClass2.m, and so on)

See the path function for information about the MATLAB path.

**@-Folders**
An @-folder is contained by a path folder, but is not itself on the MATLAB path. Place the class definition file inside the @-folder, which can also contain method files. The class definition file must have the same name as the @-folder (without the @-sign) and the class definition (beginning with the classdef key word) must appear in the file before any other code (white space and comments do not constitute code). The name of the class must match the name of the file that contains the class definition.

You must use an @-folder if you want to use more than one file for your class definition. Methods defined in separate files match the file name to the function name. All files have a .m extension.

**Path Folders**
You can locate class definition files in folders that are on the MATLAB path. These classes are visible on the path like any ordinary function. Class definitions placed in path folders behave like any ordinary function with respect to precedence—the first occurrence of a name on the MATLAB path takes precedence over all subsequent occurrences.

The name of the file must match the name of the class, as specified with
the classdef key word. Using a path folder eliminates the need to create a separate @-folder for each class. However, the entire class definition must be contained within a single file. All files have a .m extension.

**Access to Functions Defined in Private Folders**
Private folders contain functions that are accessible only from functions defined in folders immediately above the private folder (See “Private Functions” for more information). If a class folder contains a private folder, only the class (or classes) defined in that folder can access functions defined in the private folder. Subclasses do not have access to superclass private functions.

If you want a subclass to have access to the private functions of the superclass, define the private functions as protected methods of the superclass (that is, in a methods block with the Access attribute defined a protected).


**No Class Definitions in Private Folders**
You cannot put class definitions in private folders because doing so would not meet the requirements for @ or path folders.

**Previous Behavior of Classes Defined in @-Folders**
In MATLAB Versions 5 through 7, @-folders do not shadow other @-folders having the same name, but residing in later path folders. Instead, the class is defined by the combination of methods from all @-folders having the same name. This is no longer true.

Note that for backward compatibility, classes defined in @-folders always take precedence over functions and scripts having the same name, even those that come before them on the path.
