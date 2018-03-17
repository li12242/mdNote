# 节点限制器

此节点型限制器参考自 Kuzmin (2010) [^1]研究，其主要通过修正 Barth-Jespersen 限制器，使单元内数值解满足

$$u_e^{min} \le u(\mathbf{x}_i)\le u_e^{max}, \quad \forall i $$

修正后的数值解形式为

$$u_h(\mathbf{x}_i) = u_c + \alpha_e (\nabla u)_ c\cdot(\mathbf{x}_i - \mathbf{x}_c), \quad 0 \le \alpha_c \le 1, \mathbf{x} \in \Omega_e $$

其中$\alpha_e$为斜率限制器，其计算公式为

$$\alpha_e = min_i \left\{ \begin{matrix}
min\left\{ 1, \frac{u_e^{max} - u_c}{u_i - u_c} \right\}, & u_i - u_c > 0 \cr
1, & u_i - u_c = 0 \cr
min\left\{ 1, \frac{u_e^{min} - u_c}{u_i - u_c} \right\}, & u_i - u_c < 0 \cr
\end{matrix}\right.$$

这里 $u_i = u_c + (\nabla u)_ c\cdot(\mathbf{x}_i - \mathbf{x}_c)$ 为未限制过的原始解。

![](http://ww2.sinaimg.cn/large/7a1c18a8jw1f7bzv7kgyaj20af04x74o.jpg)

 Kuzmin (2010) 主要对 $u_e^{max}$ 与 $u_e^{min}$ 的选取做了修正。传统的 BJ 斜率限制器中，$u_e^{max}$ 与 $u_e^{min}$ 通常选择 $\Omega_e$ 的 van Neumann 相邻单元（图中蓝色区域）中最大与最小单元均值。但是在 Kuzmin 的方法中， 针对网格中每个顶点（黑色）都对应一组 $u_i^{max}$ 与 $u_i^{min}$ 的值，其包含了所有与顶点 $\mathbf{x}_i$ 相邻单元中最大与最小均值，即

 $$u_i^{max}=max\left\{ u_c, u_i^{max} \right\}, \quad u_i^{min}=min\left\{ u_c, u_i^{min} \right\}$$

[^1]: KUZMIN D. A vertex-based hierarchical slope limiter for p-adaptive discontinuous Galerkin methods[J]. Journal of Computational and Applied Mathematics, Elsevier B.V., 2010, 233(12): 3077–3085.
