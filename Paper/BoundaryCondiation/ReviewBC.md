> Review of open boundary conditions
>
> by li12242, 2018/3/12

讨论数值模拟边界条件文献大致可以分为以下几种。

根据理论方法分类

* 特征方程
* 海绵层边界
* 耦合模型

其中，根据控制方程分类，无反射边界另外可以分为两种

* 辐射边界
* Flather 边界


## 1. 特征方程


| Author | Year | Journal | Title | Comment |
| :---:  | :---  | :---  | :---  | :---  | 
| Hedstrom | 1979 | JCP | Nonreflecting boundary conditions for nonlinear hyperbolic systems | 采用 Riemann 特征变量构造无反射边界条件，最终得到边界处控制方程。 |
| Israeli & Orszag | 1981 | JCP | Approximation of radiation boundary conditions | 叙述了三种边界条件，包括吸收边界，海绵层以及修改波动传输特性等。|
| Miller & Thorpe | 1981 | Q J ROY METEOR SOC | Radiation conditions for the lateral boundaries of limited-area numerical models | 分析了辐射边界和外插边界条件精度以及稳定性。 |
| Verboom & Slob | 1984 | Advances in water resources | Weakly-reflective boundary conditions for two-dimensional shallow water flow problems | 采用 Fourier 变换对二维 SWE 方程进行分析，得到弱反射边界条件控制方程 |
| Blumberg & Kantha | 1985 | Journal of Hydraulic Engineering | Open boundary condition for circulation models | 本文采用一种新型的驱动辐射边界条件来考虑潮流和 subtidal 驱动，并能够将计算域内瞬态响应传出计算域。 |
| Thompson | 1987 | JCP | Time dependent boundary conditions for hyperbolic systems | 给出了一种得到特征方程的通用方法，获得了一维和二维双曲方程转化为特征方程表达式，并将 Hedstrom 的无反射入流边界条件和出流边界统一起来，得到无反射边界方程 |
| Stevens | 1990 | Geophysical & Astrophysical Fluid Dynamics | On open boundary conditions for three dimensional primitive equation ocean circulation models | 提出三维原始方程海洋模型边界条件，可以作为强制边界条件或者被动边界条件形式。本文方法仅适合标量垂直传入边界情形，未来对于斜向入射的情形还有待于进一步研究。 |
| Gils | 1990 | AIAA Journal | Nonreflecting boundary conditions for Euler equation calculations | 提出了统一的线性理论来构造无反射边界条件，并将其应用于 Euler 方程求解中。（将高维控制方程系数矩阵化为一个进行分析，而非对每个维度分别分析） |
| Nycander & Döös | 2003 | JGR | Open boundary conditions for barotropic waves | 本文介绍了辐射边界和高阶边界条件，并给出一种新的边界条件，其将地转流和波浪引起边界分开，可以作为驱动边界进行赋值。 |
| Nycander et al. | 2008 | Ocean Modelling | Open boundary conditions for nonlinear channel flow | 详细叙述了线性与非线性特征边界条件导出方法，应用于双层浅水方程模型，并将其与海绵层方法比较。 |
| Toulopoulos & Ekaterinaris | 2011 | JCP | Artificial boundary conditions for the numerical solution of the Euler equations by the discontinuous galerkin method | 本文在边界处引入镜像单元，并且在此单元内采用有限元方法求解特征边界方程 CHBC–ODE。 |

# 辐射边界

| Author | Year | Journal | Title | Comment |
| :---:  | :---:  | :---:  | :---  | :---  | 

# 海绵层边界

| Author | Year | Journal | Title | Comment |
| :---:  | :---:  | :---:  | :---  | :---  | 

