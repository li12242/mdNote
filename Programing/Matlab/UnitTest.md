# Matlab 单元测试介绍

## 1. 单元测试脚本

详见 [Write Script-Based Unit Tests](http://cn.mathworks.com/help/matlab/matlab_prog/write-script-based-unit-tests.html)。

脚本文件必须满足以下要求：
* 脚本文件名中必须包含 `test` 单词，大小写皆可。
* 不同的单元测试分在不同的段落（section）里。假如 Matlab 在某个段落内遇到错误，会继续执行其他段落中的测试。
* 在测试脚本中，共享变量出现在任何测试段落之前。测试段落共享这个段落内变量，在测试函数中，你可以修改这些共享变量，但是在随后的测试中，这些变量重新设置为共享段落内设置的初始值。
* 在共享段落内，定义任何测试所需要的条件。假如输入或输出不满足此条件，测试不会执行。
* 当脚本作为测试运行时，定义在一个测试模块内的变量无法在另一个测试中读取，除非它定义在共享段落内。同样的，在其他工作空间的变量无法被测试读取。
* 在测试浮点数是否相等时，应设置一个允许阀值。

例如，一个计算直角三角形三个角度的函数，通过输入两个直角边长，返回各个角的大小。
```
function angles = rightTri(sides)

    A = atand(sides(1)/sides(2));
    B = atand(sides(2)/sides(1));
    hypotenuse = sides(1)/sind(A);
    C = asind(hypotenuse*sind(A)/sides(1));

    angles = [A B C];

end
```

对应的测试脚本为

```
% test triangles
tri = [7 9];
triIso = [4 4];
tri306090 = [2 2*sqrt(3)];
triSkewed = [1 1500];

% Define an absolute tolerance
tol = 1e-10;

% preconditions
angles = rightTri(tri);
assert(angles(3) == 90,'Fundamental problem: rightTri not producing right triangle')

%% Test 1: sum of angles
angles = rightTri(tri);
assert(sum(angles) == 180)

angles = rightTri(triIso);
assert(sum(angles) == 180)

angles = rightTri(tri306090);
assert(sum(angles) == 180)

angles = rightTri(triSkewed);
assert(sum(angles) == 180)

%% Test 2: isosceles triangles
angles = rightTri(triIso);
assert(angles(1) == 45)
assert(angles(1) == angles(2))

%% Test 3: 30-60-90 triangle
angles = rightTri(tri306090);
assert(abs(angles(1)-30) <= tol)
assert(abs(angles(2)-60) <= tol)
assert(abs(angles(3)-90) <= tol)

%% Test 4: Small angle approximation
angles = rightTri(triSkewed);
smallAngle = (pi/180)*angles(1); % radians
approx = sin(smallAngle);
assert(abs(approx-smallAngle) <= tol, 'Problem with small angle approximation')
```

运行测试，获得测试结果

```
>>result = runtests('rightTriTolTest');

Running rightTriTolTest
....
Done rightTriTolTest
__________

>>rt = table(result)

rt =

                         Name                          Passed    Failed    Incomplete    Duration      Details   
    _______________________________________________    ______    ______    __________    ________    ____________

    'rightTriTolTest/Test1_SumOfAngles'                true      false     false         0.57276     [1×1 struct]
    'rightTriTolTest/Test2_IsoscelesTriangles'         true      false     false          0.1902     [1×1 struct]
    'rightTriTolTest/Test3_30_60_90Triangle'           true      false     false         0.26102     [1×1 struct]
    'rightTriTolTest/Test4_SmallAngleApproximation'    true      false     false         0.25447     [1×1 struct]


```
