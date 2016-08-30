# 数值格式误差以及收敛精度估计方法

## 1.简介

随着高精度格式越来越多应用到CFD中，如何判断数值格式的收敛精度 (Converge Rate) 也逐渐成为一个重要问题。

## 2.收敛精度 (阶) 介绍

当我们考虑采用数值方法计算一个精确解$u$时,数值解$\tilde{u}_h$与精确解近似程度一般和一个参数$h$相关，这个近似程度可以表示为

$$\left| \tilde{u}_h - u \right| \le Ch^p$$

其中$C$是与$h$无关的常数。在式（1）中的幂次$p$就是我们常说的数值格式收敛精度（阶数）。误差$\left| \tilde{u}_h - u \right|$也可用$h$表示为

$$\tilde{u}_h - u = Ch^p + O(h^{p+1})$$

在判断CFD数值模型结果精度时，需要比较的不再仅仅是两个标量，而是数值解$\tilde{u}_h(x)$与精确解$u(x)$两个函数之间插值，此时就需要引入泛函中范数的概念。如何计算误差函数对应的范数将在第四节讨论。一般而言，若数值格式具有$p$阶空间与$q$阶时间精度，那么残差项应该满足

$$R(\Delta x, \Delta t) = E\left( \Delta x^p, \Delta t^q \right) + O(\Delta x^{p+1}, \Delta t^{q+1})$$

其中$E$为线性方程，而$p$、$q$中最小值${\mathrm{min}(p, q)}$决定了格式收敛阶大小。

## 3.收敛精度计算

通常而言，在计算NS方程时，首先会把方程在空间内进行离散，得到常微分方程（ODE）

$$\frac{\partial u}{\partial t} = L(u)$$

而求解只包含时间的常微分方程时，通常可以采用具有更高的精度格式$q>p$来减小误差（Runge-Kutta，AB）。因此，数值格式的精度主要受空间离散格式的限制。

为了求出空间离散格式收敛阶$p$，可以根据方程（2）采用网格逐次加密方法。当我们采用不同尺寸的网格计算，可以得到误差函数随网格尺寸$h$的变化关系，如分别采用$(\Delta x, \Delta t), \frac{1}{2}(\Delta x, \Delta t), \frac{1}{4}(\Delta x, \Delta t)$的步长进行计算，得到$R(\Delta x), R(\frac{1}{2}\Delta x), R(\frac{1}{4} \Delta x)$，由于

$$R(\Delta x) = E(\Delta x) + O(\Delta x^{p+1}) \approx C \Delta x^p$$

那么

$$\frac{R( \Delta x )}{R( \frac{1}{2}\Delta x )} = \frac{C\Delta x^p}{ C \left( \frac{\Delta x}{2} \right)^p }$$

因此收敛精度$p$可以采用下式进行估计

$$p = \frac{log \left( { R( \Delta x )}/{R( \frac{1}{2}\Delta x ) }\right) }{log2}$$


## 4.格式误差计算

### 4.1.范数误差定义

首先介绍范数概念。范数是表示是泛函空间内两个元素距离的函数，在泛函空间内每个函数$u(x)$都是一个元素，而$L_1$、$L_2$和$L_{\infty}$等范数表示就是两个元素之间距离。

$L_1$范数通常称为最小绝对偏差LAD（least absolute deviations）或最小绝对误差LAE（least absolute errors）。它统计目标函数$y(x)$与期望函数$f(x)$绝对误差之和

$$S = \int \left|y(x_i) - f(x_i) \right| \mathrm{dx}$$


$L_2$范数也被称为最小二乘。它通常统计目标函数与期望函数平方误差之和[^1]

$$S = \int \left|y(x_i) - f(x_i) \right|^2 \mathrm{dx}$$

$L_{\infty}$范数用来统计目标函数与期望函数之间最大误差

$$S = \mathrm{max} \left|y(x_i) - f(x_i) \right|$$

### 4.2.选取正确的范数误差函数

想要回答什么时候选取哪个范数误差进行估计十分复杂，在CFD计算中，需要根据算例以及各个范数性质选取不同的误差范数。

在CFD计算中，选取误差范数需要考虑特性包括：[^3]

