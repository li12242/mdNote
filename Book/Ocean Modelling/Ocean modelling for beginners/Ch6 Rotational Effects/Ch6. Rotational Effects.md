#Ch6.Rotational Effects

[TOC]

*简介* 本节主要介绍浅水模型应用，研究受科氏力影响的水动力过程，将为读者介绍准地转流和涡的概念。练习强调一系列过程，包括Kelvin波，正压地转流在斜坡运动，Rossby波，一般风驱环流，西部边界流，斜压补偿，地转产生的密度锋面修正，斜压不稳定机制，相对重力流。

##6.1 完整浅水方程

###6.1.1 方程描述

本章中练习使用单层浅水方程其完整的形式，包括非线性项，风应力，科氏力，在压力梯度，底摩擦和水平扩散。动量方程的形式是：

$$\begin{eqnarray}
\begin{aligned}
& \frac{\partial u}{\partial t} + Adv_h(u) - fv = -g\frac{\partial \eta}{\partial x} + \frac{\tau^{wind}_x - \tau^{bot}_x}{\rho_0 h} + Diff_h(u)
& \frac{\partial v}{\partial t} + Adv_h(v) + fu = -g\frac{\partial \eta}{\partial y} + \frac{\tau^{wind}_y - \tau^{bot}_y}{\rho_0 h} + Diff_h(v)
\end{aligned}
\end{eqnarray}$$

其中$Adv_h$代表非线性项，$Diff_h$为水平扩散项，参加第5章，科氏力是方程中新出现的力。

###6.1.2 科氏力应用

按照以下步骤求解浅水方程

1. 不考虑科氏力情况下使用半隐格式计算流速估计值$(u_{j,k}^*, v_{j,k}^*)$，考虑底部摩擦力。
2. 应用半隐式格式计算科氏力，方程如下：

**不知道方程半隐式格式怎么得到的，后面还要继续**

$$\begin{aligned}
& u_{j,k}^{n+1} = [u_{j,k}^\* - \beta u_{j,k}^n + \alpha v_{j,k}^n]/(1+\beta)
& v_{j,k}^{n+1} = [v_{j,k}^\* - \beta v_{j,k}^n + \alpha u_{j,k}^n]/(1+\beta)
\end{aligned}$$

其中$\alpha = \Delta t f$，$\beta = 0.25 \alpha^2$。为了能够使用前面练习中的干湿算法，在计算流速之前首先计算速度改变量

$\begin{aligned}
& \Delta u_{j,k} = u_{j,k}^{n+1} - u_{j,k}^{n}
& \Delta v_{j,k} = v_{j,k}^{n+1} - v_{j,k}^{n}
\end{aligned}$$

##6.2 沿岸Kelvin波

沿岸Kelvin波是表面波或界面引力波在科氏力影响下，最大振幅海岸线并且沿着海岸运动的形式。这种波的描述可以追溯到William Thomson爵士（后来成为Kelvin勋爵）（Thomson，1879年）。分析描述Kelvin波的动力学特性最简单的方法是考虑常密度的近海水流，深度为常数$H$，由沿着x轴方向的两条直线海岸线限制，并且要求没有任何近岸流或离岸流。在这种情况下，线性无摩擦浅水方程采用以下形式：

$$\begin{eqnarray}
\begin{aligned}
& \frac{\partial u}{\partial t} = -g \frac{\partial \eta}{\partial x}
& fu = -g \frac{\partial \eta}{\partial y}
& \frac{\partial \eta}{\partial t} = -\frac{\partial (uH)}{\partial x}
\end{aligned}
\end{eqnarray}$$

这里x为沿岸方向，y为离岸方向。浅水波的波动解形式为：

$$\begin{eqnarray}
\begin{aligned}
& \eta(x,y,t) = \eta_0 exp(-y/R)sin(kx-\omega t)
& u(x,y,t) = \sqrt{\frac{g}{H}} \eta_0 exp(-y/R) sin(kx-\omega t)
\end{aligned}
\end{eqnarray}$$

其中 $k = 2\pi/lambda$（$\lambda$为波数）,$\omega = 2\pi/T$（$T$为周期），$R$为Rossby变形半径，定义为

$$\begin{equation}
R = \frac{\sqrt{gH}}{|f|}
\end{equation}$$

##6.3 练习15：海岸Kelvin波

###6.3.1 目标

本练习目的是模拟海岸Kelvin波水动力过程。

###6.3.2 任务描述

###6.3.3 结果

###6.3.4 代码

###6.3.5 附加练习

##6.4 地转流

###6.4.1 尺度

###.6.4.2 地转平衡

###6.4.3 地转方程

纯地转流体运动方程为

$$\begin{eqnarray}
\begin{aligned}
& -f v_{geo} = -\frac{1}{\rho_0} \frac{\partial P}{\partial x}
& +f u_{geo} = -\frac{1}{\rho_0} \frac{\partial P}{\partial y}
\end{aligned}
\end{eqnarray}$$

因此，地转流速沿着等压线流动。

$$\begin{eqnarray}
\begin{aligned}
& \frac{\partial v_{geo}}{\partial z} = + \frac{g}{\rho f} \frac{\partial \rho}{\partial x}
& \frac{\partial u_{geo}}{\partial z} = + \frac{g}{\rho f} \frac{\partial \rho}{\partial y}
\end{aligned}
\end{eqnarray}$$

热成风方程

当密度为常数时，地转平衡化简为：

$$\begin{eqnarray}
\begin{aligned}
& - f v_{geo} = -g \frac{\partial \eta}{\partial x}
& + f u_{geo} = -g \frac{\partial \eta}{\partial y}
\end{aligned}
\end{eqnarray}$$

###6.4.4 涡度

###6.4.5 涡守恒

###6.4.6 


##6.6 横向剪切流不稳定性

###6.6.1 理论

在某些情况下，在各向同性流体中水平剪切流是不稳定的，会变得蜿蜒最终分碎成紊动涡旋。这个过程成为正压不稳定性。

