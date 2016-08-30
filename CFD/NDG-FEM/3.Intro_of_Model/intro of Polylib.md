#Polylib模块介绍
[TOC]

主要内容

* 雅克比正交基函数
* 雅克比基函数微分
* Gauss-Lobatto-Jacobi（GLJ） 积分节点
* GLJ节点上的 Lagrange基函数微分矩阵

##Polylib函数介绍

* Gauss-Lobatto-Jacobi zeros and weights with end point at $z\in[-1, 1]$
```
#define  zwgll( z,w,np)   zwglj (z,w,np,0.0,0.0);
```
```
void zwglj(double *z, double *w, int np, double alpha, double beta){
    ...
}
```

* 计算 Gauss-Lobatto-Jacobi 节点基函数在z处函数值h
zglj，np是Lagrange基函数节点坐标与对应节点个数，i是基函数序号（如计算基函数$l_i(z)$在高斯点$\xi$处函数值）
```
#define hgll(i,z,zglj,np)  hglj (i,z,zglj,np,0.0,0.0);
```
```
double hglj (int i, double z, double *zglj, int np, double alpha, double beta){
  ...
  return h;
}
```

* Compute the Derivative Matrix and its transpose associated with the Gauss-Lobatto-Jacobi zeros.
计算$ D[i\cdot np+j] = \frac{\partial l_j}{\partial z} \Big|_{z=z_i} $，其中 $l_j$ 为 Gauss-Lobatto-Jacobi 节点z处 Lagrange 基函数
```
void Dglj(double *D, double *Dt, double *z, int np, double alpha, double beta)
```

* Gauss-Lobatto-Jacobi nodal base function 节点基函数计算
```
function [h] = hglj(i,z,zglj,np)
% Compute the value of the i th Lagrangian interpolant through the
% np Gauss-Lobatto-Jacobi points zgrj at the arbitrary location z.
% Input:
%       int     i
%       double  z
%       double[np]  zglj
%       int     np
% Output:
%       double  h
% Usages: [h] = hglj(i,z,zglj,np)
```


##Matlab函数接口介绍

####文件组织结构
```
./
├── Dglj.c
├── Dglj.mexmaci64
├── GradJacobiP.c
├── GradJacobiP.mexmaci64
├── JacobiP.c
├── JacobiP.mexmaci64
├── install_Polylib.m
├── jacobfd.c
├── jacobfd.mexmaci64
├── polylib.c
├── polylib.h
├── zwglj.c
└── zwglj.mexmaci64
```

####函数介绍

#####1.Dglj

n阶Gauss-Lobatto-Jacobi节点$\\{z_i, i=1,2...n\\}$处Lagrange基函数$\\{l_i, i=1,2...n\\}$微分矩阵

$$D_{i,j} = \frac{\partial l_i}{\partial z} \Big|_{z=z_j}$$
```
function [D] = Dglj(r)
% Compute the Derivative Matrix and its transpose associated
%     with the Gauss-Lobatto-Jacobi zeros.
% 
% Compute the derivative matrix, associated with the n_th order 
%     Lagrangian interpolants through the np Gauss-Lobatto-Jacobi 
%     points z such that
%     $\frac{du}{dz}(z[i]) =  \sum_{j=0}^{np-1} D[i*np+j] u(z[j])$
%     $D[i*np+j] = \frac{\partial l_j}{\partial z} \right|_{z=z_i}$
% 
% Input:
%       double[np]  r
% Output:
%       double[np x np] D
%
% Usages: D=Polylib.Dglj(r)
```


#####2.GradJacobiP
计算n阶雅克比基函数$P_n^{\alpha, \beta}$在节点$\\{z_i, i=1,2,...np\\}$处微分值
$$dp[i] = \frac{\partial P_n^{\alpha, \beta}(z)}{\partial z} \big|_{z_i} $$

```
* Purpose: Evaluate the derivative of the Jacobi polynomial 
*   of type (alpha,beta)>-1, at points r for order N and 
*   returns dP[1:length(r))]
* 
* Input:
*       double[np]  r   np points $\in$ [-1,1]
*       double      alpha
*       double      beta
*       int         n
* Output:
*       double[np]  dp
*
* Usages: dp = GradJacobiP(r, alpha, beta, n)
```

