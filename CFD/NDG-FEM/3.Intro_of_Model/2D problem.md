#chapter 6 高维问题

介绍2维问题计算所需子程序 `StartUp2D.m`

```
% Purpose : Setup script, building operators, grid, metric, and connectivity tables.
% Definition of constants
Nfp = N+1; Np = (N+1)*(N+2)/2; Nfaces=3; NODETOL = 1e-12;

% Compute nodal set
[x,y] = Nodes2D(N); [r,s] = xytors(x,y);

% Build reference element matrices
V = Vandermonde2D(N,r,s); invV = inv(V);
MassMatrix = invV'*invV;
[Dr,Ds] = Dmatrices2D(N, r, s, V);

% build coordinates of all the nodes
va = EToV(:,1)'; vb = EToV(:,2)'; vc = EToV(:,3)';
x = 0.5*(-(r+s)*VX(va)+(1+r)*VX(vb)+(1+s)*VX(vc));
y = 0.5*(-(r+s)*VY(va)+(1+r)*VY(vb)+(1+s)*VY(vc));

% find all the nodes that lie on each edge
fmask1   = find( abs(s+1) < NODETOL)'; 
fmask2   = find( abs(r+s) < NODETOL)';
fmask3   = find( abs(r+1) < NODETOL)';
Fmask  = [fmask1;fmask2;fmask3]';
Fx = x(Fmask(:), :); Fy = y(Fmask(:), :);

% Create surface integral terms
LIFT = Lift2D();

% calculate geometric factors
[rx,sx,ry,sy,J] = GeometricFactors2D(x,y,Dr,Ds);

% calculate geometric factors
[nx, ny, sJ] = Normals2D();
Fscale = sJ./(J(Fmask,:));

% Build connectivity matrix
[EToE, EToF] = tiConnect2D(EToV);

% Build connectivity maps
BuildMaps2D;

% Compute weak operators (could be done in preprocessing to save time)
[Vr, Vs] = GradVandermonde2D(N, r, s);
Drw = (V*Vr')/(V*V'); Dsw = (V*Vs')/(V*V');
```

##6.1 节点

介绍计算中得三角形，包括一般三角形 $D^k$ ，标准三角形 $I$ 和构造节点集所需的等边三角形 $E$，其中一般三角形和等边三角形坐标为xoy，标准三角形坐标为ros，定义为 

$$ \{ \vec{r} = (r,s) | (r,s) \ge -1, r+s \le 0 \} $$

一般三角形是计算网格划分单元后得到的三角形，标准三角形用来定义勒让德多项式基函数，在等边三角形上定义拉格朗日基函数节点。

一般三角形（包括等边三角形）与标准三角形之间转化通过重心坐标$(\lambda^1, \lambda^2, \lambda^3)$进行，重心坐标具有性质

$$ 0 \le \lambda^{i} \le 1, \lambda^1+\lambda^2+\lambda^3 = 1$$

xoy坐标与中心坐标之间关系为
$$ \vec{x} = \lambda^2 \vec{x^1} + \lambda^3 \vec{x^2} + \lambda^1 \vec{x^3}$$

同理，在ros坐标系内也有此关系。当我们知道点得xoy坐标后，便可计算出其重心坐标，以此转化到roy坐标平面的标准三角形上

```
[x,y] = Nodes2D(N); % 获取等边三角形上拉格朗日基函数节点
[r,s] = xytors(x,y); % 转化到ros坐标系中的标准三角形坐标
```

在`xytors`函数内，由于xy坐标是在等边三角形内计算的，其边长为2，坐标原点位于其形心，因此可得其三个顶点分别为$(-1, -\sqrt{3}/3),(1, -\sqrt{3}/3),(0, 2\sqrt{3}/3)$。

##6.2 基函数

NDG模式有两种基函数，拉格朗日基函数和勒让德基函数，两个基之间通过Vandermonde矩阵相联系
$$ 
\mathbf{u} = \mathcal{V} \hat{\mathbf{u}}, 
\mathcal{V}^T \vec{l}(r) = \mathbf{\psi(r)} 
\mathcal{V}_{ij} = \psi_j( \mathbf{r_i} )
$$

其中，基函数组成向量
$$ \vec{l}(r) = \left[ 
\begin{matrix}
l_1(r) \cr 
l_2(r) \cr 
\dots \cr
l_n(r)
\end{matrix}
\right]$$

```
% Build reference element matrices
V = Vandermonde2D(N,r,s); invV = inv(V);
```

##6.3 质量矩阵与微分矩阵

```
MassMatrix = invV'*invV;
[Dr,Ds] = Dmatrices2D(N, r, s, V);
```

$$ M_{ij} = \iint{ l_i l_j \mathrm{d}x\mathrm{d}y} $$

转换到标准单元$I$上，并且利用Vandermonde矩阵替换为勒让德多项式

