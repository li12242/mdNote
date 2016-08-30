# Enumerations

**Terminology and Concepts**

This documentation uses terminology as described in the following list:

* Enumeration or Enumeration class — A class that contains an enumeration block defining enumeration members.
* Enumeration member — A named instance of an enumeration class.
* Enumeration member constructor arguments — Values in parentheses next to the enumeration member name in the enumeration block. When you create an instance of an enumeration member, MATLAB passes the value or values in parenthesis to the class constructor.
* Underlying value — For enumerations derived from built-in classes, the value associated with an instance of an enumeration class (that is, an enumeration member).

**Using Enumeration Classes**
Create an enumeration class by adding an enumeration block to a class definition. For example, the WeekDays class enumerates a set of days of the week.

```
classdef WeekDays
    enumeration
        Monday, Tuesday, Wednesday, Thursday, Friday
    end
end
```

**Constructing an Enumeration Member**
Refer to an enumeration member using the class name and the member name:
ClassName.MemberName
For example, assign the enumeration member WeekDays.Tuesday to the variable today:

    today = WeekDays.Tuesday;

today is a variable of class WeekDays:
```
>> whos
    Name    Size    Bytes   Class       Attributes
    today   1x1     56      WeekDays    Enumerations
>> today

today =

    Tuesday
```

**Default Methods**
Enumeration classes have four methods by default:
```
>> methods(today)
Methods for class WeekDays:
WeekDays    char    eq      ne
```

* Default constructor (WeekDays in this case)
* char — converts enumeration members to character strings
* eq — enables use of == in expressions
* ne — enables use of ~= in expressions

Equality and inequality methods enable you to use enumeration members in if and switch statements and other functions that test for equality.

Because you can define enumeration members with descriptive names, conversion to char is useful. For example:

```
today = WeekDays.Friday; ['Today is ',char(today)] ans =
Today is Friday
```

**Testing for Membership in a Set**
Suppose you want to determine if today is a meeting day for your team.
```
today = WeekDays.Tuesday;
teamMeetings = [WeekDays.Wednesday WeekDays.Friday];
```

Use the ismember function to determine if today is a meeting day:
```
ismember(today,teamMeetings)
ans =
        0
```