#####3.JacobiP
计算n阶正交单位化雅克比基函数，满足
$$\int_{-1}^1 (1-x)^{\alpha}(1+x)^{\beta} \hat{P}^{(\alpha, \beta)}\_m(x)\hat{P}^{(\alpha, \beta)}\_n(x)dx = \delta_{mn}$$

单位化方法参见附录C.

```
 * get normalized Jacobi polynamial
 * Input:   r       - node coordinate in [-1, 1]
 *      alpha
 *      beta    
 *      n
 * Usages: p = JacobiP(r,alpha,beta,n)
```

#####4.jacobfd
#####5.zwglj

Gauss-Lobatto-Jacobi 节点及其积分权重系数计算
```
function [z,w] = zwglj(np)
% Gauss-Lobatto-Jacobi zeros and weights with end point at $z\in[-1, 1]$
% Input:    
%       int     np  - number of nodes in [-1, 1]    
% Output:
%       double  z   - x coordinate
%       double  w   - weights
% 
% Usages: [z,w] = zwglj(np)
```




###附录
####A.关键问题：**质量误差如何**？

线单元中质量矩阵为
$$M_{ij} = \int_{-1}^1 l_i l_j dx$$

* Gauss积分公式
$$\int_{-1}^1 l_i l_j dx = \sum_{n = 1}^{np} l_i(\xi_n)l_j(\xi_n) w_n $$
其中Gauss节点个数Q要求
$$Q_{min}\geq \frac{2P+3}{2}$$
$2P$是被积函数$l_i(x)l_j(x)$的幂次。

* Vandermonde矩阵
根据$V^Tl(x) = P(x)$之间变换关系，可得
$$M = (V\cdot V^T)^{-1}$$
其中$V_{ij} = P_j(r_i)$，$P_j(x)$为雅克比多项式（勒让德多项式），$r_i$为Gauss-Lobatto-Jacobi节点。

分别使用Gauss 积分与 Vandermonde 矩阵得到质量矩阵M_1与M_3，使用NDG得到质量矩阵M_2，比较二者绝对误差 error
```
function error = CompareMassMatrix(N)
%% Gauss integrate

nModePoints = N+1;
nQuadPoints = N+3;
[nodalPoints,~] = Polylib.zwglj(nModePoints);
[quadPoints, quadWeights] = Polylib.zwglj(nQuadPoints);
base = zeros(nModePoints, nQuadPoints);
for i= 1:nModePoints
    for j = 1:nQuadPoints
        base(i,j) = Polylib.hglj(i-1,quadPoints(j),nodalPoints,nModePoints);
    end
end

weight = zeros(nQuadPoints,nQuadPoints);
for j = 1:nQuadPoints
    weight(j,j) = quadWeights(j);
end
M_1 = base*weight*base';

%% Polylib Vandmonde
for j=1:nModePoints
    [p, ~] = Polylib.jacobfd(nodalPoints, j-1);
    V2D(:,j) = p(:)*sqrt((2*(j-1)+1)/2);
end
M_3 = inv(V2D*V2D');

%% Vandmode Matrix
% Compute basic Legendre Gauss Lobatto grid
r = JacobiGL(0,0,N);
% Build reference element matrices
V  = Vandermonde1D(N, r);
M_2 = inv(V*V');
%% The 
error = abs(M_1 - M_3);
end
```