1. 鲁棒性[^4]
L1-范数误差统计的数据包含异常值时，可以将数据中的异常值安全而有效地忽略。所以L1-范数适合评价具有只有极少特别大误差出现的间断解算例；
而L2-范数会将误差平方，总误差会增加很多，所以L2误差对于异常值更加敏感。因此L2-范数常用来评价几乎不存在特别大误差的连续解算例。
2. 稳定性
L1-范数具有不稳定性，精确值一个较小的水平移动会导致回归线产生特别大的改变。因此若算例没有解析解，需要采用数值方法估计收敛精度时，采用L2-范数更合适。

*Wolfgang Bangerth.*
*Professor of mathematics at Texas A&M University. Research focus is on numerical methods for partial differential equations, finite element software, the deal.II software library.*

>衡量偏微分方程求解误差时候，自然地选择是解所在的空间范数，因为范数作用就是衡量空间内两元素之间距离。举例来说，对于椭圆偏微分方程，方程解所在空间是$H^1$，所以使用$H^1$范数来估计误差就是很合适的。这样选取的意义在于，以上面例子来说，真实解不在$W^{1,\infty}$空间内，因此计算梯度的最大误差就是没有意义的，因为有可能存在真实解梯度不是有限值情况。换句话说，假如真实解在空间$H^1$中，那么用$W^{1,\infty}$范数来估计误差就是没有意义的。
另一方面，我们总是选择解空间$Y$的子空间$Z \supset Y$进行误差衡量，这里子空间指的就是L2。对于有些情况来说，这是因为其物理意义决定的，L2范数在有些情况下具有一定的物理意义：对电磁场的积分$\int E(x)^2$可以表示电磁场包含的能量；同样的，对波动方程积分可以表示其储存的势能大小。其他情况使用L2范数进行误差估计只是因为它方便。在有限元方法中，L2范数可以通过$U^TMU$方便的计算，其中$M$为质量矩阵。
例如在非恒定热传导方程里，计算L2范数误差就是错误的，因为其没有任何物理依据，总能量及总物质量所在空间都是L1空间，在这个例子里，计算L2范数除了方便以外并没有其他含义。[^2]

### 4.3.范数误差计算表达式

以$L_2$空间范数为例，其原始表达式为

$$\|f(x) \|_2= \frac{1}{A_{\Omega}} \sqrt{ \int_{\Omega}|f(x)|^2 \mathrm{dx} } $$

当我们使用FEM或DGM方法来计算$L_2$计算到的结果$u_h$，是原始函数$u(x)$的近似表达形式

$$u_h = \sum_i u_i \varphi_i(x)$$

其中$\varphi_i(x)$是解空间内的基函数。因此，计算结果$L_2$误差表达式为

$$\| \Delta u \|_2 = \frac{1}{A_{\Omega}} \sqrt{ \int_{\Omega} \left|u(x) - u_h \right|^2 \mathrm{dx} } = \frac{1}{A_{\Omega}} \sqrt{ \int_{\Omega} \left|u(x) - \sum_i u_i \varphi_i(x) \right|^2 \mathrm{dx} }$$

实际上，当基函数为Lagrange函数时，更简单的方法是令精确解也采用基函数进行表示，然后代入方程中进行计算

$$\| \Delta u \|_2 = \frac{1}{A_{\Omega}} \sqrt{ \int_{\Omega} \left|u(x) - u_h \right|^2 \mathrm{dx} } = \frac{1}{A_{\Omega}} \sqrt{ \int_{\Omega} \left( \sum_i \left|u(x_i) -  u_i \right|^2 \varphi_i(x) \right) \mathrm{dx} }$$


[^1]: [Correct way of computing norm L2 for a finite difference scheme](http://scicomp.stackexchange.com/questions/19749/correct-way-of-computing-norm-l-2-for-a-finite-difference-scheme)

[^2]: [What norm to choose when?](http://scicomp.stackexchange.com/questions/2822/what-norm-to-choose-when)

[^3]: [Differences between the L1-norm and the L2-norm (Least Absolute Deviations and Least Squares)](http://www.chioka.in/differences-between-the-l1-norm-and-the-l2-norm-least-absolute-deviations-and-least-squares/)

[^4]: [L1 norm and L2 norm](http://math.stackexchange.com/questions/384003/l1-norm-and-l2-norm)
