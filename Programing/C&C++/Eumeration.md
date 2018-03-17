# C++枚举

定义格式：枚举类型的定义格式为：

    enum <类型名> {<枚举常量表>};

## 提示

* 枚举常量代表该枚举类型的变量可能取的值，编译系统为每个枚举常量指定一个整数值，缺省状态下，这个整数就是所列举元素的序号，序号从0开始。
* 各枚举常量的值可以重复
```
    //枚举常量apple=0,orange=1, banana=1, peach=2, grape=3
    enum fruit_set {apple, orange, banana=1, peach, grape}
```
* 枚举常量只能以标识符形式表示，而不能是整型、字符型等文字常量。
```
    enum letter_set {a, d, F, s, T};
    //枚举常量不能是字符常量
    enum letter_set {'a','d','F','s','T'}; 
```

## 枚举变量的使用
定义枚举类型的主要目的是：增加程序的可读性。
枚举类型最常见也最有意义的用处之一就是用来描述状态量。定义枚举类型之后，就可以定义该枚举类型的变量

## 操作

* 枚举变量的值只能取枚举常量表中所列的值，就是整型数的一个子集。
* 枚举变量占用内存的大小与整型数相同。
* 枚举变量只能参与赋值和关系运算以及输出操作，参与运算时用其本身的整数值。例如，设有定义：
```
    enum color_set1 {RED, BLUE, WHITE, BLACK} color1, color2;
    enum color_set2 { GREEN, RED, YELLOW, WHITE} color3, color4;

    color3=RED;           //将枚举常量值赋给枚举变量
    color4=color3;        //相同类型的枚举变量赋值，color4的值为RED
    int  i=color3;        //将枚举变量赋给整型变量，i的值为1
    int  j=GREEN;         //将枚举常量赋给整型变量，j的值为0
```

* 允许的关系运算有：==、<、>、<=、>=、!=等，例如：
```
    //比较同类型枚举变量color3，color4是否相等
    if (color3==color4) cout<<”相等”；
    //输出的是变量color3与WHITE的比较结果，结果为1
    cout<< color3<WHITE;        
```

* 枚举变量可以直接输出，输出的是变量的整数值。例如：
```
    cout<< color3; //输出的是color3的整数值，即RED的整数值1
```