首先比较 NDG 与 Polylib 中使用 Gauss 方法的到质量矩阵之间误差
```
>> error = CompareMassMatrix(8)

M_1 =

    0.0261    0.0040   -0.0051    0.0058   -0.0060    0.0058   -0.0051    0.0040   -0.0016
    0.0040    0.1558    0.0125   -0.0141    0.0146   -0.0141    0.0125   -0.0097    0.0040
   -0.0051    0.0125    0.2584    0.0181   -0.0188    0.0181   -0.0161    0.0125   -0.0051
    0.0058   -0.0141    0.0181    0.3261    0.0211   -0.0204    0.0181   -0.0141    0.0058
   -0.0060    0.0146   -0.0188    0.0211    0.3497    0.0211   -0.0188    0.0146   -0.0060
    0.0058   -0.0141    0.0181   -0.0204    0.0211    0.3261    0.0181   -0.0141    0.0058
   -0.0051    0.0125   -0.0161    0.0181   -0.0188    0.0181    0.2584    0.0125   -0.0051
    0.0040   -0.0097    0.0125   -0.0141    0.0146   -0.0141    0.0125    0.1558    0.0040
   -0.0016    0.0040   -0.0051    0.0058   -0.0060    0.0058   -0.0051    0.0040    0.0261


error =

   1.0e-15 *

    0.0798    0.1223    0.0512    0.0286    0.0234    0.0130    0.0165    0.0009    0.0037
    0.1232    0.6384    0.3938    0.0121    0.1249    0.0711    0.0677    0.0156    0.0061
    0.0468    0.3782    0.1665    0.4025    0.0278    0.0069    0.0243    0.0434    0.0304
    0.0269    0.0121    0.4025    0.8327    0.4129    0.1769    0.1318    0.0278    0.0043
    0.0243    0.1284    0.0173    0.4198    0.2776    0.0937    0.0278    0.0694    0.0564
    0.0139    0.0711    0.0139    0.1769    0.0937    0.3331    0.0208    0.0902    0.0538
    0.0156    0.0625    0.0243    0.1249    0.0312    0.0035    0.7216    0.1457    0.0867
         0    0.0156    0.0434    0.0278    0.0694    0.0867    0.1527    0.8604    0.0824
    0.0039    0.0052    0.0304    0.0043    0.0581    0.0538    0.0867    0.0824    0.1388
```

再看下Polylib中使用 Vandermonde 矩阵方法与 Gauss 方法生成质量矩阵之间误差
```
>> error = CompareMassMatrix(N)

error =

   1.0e-15 *

    0.0312    0.0651    0.0746    0.0373    0.0520    0.0061    0.0156    0.0035    0.0046
    0.0659    0.6106    0.2897    0.0659    0.1509    0.0191    0.0208    0.0156    0.0121
    0.0703    0.2741    0.1110    0.4302    0.1874    0.0833    0.0035    0.0295    0.0199
    0.0356    0.0659    0.4302    0.7772    0.7043    0.1041    0.1041    0.0625    0.0017
    0.0529    0.1544    0.1769    0.7112    0.1665    0.5655    0.1353    0.1110    0.0729
    0.0069    0.0191    0.0902    0.1041    0.5655    0.3886    0.2116    0.0815    0.0147
    0.0147    0.0156    0.0035    0.0971    0.1388    0.1943    0.7772    0.0347    0.0729
    0.0043    0.0156    0.0295    0.0625    0.1110    0.0850    0.0416    0.8882    0.1396
    0.0048    0.0113    0.0199    0.0017    0.0746    0.0147    0.0729    0.1396    0.1110
```

从几种方法对比看来，Vandermonde方法与Gauss方法误差不大，而且节省了大量内存空间。
Vandermonde避免了高斯节点及其权重向量的存储，基函数存储也小于Gauss积分方法。（[N+1 x N+1] < [N+1, N+3]）

####B.微分矩阵相对误差

Polylib中 函数 `Dglj` 计算Lagrange多项式在 Gauss-Lobatto-Jacobi 节点处微分值
$$ D[i\cdot np+j] = \frac{\partial l_j}{\partial z} \Big|_{z=z_i} $$

reshape 之后（切记，按列循环编号从左向右）
$$D_{i,j} = \frac{\partial l_i}{\partial z} \Big|_{z=z_j}$$

注意，`Dglj` 与 `Dmatrix1D` 计算得到的结果 Dr为转置关系

$$Dr_{i,j} = \frac{\partial l_j}{\partial z} \Big|_{z=z_i}$$

对比二者之间计算误差 error
```
function error = CompareDerivaMatrix(N)
%% Polylib
nModes = N+1;
[nodalPoints,nodalWeights] = Polylib.zwglj(nModes);
D = Polylib.Dglj(nodalPoints);
%% NDGFEM
r = nodalPoints;
V  = Vandermonde1D(N, r);
D1 = Dmatrix1D(N, r, V);
%% compare
error = abs(D-D1');

end
```

