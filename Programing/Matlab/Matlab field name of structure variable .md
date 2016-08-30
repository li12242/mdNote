# Matlab structure variable field name

写一个函数，能够向结构数组任意添加变量。
困难在于，如何将字符串作为结构数组的field name？

```
clear all
str = 'mesh';
a.(str) = [1,2,3]
```

Matlab返回值

```
a =

    mesh: [1 2 3]

```

可见，用括号将(str)变量括起来后，便能用str储存的字符串作为结构数组a的属性名称。
