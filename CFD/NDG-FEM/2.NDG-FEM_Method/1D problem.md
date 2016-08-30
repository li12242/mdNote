# chapter 3 一维问题

##3.1 基函数

NDG-FEM使用两种基函数，拉格朗日基函数 $l_i(r)$ 与勒让德基函数 $\psi_i(r)$。两种基函数及其系数向量之间通过Vanderomnd矩阵相联系，

$$ V \hat{u} = \vec{u}$$

其中 $\hat{u} $为勒让德基函数系数，$\vec{u}(r)$为拉格朗日基函数系数。如我们所知，拉格朗日多项式$l_i{r}$在$r_i$处函数值为1，因此其对应系数$u_i$与该点函数值$u(r_i)$相等。由此可得Vanderomnd中元素值为

$$V_{ij} = P_j(r_i)$$

这样便有

$$u(r_i) = \sum_j P_j(r_i)\hat{u}_j = u_j$$

Vanderomnd矩阵与基函数之间关系为

$$V^T \vec{l}(r) = \vec{P}(r) $$

此公式根据插值定理而来，若勒让德多项式系数为 $P_j(r_i)$时，其插值结果即为 $P_j$，即

$$ P_j(r) = \sum_i P_j(r_i)l_i(r) $$

> 测试程序 `test_plot_Legrend_polynomial.m`通过调用`JacobiP`函数，绘制了[-1, 1]上legendre多项式基函数

> 如何绘制拉格朗日多项式基函数？

```
Globals1D; NODETOL = 1e-10;
Np = N+1; Nfp = 1; Nfaces=2;

% Compute basic Legendre Gauss Lobatto grid
r = JacobiGL(0,0,N);

% Build reference element matrices
V  = Vandermonde1D(N, r); invV = inv(V);
```

`SetUp1D.m`中，r为拉格朗日插值函数节点，V为Vanderomnd矩阵。

##网格中相连顶点编号

几个重要的变量vmapM、vampP