```
>> error = CompareDerivaMatrix(8)

error =

   1.0e-13 *

    0.0711    0.0622    0.0067    0.0011    0.0139    0.0036    0.0028    0.0011    0.0977
    0.1776    0.0744         0         0    0.0011    0.0011    0.0028    0.0022    0.0910
    0.2132    0.0533    0.0833    0.0089    0.0089    0.0200    0.0033    0.0044    0.1021
    0.1776    0.0266    0.0222    0.0483    0.0133    0.0178    0.0044    0.0178    0.0266
    0.1332    0.0089    0.0133    0.0089    0.0744    0.0044    0.0067    0.0422    0.0977
    0.0577    0.0111    0.0155    0.0111    0.0178    0.0444    0.0311    0.0755    0.1243
    0.0755    0.0200    0.0089    0.0056         0    0.0178    0.0061    0.1332    0.0533
    0.0511    0.0022    0.0028    0.0033    0.0056    0.0178    0.0533    0.2306    0.2487
    0.0044    0.0019    0.0031         0    0.0033    0.0094    0.0133    0.0622    0.1776
```

####C.雅克比多项式误差 & Vandermonde 矩阵误差

生成Vandermonde矩阵关键在于计算雅克比多项式。
Polylib 中提供了函数 jacobfd 可以计算雅克比多项式和其微分多项式，NDGFEM 中对应的函数为 JacobiP。需注意的是，JacobiP 中提供的是标准化的 Jacobi 多项式，因为其积分满足

$$\int_{-1}^1 (1-x)^{\alpha}(1+x)^{\beta} P^{(\alpha, \beta)}\_m(x)P^{(\alpha, \beta)}\_n(x)dx = \frac{2^{\alpha+\beta+1}}{2n+\alpha+\beta+1} \frac{\Gamma(n+\alpha+1)\Gamma(n+\beta+1)}{\Gamma(n+\alpha+\beta+1)n!} \delta_{mn}$$

故函数 jacobfd 与 JacobiP 得到的雅克比多项式之间关系为

$$P^{NDG}\_n(x) = \sqrt{\frac{2n+\alpha+\beta+1}{2^{\alpha+\beta+1}} \frac{\Gamma(n+\alpha+\beta+1)n!}{\Gamma(n+\alpha+1)\Gamma(n+\beta+1)}} P^{Polylib}_n(x)$$

测试函数

```
function error = JacobiPolyTest(N)
%% JacobiP
nModePoints = N + 1;
[nodalPoints,~] = Polylib.zwglj(nModePoints);
V1D = zeros(length(nodalPoints),nModePoints);
for j=1:nModePoints
    V1D(:,j) = JacobiP(nodalPoints(:), 0, 0, j-1);
end
%% Polylib
for j=1:nModePoints
    [p, dp] = Polylib.jacobfd(nodalPoints, j-1);
    V2D(:,j) = p(:)*sqrt((2*(j-1)+1)/2);
end
%% compare
error = abs(V1D - V2D);
end
```

测试结果，Vandermonde矩阵之间误差

```
>>error = JacobiPolyTest(N)

error =

   1.0e-14 *

    0.0111         0    0.0222    0.1110    0.1776    0.1776    0.2665    0.2665    0.3109
    0.0111    0.0222    0.0222    0.0444    0.0722    0.0708    0.0444    0.0222    0.0444
    0.0111         0    0.0111    0.0222    0.0111         0    0.0361    0.0444    0.0444
    0.0111         0    0.0056    0.0111    0.0236    0.0111    0.0333    0.0278         0
    0.0111         0         0         0    0.0111         0         0    0.0000    0.0111
    0.0111    0.0056    0.0056    0.0111    0.0111    0.0111    0.0222    0.0167    0.0111
    0.0111         0    0.0167    0.0278    0.0111    0.0111    0.0222    0.0444    0.0555
    0.0111    0.0222    0.0444    0.0999    0.1499    0.1665    0.1443    0.1110    0.0222
    0.0111         0    0.0222    0.1110    0.1776    0.1776    0.2665    0.2665    0.3109
```

