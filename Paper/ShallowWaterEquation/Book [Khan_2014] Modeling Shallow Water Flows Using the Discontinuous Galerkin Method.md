#Book [Khan_2014] Modeling Shallow Water Flows Using the Discontinuous Galerkin Method

[TOC]

---
##Ch1.Introduction
###1.1.A historical overview
The DG finite element method

###1.2.Organization of the book

* In Chapter 2, the discontinuous Galerkin procedure for hyperbolic conservation laws is introduced.
* In Chapter 3, numerical tests with the DG method for one-dimensional, nonconservative problems
* the DG method for the conservation laws
* In Chapter 5, the DG method is applied to the one-dimensional shallow water flows in nonrectangular, nonprismatic channels.
* In Chapters 6 through 8, the DG scheme is applied to the two-dimensional shallow water flows.
* In Chapter 9, numerical simulations for shallow water flows with pollutant transport in one and two dimensions are presented
* Concluding remarks

---
##Ch2.

---
##Ch3 Discontinuous Galerkin method for one-dimensional nonconservative equations
间断有限元求解一维问题

* 时间积分精度问题（TVD时间积分格式应比空间积分精度高1阶）

###3.1 Discontinuous Galerkin method for ordinary differential equations

###3.2 1D Linear convection
$$\frac{\partial C}{\partial t}+u\frac{\partial C}{\partial x} = 0, \quad x\in[0,1] $$

