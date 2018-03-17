# TVB斜率限制器

本文参考源程序来自[Fluidity](http://fluidityproject.github.io/)。

## 简介

TVB斜率限制器最早由Cockburn和Shu（1989）提出，其主要特点是提出了修正minmod函数

$$\tilde{m}(a_1, a_2, \cdots, a_n) = \left\{
\begin{array}{ll}
a_1 & \text{if} \, \left| a_1 \right| \le Mh^2, \cr
m\left(a_1, a_2, \cdots, a_n\right) & \text{otherwise}, \end{array}\right.$$

其中$m\left(a_1, a_2, \cdots, a_n\right)$为原始minmod函数，$M$为系数。

## 高维TVB限制器

针对高维情形可以参考Cockburn和Shu[2]的研究，其中最关键的步骤在于构造修正minmod函数的两个参数

$$a_1 = \tilde{u}_h(m_i, K_0), \quad a_2 = v\Delta\bar{u}_h(m_i, K_0)$$

![](http://ww3.sinaimg.cn/large/7a1c18a8jw1f71rel68p5j209o07ut8w.jpg)

其中 $\tilde{u}_h(m_i, K_0)$ 为边界中点处近似解与单元均值之差 $u_h(m_i, K_0) - \bar{u}_{K_0}$，$\bar{u}_{K_0}$ 为单元 $K_0$ 的单元均值。而这个 $\Delta\bar{u}_h(m_i, K_0)$ 则是根据几何坐标插值后得到的边界中心值 $u_h(m_1)$ 与 $\bar{u}_{K_0}$ 之间差值，$v$ 为大于1的系数，一般取1.5左右。

几何插值系数根据三个单元间坐标关系而定。如在计算边中点 $m_1$ 的系数时，首先需确定除 $b_0$ 和 $b_1$ 外要取哪个单元进行插值（$b_2$ 或 $b_3$），其中选取原则为以下两点

1. 单元 $b_1$ 所占比例尽量大
2. 中点 $m_1$ 尽量在两条射线 $b_0 - b_1$ 与 $b_0 - b_2$ 之间

在确定第三个单元之后，我们便可以确定中点 $m_1$ 插值系数。插值公式为

$$u_h(m_1) - u_h(b_0) = \alpha_1 \left( u_h(b_1) - u_h(b_0) \right) + \alpha_2 \left( u_h(b_2) - u_h(b_0) \right)$$

其中插值系数根据三个三角形单元形心坐标而定

$$\left\{ \begin{array}{ll}
x_{m_1} - x_{b_0} = \alpha_1 \left( x_{b_1} - x_{b_0} \right) + \alpha_2 \left( x_{b_2} - x_{b_0} \right) \cr
y_{m_1} - y_{b_0} = \alpha_1 \left( y_{b_1} - y_{b_0} \right) + \alpha_2 \left( y_{b_2} - y_{b_0} \right)
\end{array} \right.$$

在得到修正后的边界值与均值之差后，修正过程并没有结束。因为可能TVB限制器只修正了三个边中某两个边中点值，而剩下的边中点值保持不变，若此时采用新的三个边中点值进行重构，得到的重构值均值区别于原始单元均值，造成单元不守恒。

为解决此问题，需要对修正后的插值进行修正。假设 $\Delta_i$ 为限制器得到的解

$$\Delta_i = \tilde{m}\left(\tilde{u}_h(m_i, K_0),  v\Delta\bar{u}_h(m_i, K_0)\right)$$

由于 $\Delta_i$ 代表限制后边界中点值与单元均值之差，因此应当满足 $\sum_{i=1}^3 \Delta_i = 0$。若 $\sum_{i=1}^3 \Delta_i \neq 0$，计算修正系数 $\theta^+$ 与 $\theta^-$

$$\begin{array}{ll}
pos = \sum_{i=1}^3 \text{max} \left(0, \Delta_i\right), \quad neg = \sum_{i=1}^3 \text{max} \left(0, -\Delta_i\right) \cr
\theta^+ = \text{min} \left(1, \frac{neg}{pos} \right), \quad \theta^- = \text{min} \left(1, \frac{pos}{neg} \right)
\end{array}$$

其中 $pos$ 与 $neg$ 分别是 $\Delta_i$ 中正系数与负系数总和。采用 $\theta^+$ 与 $\theta^-$ 修正后限制值为

$$\hat{\Delta}_i = \theta^+ \text{max} \left(0, \Delta_i\right) - \theta^- \text{max} \left(0, -\Delta_i\right)$$

此时满足 $\sum_{i=1}^3 \hat{\Delta}_i = 0$，根据 $\hat{\Delta}_i$ 进行重构便可得到限制后的解。

## 扩展至四边形单元

### Green-Gauss公式梯度计算

在四边形单元中计算时，大部分过程都与三角形单元相同，唯一区别是确定如何由四个边上的限制后的 $\hat{\Delta}_i$ 获得单元内分布解。这里我们采用一种简单方法，首先利用Green-Gauss公式计算出单元内近似斜率 $\frac{\partial u}{\partial x}$ 与 $\frac{\partial u}{\partial y}$，随后根据此斜率与均值便可获得单元内限制后的解。

其中斜率的近似公式采用下式计算

$$\begin{array}{ll}
\frac{\partial u}{\partial x} = \frac{1}{A}\int_{\Omega_A}\frac{\partial u}{\partial x} \mathrm{dA} = \frac{1}{A}\oint_{\partial \Omega_A} \hat{u} \mathrm{dy} = \sum_{i=1}^{Nfaces} \hat{u}_i \Delta y_i \cr
\frac{\partial u}{\partial y} = \frac{1}{A}\int_{\Omega_A}\frac{\partial u}{\partial y} \mathrm{dA} =\frac{1}{A}\oint_{\partial \Omega_A} -\hat{u} \mathrm{dx} = \sum_{i=1}^{Nfaces} - \hat{u}_i \Delta x_i
\end{array}$$

### 问题

![](http://ww2.sinaimg.cn/large/7a1c18a8jw1f7hrcg1uh9j20fk0r3q3t.jpg)

如下图所示，只根据边中点值进行重构，可能会使顶点超过周围单元均值范围，成为新的极值点。因此在四边形中，采用顶点替换边中点代入TVB限制器函数中更为合理。

但是当采用顶点变量值作为TVB限制器参数时，由会有过度耗散问题，如下图所示。

![](http://ww2.sinaimg.cn/large/7a1c18a8jw1f7hw7wvooij20fk0r3gmh.jpg)

## 代码

* Fluidity中源程序文件为 `assemble/Slope_limiters_DG.F90`；
* DG-FEM中对应二维限制器Mex函数 `+Utilities/+Limiter/+Limiter2D/TVB2d_Mex.c`。

---
[1]	COCKBURN B, SHU C-W. TVB Runge-Kutta local projection discontinuous Galerkin finite element method for conservation laws. II. General framework[J]. Mathematics of Computation, 1989, 52(186): 411–411.

[2]	COCKBURN B, SHU C-W. The Runge-Kutta discontinuous Galerkin method for conservation laws. V. Multidimensional systems[J]. Journal of Computational Physics, 1998, 141(2): 199–224.
