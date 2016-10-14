# BJ2 斜率限制器

本文介绍斜率限制器取自于 Anastasiou 与 Chan (1997)[^1]研究，其所利用的斜率限制器也是 Barth 与 Jespersen 限制器的一种修正形式，并且包含一参数 $\beta$ 控制限制器耗散性大小，我们这里将其称之为 BJ2 限制器。

限制器修正解形式为

$$u_h(\mathbf{x}_i) = u_c + \Phi (\nabla u)_ c\cdot \mathbf{r}$$

限制器函数计算公式为

$$\Phi = min(\Phi_j), \quad j=1,2,\cdots,N_p$$

$$\Phi_j = max\left\{ min(\beta \gamma_j, 1), min(\gamma_j, \beta) \right\}$$

$$\gamma_j = \left\{ \begin{matrix}
\frac{u_c^{max} - u_c}{u_j - u_c}, & u_j - u_c > 0 \cr
\frac{u_c^{min} - u_c}{u_j - u_c}, & u_j - u_c < 0 \cr
1, & u_i - u_c = 0 \cr
\end{matrix}\right.$$

其中 $u_c^{max}=max(u_c, u_{neighbour})$，$u_c^{min}=min(u_c, u_{neighbour})$，$u_j$ 为未限制前数值解。

在限制器计算过程中引入了系数 $\beta \in [1,2]$，其作用是控制限制器的耗散性。当 $\beta=1$ 时，限制器等价于minmod限制器，而 $\beta=2$ 时为Superbee限制器。

[^1]: ANASTASIOU K, CHAN C T. Solution of the 2D shallow water equations using the finite volume method on unstructured triangular meshes[J]. International Journal for Numerical Methods in Fluids, John Wiley & Sons, Ltd, 1997, 24(11): 1225–1245.
