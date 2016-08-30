# WENO 单元重构

本文主要介绍采用 Hermite WENO 重构方法作为斜率限制器应用于二维或高维单元中。

## 1.简介[^1]

ENO格式最早由 Harten 等[^2]提出，ENO格式避免在高梯度地区进行插值，其重构过程通过多个不同位置模板，并且选取其中最光滑模板上的解进行重构，由此保证在重构过程中具有较高的精度。然而这种方法会导致收敛问题并且在连续区域降低精度，随后Liu等[^3]提出了 weighted ENO 格式。WENO 格式采用不同的权重系数组合各个模板，而非只采用一个判断光滑程度的系数。Qiu 和 Shu 首先将 WENO 格式作为一种斜率限制器应用于DG方法中[^4]，随后他们又根据 Hermite 多项式构造了一系列的 WENO 格式，称为 HWENO 格式并也将其作为限制器应用于 DG 方法中[^5] [^6]。

## 2.Hermite WENO 重构

一个典型的 WENO 重构过程包括以下步骤：
1. 确定一系列模板
2. 重构模板上单元解
4. 计算每个重构多项式振荡算子
5. 使用振荡算子计算相应权重
6. 根据权重系数构造重构多项式

![](http://ww3.sinaimg.cn/large/7a1c18a8jw1f7bpip0vllj20jn071jrv.jpg)

以三角形单元为例，单元e在计算不同模板多项式 $P_1$ 时需满足下列关系中一种：

1. 单元e中原始解；
2. $\frac{1}{\Omega_e}\int_{\Omega_e} P_1 d\Omega = u_e$， $\frac{1}{\Omega_j}\int_{\Omega_j} P_1 d\Omega = u_j$， $\frac{1}{\Omega_k}\int_{\Omega_k} P_1 d\Omega = u_k$，其中 $(j,k) = (a,b; b,c; c,a)$；
3. $\frac{1}{\Omega_e}\int_{\Omega_e} P_1 d\Omega = u_e$，$\frac{1}{\Omega_k}\int_{\Omega_e} \frac{\partial P_1}{\partial x_i} d\Omega = \frac{\partial P_1}{\partial x_i}|_ k$，其中 $(k=a,b,c)$；

根据以上三种条件，便可以构造出7个具有二阶精度的多项式。对应模板分别为

1. $(e)$，原始解；
2. $(e,a,b;\, e,b,c;\, e,c,a)$，三个相邻单元均值；
3. $(e,a;\, e,b;\, e,c)$，单元e均值与相邻单元斜率；

注意，不同模板上的重构多项式需满足在单元内均值与原始结果相同。对于三角形来说，除了原始解之外，计算模板共有6个，而四边形则有8个，在获得各个模板上的多项式后便可采用线性叠加的方法获得重构后的单元解。

为了避免重构解产生振荡，需要为各个模板设置不同权重系数，在 HWENO 格式中模板权重系数与其振荡幅度相关。Friedrich[^7] 改进了 Jiang 与 Shu (1996) 提出的振荡算子，其改进的新形式为

$$o_i = \left[ \int_{\Omega_i} h^{-2} \left( \frac{\partial P_i}{\partial x_k} \right)^2 d\Omega \right]^{1/2}$$

其中 $h=mes(\Omega_e)$ 为单元尺度大小。使用振荡算子计算每个模板所占权重公式为

$$w_i = \frac{ \left(\epsilon +o_i(P_i) \right)^{-\gamma}}{\sum_{k=1}^m \left(\epsilon +o_k(P_k) \right)^{-\gamma}}$$

其中 $\gamma$ 为正值。

考虑到计算效率以及数值精度，以上重构过程应当只应用于数值解中存在间断位置，这就要求 HWENO 重构格式与间断检测器协同使用。

>Fluidity 模型的 HWENO 重构格式中，振荡算子采用如下公式计算
$$o_i = \left[ \frac{ \int_{\Omega_i} \left( \frac{\partial P_i}{\partial x_k} \right)^2 d\Omega }{ \int_{\Omega_i} P_i^2 d\Omega } \right]^{1/2} $$


[^1]: LUO H, BAUM J D, LÖHNER R. A Hermite WENO-based limiter for discontinuous Galerkin method on unstructured grids[J]. Journal of Computational Physics, 2007, 225(1): 686–713.
[^2]: A. Harden, B. Engquist, S. Osher, S.R. Chakravarthy, Uniformly high-order accurate essential non-oscillatory schemes III, Journal of Computational Physics 71 (1987) 231–303.
[^3]: X. Liu, S. Osher, T.F. Chen, Weighted essential non-oscillatory schemes, Journal of Computational Physics 115 (1994) 200–212.
[^4]: J. Qiu, C.W. Shu, Runge–Kutta discontinuous Galerkin method using WENO limiters, SIAM Journal of Scientific Computing 26
(2005) 907–929.
[^5]: J. Qiu, C.W. Shu, Hermite WENO schemes and their application as limiters for Runge–Kutta discontinuous Galerkin method: one
dimensional case, Journal of Computational Physics 193 (2004) 115–135.
[^6]: J. Qiu, C.W. Shu, Hermite WENO schemes and their application as limiters for Runge–Kutta discontinuous Galerkin method II: two
dimensional case, Computers & Fluids 34 (2005) 642–663.
[^7]: O. Friedrich, Weighted essential non-oscillatory schemes for the interpolation of mean values on unstructured grids, Journal of Computational Physics 144 (1998) 194–212.