$$ M = \iint{ \vec{l} \vec{l}^T \mathrm{d}x \mathrm{d}y} 
= J^k \iint{ \vec{l} \vec{l}^T \mathrm{d}r \mathrm{d}s } 
= J^k \iint{ \vec{l} \vec{l}^T \mathrm{d}r \mathrm{d}s } 
= J^k \iint{ (V^T)^{-1} \vec{\psi} \vec{\psi}^T V^{-1} \mathrm{d}r \mathrm{d}s } 
= J^k (V^{-1})^T V^{-1}
$$

###6.4 单元映射

```
% build coordinates of all the nodes
va = EToV(:,1)'; vb = EToV(:,2)'; vc = EToV(:,3)';
x = 0.5*(-(r+s)*VX(va)+(1+r)*VX(vb)+(1+s)*VX(vc));
y = 0.5*(-(r+s)*VY(va)+(1+r)*VY(vb)+(1+s)*VY(vc));

% find all the nodes that lie on each edge
fmask1   = find( abs(s+1) < NODETOL)'; 
fmask2   = find( abs(r+s) < NODETOL)';
fmask3   = find( abs(r+1) < NODETOL)';
Fmask  = [fmask1;fmask2;fmask3]';
Fx = x(Fmask(:), :); Fy = y(Fmask(:), :);

% calculate geometric factors
[rx,sx,ry,sy,J] = GeometricFactors2D(x,y,Dr,Ds);

% calculate geometric factors
[nx, ny, sJ] = Normals2D();
Fscale = sJ./(J(Fmask,:));
```

VX, VY储存单元节点坐标，va, vb, vc从EToV矩阵中获得单元的三个顶点编号。
x,y 数组为 $N_p \times K$大小的矩阵，每列储存相应单元内点x、y坐标。

在知道了每个单元内点xy坐标后，便可以得到该单元与标准单元$I$之间映射关系$\frac{\partial{x}}{\partial{r}}, \frac{\partial{x}}{\partial{s}}, \frac{\partial{y}}{\partial{r}}, \frac{\partial{y}}{\partial{s}}$ 等。

其基本原理仍是利用基函数近似方法得到。在ros坐标系内，设函数$x = x(r,s)$，其表示标准单元内任意一点所对应xoy坐标系内x坐标。用拉格朗日函数对该函数进行近似$x_h(\vec{r}) = x_i l_i(\vec{r})$，其系数恰好为各个内点对应x坐标值。当映射为线性时，单元内$\frac{\partial{x}}{\partial{r}}$值都相同。因此

$$ \frac{\partial{x}}{\partial{r}} = \sum x_j \frac{\partial{l_j}}{\partial{r}} = \sum x_j \frac{\partial{l_j}}{\partial{r}} \Big|_{r_i} = Dr*x
$$

J为雅克比行列式
$$J = \frac{\partial{(x,y)}}{\partial{(r,s)}} =
\left|
\begin{matrix}
 x_r & x_s \cr
 y_r & y_s
\end{matrix} \right|$$

而
$$r_x = \frac{y_s}{J}, r_y = -\frac{x_s}{J}, 
s_x = -\frac{y_r}{J}, s_y = \frac{x_r}{J} $$

####单元边界外法线向量

```
% calculate geometric factors
[nx, ny, sJ] = Normals2D();
```

Fmask获取标准单元$I$内边界上节点编号，通过Fmash可得到两个大小为 [Nfx Nfp, K]的矩阵Fx、Fy，其元素分别为各个单元内边界上节点的x、y坐标。

**特别注意，外法线向量的坐标变换不同于普通的向量坐标变换，这与外法线定义有关**。外法线可以定义为某方向向量顺时针旋转90°，而且，坐标转换后的外法线应仍和其对应的方向向量具有这种关系。

根据两个坐标系中得单位向量，可以得到

$$\begin{matrix}
\Delta x = \frac{\partial x}{\partial r} \Delta r + \frac{\partial x}{\partial s} \Delta s \cr
\Delta y = \frac{\partial t}{\partial r} \Delta r + \frac{\partial t}{\partial s} \Delta s \cr
\end{matrix}
$$

对应的矩阵形式为

$$\left( \begin{matrix}
\frac{\partial x}{\partial r} & \frac{\partial x}{\partial s} \cr
\frac{\partial y}{\partial r} & \frac{\partial y}{\partial s} 
\end{matrix} \right)
\left( \begin{matrix}
\Delta r \cr
\Delta s 
\end{matrix} \right) = 
\left( \begin{matrix}
\Delta x \cr
\Delta y 
\end{matrix} \right)
$$

但是，变换矩阵$T= \left( \begin{matrix}
\frac{\partial x}{\partial r} & \frac{\partial x}{\partial s} \cr
\frac{\partial y}{\partial r} & \frac{\partial y}{\partial s} 
\end{matrix} \right)$只能对ros坐标系内的直线向量进行变换，例如标准三角形的直角边$\vec{R_2R_3} = (1, 0)$。若想得到对应的外法线向量转换矩阵S，应研究S与T两变换矩阵关系。