$$C(x,0) = \Big\\{
\begin{matrix} 
\sin(10\pi x) &  x\in[0,0.1] \cr
0 & x\in[0.1,1]
\end{matrix}$$

###3.3 1D Transient diffusion
$$\frac{\partial C}{\partial t} = \frac{\partial ^2 C}{\partial x^2} + Q, \quad x\in[0,1]$$

$$\begin{matrix}
C(0) = C(1) = 0 \cr
C(x,t=0)=0 \cr
\end{matrix}$$

###3.4 1D Steady diffusion

Equation can be solved using an iterative method

---
##4 One-dimensional conservation laws
###4.1.Burgers’ equation
Burgers' 方程为非线性对流问题
####4.1.1 Properties of Burgers’ equation
$$\frac{\partial u}{\partial t} + \frac{\partial f(u)}{\partial x}=\frac{\partial u}{\partial t}+\frac{\partial 0.5u^2}{\partial x} = 0$$
$$\lambda=\frac{\partial f(u)}{\partial u}=\frac{\partial 05u^2}{\partial u} = u$$

解分为稀疏波与激波两种情况
####4.1.2 Discontinuous Galerkin formulation for Burgers’ equation
*注意，其流量项并没有使用基函数线性表示，而是计算高斯节点处通量值进行积分。由于通量F为非线性，故其为更高阶多项式，若使用原始高斯积分点可能出现不完全积分问题（F=O(U^2),其阶数为2P）*

* 一次分部积分
* 数值通量采用迎风格式
$$f(u^-, u^+)=\Big\\{
\begin{matrix}
f(u^-)=0.5(u^-)^2 & if \quad \lambda=u>0 \cr
f(u^+)=0.5(u^+)^2 & if \quad \lambda=u< 0 \cr
\end{matrix}$$
$$u = 0.5(u^- + u^+)$$

###4.2 Total variation diminishing slope limiter
####4.2.1 TVD methods
####4.2.2 Formulation of TVD slope limiters
The idea of a slope limiter is to reconstruct the variables with limited slopes using neighboring elements.

三个具体斜率限制器形式
1. The MUSCL methods
$$\begin{matrix}
\sigma_e = [\frac{sign(a)+sign(b)}{2}]min(\beta_1|a|, \beta_2 |b|) \cr
\beta_1 = \frac{2}{1+Cr_2} \cr
\beta_2 = \frac{2}{1-Cr_2}
\end{matrix}$$
2. Godunov method
$$\sigma_e = 0$$
3. minmod slope limiter
$$\sigma_e = \begin{bmatrix} \frac{sign(a)+sign(b)}{2} \end{bmatrix} min(|a|,|b|)$$
4. monotonized central slope limiter
$$\sigma_e = \begin{bmatrix} \frac{sign(a)+sign(b)}{2} \end{bmatrix} min(\frac{|a+b|}{2},2|a|,2|b|)$$

*提示：可以看出其限制函数可以总结为minmod函数形式*
$$minmod(a,b) = \Big\\{ 
\begin{matrix}
s \cdot min(|a|, |b|), & s=sign(a), a,b 同号 \cr
0
\end{matrix}$$

*限制器如何添加？*

* 激波问题中
一阶欧拉向前时间积分格式中需要保证柯朗数 Cr ≤ 1.03
TVD Runge–Kutta 格式，在每个中间步使用斜率限制器时需 Cr ≤ 1.02， 而只在中间时间步最后使用斜率限制器需 Cr ≤ 0.7 。
* 稀疏波问题中
一阶欧拉向前积分格式柯朗数需 Cr ≤ 1.21
TVD Runge–Kutta 格式中柯朗数需分别满足 Cr ≤ 1.16 或 Cr ≤ 0.48 在中间时间步使用TVD格式修正或在中间时间步最后使用TVD格式进行修正。

*提示：RK中间时间步内增加TVD格式调用次数，但是能够增大时间步并且使格式稳定性增强，优势明显*

###4.3 Shallow water flow equations in rectangular channels
Saint Venant 方程

* 矩形截面
* 中等底坡梯度
* 静压分布
* 无侧向入流、出流
* 截面流速分布均匀
* 水体密度为常数

方程形式
$$\frac{\partial h}{\partial t} + \frac{\partial q}{\partial x} = 0$$
$$\frac{\partial q}{\partial t} + \frac{\partial (q^2/h+gh^2/2)}{\partial x} = gh(S_o-S_f)$$

其中$S_o$为底坡坡度（bed slope），$S_f$为粗糙度（friction slope）
$$\Big\\{ 
\begin{matrix}
S_o=- \frac{\partial z_b}{\partial x} \cr
S_f= \frac{n^2 q |q|}{h^{10/3}}
\end{matrix}$$

###4.4 DG method for shallow water flow equations
####4.4.1 Shallow water flow equations in rectangular channels
####4.4.2 Numerical flux

* HLL flux
* Lax–Friedrichs flux
* Roe flux

####4.4.3 Dry bed treatment
To handle the dry bed problem, a small depth ε (e.g., ε = 10–16) can be used to check the wet/dry front 

* 只有一边水深小于 ε，数值通量按照干湿条件计算
* 两边水深皆小于 ε，通量为0

两种处理方法
1. 干网格单元流速为0，水深为0
需注意水深在摩擦项$q^2/h$处理
2. 干网格单元流速为0，水深为极小值$h_{dry}$
在非水平地形上会导致非物理流动

####4.4.4 Initial and boundary conditions
所需边界个数与该边界进入区域的特征线个数相同。

###4.5 Numerical tests
####4.5.1 Idealized dam break in a rectangular channel
包括干湿两个算例，算例参考 [Henderson_1966] Open Channel Flow

* 长度1000m
* 大坝位于500m处
* 上游水深10m
* 下游水深为2m（wet case）或0m（dry case）
* 计算单元400个
* 计算时间20s

####4.5.2 Dam break in a rectangular flume with bed friction

####4.5.3 Hydraulic jump
####4.5.5 Flow over irregular bed
####4.5.6 Wetting and drying in a parabolic bowl

---
##5 One-dimensional shallow water flow in nonrectangular channels

---
##6 Two-dimensional conservation laws
###6.1 Pure convection in 2D
###6.2 Discontinuous Galerkin formulation for 2D convection

---