若ros坐标系内某向量$\vec{v_r} =(\Delta r, \Delta s)$，则其对应的外法线向量为$\vec{n_r} =(\Delta s, -\Delta r)$。假设经过坐标转换后向量分量为$\vec{v_x} =(\Delta x, \Delta y)$，则其外法线向量为$\vec{n_x} =(\Delta y, -\Delta x)$。两向量之间有对应关系
$$\vec(v_x) = T*\vec{v_r}$$

外法线向量与其对应的向量关系为
$$\vec{n_r} = 
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 \cr
\end{matrix} \right)
\vec{v_r} $$

由此可得
$$\vec{n_x} = 
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)
\vec{v_x} =
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)T\vec{v_r} = 
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)T
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)^{-1}\vec{n_r} =
S\vec{n_r}
$$

由此可得
$$ S = 
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)
\left( \begin{matrix}
\frac{\partial x}{\partial r} & \frac{\partial x}{\partial s} \cr
\frac{\partial y}{\partial r} & \frac{\partial y}{\partial s} 
\end{matrix} \right)
\left( \begin{matrix}
0 & 1 \cr
-1 & 0 
\end{matrix} \right)^{-1} = 
\left( \begin{matrix}
\frac{ \partial y }{\partial s} & -\frac{ \partial y }{\partial r} \cr
-\frac{ \partial x }{\partial s} & \frac{ \partial x }{\partial r} \cr
\end{matrix} \right)
$$


$$
\left( \begin{matrix}
n_x \cr
n_y \cr
\end{matrix} \right) = 
\left( \begin{matrix}
\frac{ \partial y }{\partial s} & -\frac{ \partial y }{\partial r} \cr
-\frac{ \partial x }{\partial s} & \frac{ \partial x }{\partial r} \cr
\end{matrix} \right)
\left( \begin{matrix}
n_r \cr
n_s
\end{matrix} \right) 
$$

####三边雅克比矩阵

计算三边雅克比矩阵，实际就是计算对应三条边长度之比。标准三角形$I$三条边分别为$s = -1; r+s = 0; r = -1$，转换后在一般三角形内长度分别为$dS_1, dS_2, dS_3$，下面分别看三角边$J_{edge}$计算过程。

对任意一条直线$\vec{r} =(dr, ds) $，坐标变换后长度为$dl$

$dl = \sqrt{dx^2 + dy^2} = \sqrt{ (\frac{\partial x}{\partial r}dr + \frac{\partial x}{\partial s}ds)^2 + (\frac{\partial y}{\partial r}dr + \frac{\partial y}{\partial s}ds)^2}$

在J1上$ds = 0$，故

$dl = \sqrt{ (\frac{\partial x}{\partial r})^2 + (\frac{\partial y}{\partial r})^2}dr$
$J_1 = \frac{dl}{dr} = \sqrt{ (\frac{\partial x}{\partial r})^2 + (\frac{\partial y}{\partial r})^2}$

J3同理可得

$J_3 = \frac{dl}{ds} = \sqrt{ (\frac{\partial x}{\partial s})^2 + (\frac{\partial y}{\partial s})^2}$

J2上有$dr = -ds$

$J_2 = \frac{dl}{dr} = \frac{dl}{ds}  = \sqrt{ (\frac{\partial x}{\partial r} - \frac{\partial x}{\partial s})^2 + (\frac{\partial y}{\partial r} - \frac{\partial y}{\partial s})^2}$
**注意，第二条边的sJ并非是针对标准三角形（ros直角三角形）边变换的雅克比积分变换值，而是针对标准直线变换积分变换值**
三条边的雅克比矩阵储存在向量sJ之中。

###6.5 单元线积分

**首先强调，作为二维平面上的线积分与一维线积分是等价的，都是函数值与微元乘积之和的极限**。也就是说，无论二维空间上积分曲线多么复杂，当两条曲线上函数值分布相似，只有直线长度不同时，两条线段上函数积分之比只是直线长度之比。

NDG-FEM中二维线积分质量矩阵同一维模式一样，主要原因就是拉格朗日基函数在线段上与一维时函数分布完全相似。若偏微分方程为

$$\frac{\partial{u}}{\partial{t}} + \frac{\partial F}{\partial x} + \frac{\partial G}{\partial y} = 0$$

其乘以试验函数进行一次分部积分后可得单元边界线积分为

$$\oint{l_i (Fdy - Gdx) }  = \oint{l_i (n_x F+n_y G) ds}$$

使用数值通量 $(n_x F+n_y G)_h^\* = \sum l_j g^\*_j $ 代替线积分中通量 $(n_x F+n_y G)$，可得

$$\oint{l_i \sum l_j g^\*_j dx} = \oint 
\left( \begin{matrix}
l_1 l_1 & l_1 l_2 & \dots \cr
l_2 l_1 & \dots \cr
\dots \cr
\end{matrix} \right)
\left( \begin{matrix}
g_1 \cr
g_2 \cr
\dots \cr
\end{matrix} \right) = M^1 \vec{g^\*}$$

其中向量 $\vec{g^*} = [g_1, g_2, \dots]^T $ 是数值通量在边界各个点处函数值。



