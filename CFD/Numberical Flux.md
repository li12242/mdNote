# 数值通量介绍

* 通量定义
Flux is the amount of information passing through a given surface.
* 数值通量定义
Numerical flux is the flux at the boundary following the normal direction.

### 1.一维一元波动方程示例
#### 1.1.通量介绍
PDE: $u_t+au_x=0$
IC: $u(x,0)=u_0(x)$

利用特征线方法可以得方程解为 $u(x,t) = u_0(x-at)$。
在方程中，称$F(u) = au$为通量。

#### 1.2.数值通量介绍
DG残差方程为
$$\int_{\Omega}l_i (u_t+au_x)dx=0$$
经过一次分部积分后
$$\int_{\Omega}(l_i u_t+au \frac{\partial l_i}{\partial x})dx + (l_i au)\_{x=1} - (l_i (au))_ {x=-1}=0$$

或者使用更一般的外法线向量
$$\int_{\Omega}(l_i u_t+au \frac{\partial l_i}{\partial x})dx + \oint l_i \vec{n} (au)^* ds=0$$

其中 $\vec{n}F^* = \vec{n}(au)^* $ 数值通量就是在单元边界处沿法向通量的近似，下面通过多元方程组具体介绍。

---
### 2.一维多元方程组中通量求解
#### 2.1.通量真实解
在方程组之中，无法直接使用特征线方法得到方程的解。而通过变量变换的方法得到特征变量后，可以转化为多个一元波动方程形式。下面具体介绍

以Euler方程为例
$$\begin{matrix}
\frac{\partial \rho}{\partial t} + \rho_0\frac{\partial u}{\partial x} = 0 \cr
\frac{\partial u}{\partial t} + \frac{a^2}{\rho_0} \frac{\partial \rho}{\partial x} = 0
\end{matrix}$$

将方程写为矢量形式
$$\frac{\partial U}{\partial t} + A\frac{\partial U}{\partial x} = 0$$
其中$A = \frac{\partial F(U)}{\partial U} = \begin{bmatrix} 0 & \rho_0 \cr \frac{a^2}{\rho_0} & 0 \end{bmatrix}$
求矩阵A特征值$\lambda_1 = a, \lambda_2=-a$及对应特征变量$K = \begin{bmatrix} k_1 & k_2 \end{bmatrix} = \begin{bmatrix} \rho_0 & \rho_0 \cr -a & a \end{bmatrix}$

矩阵特征值与特征向量关系为
$$AK = K\Lambda$$
其中$\Lambda = \begin{bmatrix} \lambda_1 & 0 \cr 0 & \lambda_2 \end{bmatrix}$

令$U = KW$，将$U$代入矢量形式方程组
$$K\frac{\partial W}{\partial t} + AK\frac{\partial W}{\partial x} = 0$$
$$K\frac{\partial W}{\partial t} + K\Lambda\frac{\partial W}{\partial x} = 0$$
$$\frac{\partial W}{\partial t} + \Lambda\frac{\partial W}{\partial x} = 0$$
写为一般形式
$$\begin{matrix}\frac{\partial w_1}{\partial t} -a \frac{\partial w_1}{\partial x} = 0 \cr
\frac{\partial w_2}{\partial t} +a \frac{\partial w_2}{\partial x} = 0 \end{matrix} $$

其中$W = K^{-1}U = \begin{bmatrix} w_1 \cr w_2 \end{bmatrix} = \begin{bmatrix} \frac{\rho}{2\rho_0} - \frac{u}{2a} \cr \frac{\rho}{2\rho_0} + \frac{u}{2a} \end{bmatrix}$为特征变量，可以看出特征变量方程分别为两个一元波动方程，波速分别为$-a$与$a$。若对应特征变量的初始值

$W_L = K^{-1}U_L = \begin{bmatrix} \alpha_L \cr \beta_L \end{bmatrix} = \begin{bmatrix} \frac{\rho_L}{2\rho_0} - \frac{u_L}{2a} \cr \frac{\rho_L}{2\rho_0} + \frac{u_L}{2a} \end{bmatrix}$，
$W_R = K^{-1}U_R = \begin{bmatrix} \alpha_R \cr \beta_R \end{bmatrix} = \begin{bmatrix} \frac{\rho_R}{2\rho_0} - \frac{u_R}{2a} \cr \frac{\rho_R}{2\rho_0} + \frac{u_R}{2a} \end{bmatrix}$，
因此特征变量的解为
$W(0,t) = \begin{bmatrix} \alpha_R \cr \beta_L \end{bmatrix} = \begin{bmatrix} \frac{\rho_R}{2\rho_0} - \frac{u_R}{2a} \cr \frac{\rho_L}{2\rho_0} + \frac{u_L}{2a} \end{bmatrix}$
对应的变量
$U(x,0) = KW(x,0) = \begin{bmatrix} \rho_0 & \rho_0 \cr -a & a \end{bmatrix} \begin{bmatrix} \alpha_R \cr \beta_L \end{bmatrix} = \begin{bmatrix} \frac{\rho_R}{2\rho_0} - \frac{u_R}{2a} \cr \frac{\rho_L}{2\rho_0} + \frac{u_L}{2a} \end{bmatrix} = \begin{bmatrix} \frac{\rho_L+\rho_R}{2}+ \frac{\rho_0}{2a}(u_L-u_R) \cr \frac{u_L+u_R}{2}+\frac{a}{2\rho_0}(\rho_L-\rho_R) \end{bmatrix}$

$$F(x,0) = \begin{bmatrix} 0 & \rho_0 \cr \frac{a^2}{\rho_0} & 0 \end{bmatrix}\begin{bmatrix} \frac{\rho_L+\rho_R}{2}+ \frac{\rho_0}{2a}(u_L-u_R) \cr \frac{u_L+u_R}{2}+\frac{a}{2\rho_0}(\rho_L-\rho_R) \end{bmatrix}
= \begin{bmatrix} \rho_0 \frac{u_L+u_R}{2}+\frac{a}{2}(\rho_L - \rho_R) \cr \frac{a^2}{2\rho_0} (\rho_L+\rho_R) + \frac{a}{2}(u_L - u_R) \end{bmatrix}$$

#### 2.2.不转换特征变量直接获得U与F(U)的近似方法
##### 2.2.1.流量分离方法

$F(x,0) = AU(x,0) = AKW(x,0) = A \begin{bmatrix} k_1 & k_2 \end{bmatrix} \begin{bmatrix} \alpha_R \cr \beta_L \end{bmatrix} = Ak_1 \alpha_R + Ak_2\beta_L$
其中$k_1, k_2$是$A$的特征向量

$F(x,0) = \lambda_1k_1\alpha_R + \lambda_2 k_2 \beta_L$

其中$\lambda_1 = -a, \lambda_2=a$。
定义如下符号

$\lambda^{+} = max(\lambda,0) = 0.5(\lambda + \begin{vmatrix} \lambda \end{vmatrix})$
$\lambda^{-} = max(\lambda,0) = 0.5(\lambda - \begin{vmatrix} \lambda \end{vmatrix})$

$F(x,0)= \begin{bmatrix} k_1 & k_2 \end{bmatrix} \begin{bmatrix} \lambda_1 & 0 \cr 0 & 0 \end{bmatrix} \begin{bmatrix} \alpha_R \cr \beta_R \end{bmatrix} + \begin{bmatrix} k_1 & k_2 \end{bmatrix} \begin{bmatrix} 0 & 0 \cr 0 & \lambda_2 \end{bmatrix} \begin{bmatrix} \alpha_L \cr \beta_L \end{bmatrix} $
$= K \Lambda^{-} \begin{bmatrix} \alpha_R \cr \beta_R \end{bmatrix} + K \Lambda^{+} \begin{bmatrix} \alpha_L \cr \beta_L \end{bmatrix} = A^{-}KW_R +A^{+}KW_L = A^{-}U_R+A^{+}U_L$

其中$A^{+}=K\Lambda^{+}K^{-1}, A^{-}=K\Lambda^{-}K^{-1}$

##### 2.2.2.数值通量

当边界只有两个波速时，HLL通量表达式可以得到与精确解完全相同的表达式

$$f^{* } = \left\{ \begin{array}{cl}
f_L & s_L \geq 0  \cr
\frac{s_Rf_L - s_L f_R +s_L s_R(u_R - u_L)}{s_R - s_L} & s_L \leq0\leq s_R \cr
f_R &s_R \leq 0
\end{array} \right.$$

其中$s_L$是较小波速，$s_R$是较大波速，即为矩阵A的特征值$lambda$。

从以上介绍可看出，数值通量计算方法可以得到与精确解接近的边界通量值，而且计算简单，只需要得到边界处系数矩阵A的特征值即可

---
### 3.一维多元方程组离散及数值通量求解

在数值求解过程中，并非按照边循环，而是根据单元循环，这时有个问题：哪边才是$U_L$？

下面强调两个显然的常识
1. 通量是有方向的，其方向沿坐标轴正向
2. 数值通量是通量沿外法线方向投影，没有方向，其数值是唯一的

#### 3.1.通量方向性
波动方程中

$\frac{\partial u}{\partial t}+\frac{\partial F}{\partial x} = 0$

当变换坐标，令$x' = -x$，此时通量$F'$变为

$\frac{\partial u}{\partial t}+\frac{\partial F}{\partial x'}\frac{\partial x'}{\partial x} = \frac{\partial u}{\partial t}+\frac{\partial F'}{\partial x'} = 0$

故$F' = \frac{\partial x'}{\partial x}F = -F$

而我们求解的数值通量$\vec{n}F^*$为通量沿外法线方向投影。
或许我们可以**首先变换坐标，使通量沿外法线方向，然后直接计算边界处通量**，而不必再次进行投影计算。而且此时计算节点只有内外点之分，不再分左右。

#### 3.2.二元一维方程实例

简单的波动方程组

$\left\{\begin{matrix}
\frac{\partial u}{\partial t}+s\frac{\partial u}{\partial x} = 0 \cr
\frac{\partial v}{\partial t}+t\frac{\partial v}{\partial x} = 0
\end{matrix}\right.$

其系数矩阵$A = \begin{bmatrix}s & 0 \cr 0 & t \end{bmatrix}$，假设$s \leq 0 \leq t$

**通量精确解**
由特征线方法我们很快知道其通量精确解为$F^* = \begin{bmatrix} s\rho_R \cr t u_L \end{bmatrix}$

![](fig/2.png)

**数值通量精确解**
对于左侧单元，其外法向量$\vec{n}_L = 1$，右侧单元$\vec{n}_R = -1$，故
$\vec{n}_L F^{* } = \begin{bmatrix} s\rho_R \cr t u_L \end{bmatrix}$，$\vec{n}_R F^{* } = \begin{bmatrix} -s\rho_R \cr -t u_L \end{bmatrix}$

对于左侧单元$u_L$是内点数值，$\rho_R$是外点数值，一般使用$u^{-}$与$\rho^{+}$表示。由此对左右两侧单元来说，其数值通量用内外点表示为
$\vec{n}_L F^{* } = \begin{bmatrix} s\rho^{+} \cr t u^{-} \end{bmatrix}$，$\vec{n}_R F^{* } = \begin{bmatrix} -s\rho^{-} \cr -t u^{+} \end{bmatrix}$

**HLL通量**
使用HLL通量求解通量，首先确定波速$s_L, s_R$

$s_L = min(s, t)=s, s_R =max(s,t)=t$
$$f^{hll} = \begin{array}{ll}
\frac{t (s\rho_L) - s(s\rho_R) +st(\rho_R - \rho_L)}{t - s} = \frac{s(t-s)\rho_R}{t-s} = s\rho_R \cr
\frac{t (t u_L) - s(t u_R) +st(u_R - u_L)}{t - s} = \frac{t(t-s)u_L}{t-s} = tu_L \cr
\end{array} $$

一般的HLL通量
$$f^{hll} = \frac{s_Rf_L - s_L f_R +s_L s_R(u_R - u_L)}{s_R - s_L}$$
对于左侧单元来说，HLL通量
$$F^{hll} = \frac{s^+ F^- - s^- F^+ +s^- s^+(U^+ - U^-)}{s^+ - s^-}$$

且由于左侧单元通量$F^* $与外法向方向同向，因此其数值通量 $\vec{n}F^* $ 与 $F^{hll}$ 完全相同。

#### 3.3.变换坐标的数值通量求解

仍然变换x轴坐标，令$x' = -x$，此时通量$F'$变为$F' = \begin{bmatrix} -s\rho \cr -tu \end{bmatrix}$，而$A' = \frac{\partial F'(U)}{\partial U} = -\frac{\partial F(U)}{\partial U} = -A$，所以$A'$的特征根也与$A$的特征根互为相反数。

$F_L' = -F_L, F_R' = -F_R$

$s_L = min(-s, -t) = -t, s_R = max(-s, -t) = -s$
$$f^{hll} = \begin{array}{ll}
\frac{-s (-s\rho_L) + t(-s\rho_R) +st(\rho_R - \rho_L)}{-s + t} = \frac{s(s-t)\rho_L}{t-s} = -s\rho_L \cr
\frac{-s (-t u_L) + t(-t u_R) + st(u_R - u_L)}{-s + t} = \frac{t(s-t)u_R}{t-s} = -tu_R \cr
\end{array} $$

可看出，变换坐标轴后$f^{hll}$通量表达式变为

$f^{hll} = \begin{bmatrix} -s\rho^{-} \cr -t u^{+} \end{bmatrix}$，可以看出，坐标变换后与$\vec{n}_R F^{* }$内外点表达式完全相同

**注意**，转换坐标过程中
* 所有通量变换了符号
* 所有波速变换了符号

### 3.高维方程数值通量求解

以上方法适合所有一维空间问题，下面看如何在高维空间计算数值通量。

![](fig/triangle.png)

以二维Euler方程为例

$$\frac{\partial U}{\partial t} + \frac{\partial F}{\partial x} + \frac{\partial G}{\partial y} = 0$$

其中
$$U = \begin{bmatrix} \rho \cr \rho u \cr \rho v \cr E \end{bmatrix} \quad
F = \begin{bmatrix} \rho u \cr \rho u^2 + P \cr \rho uv \cr u(E+P) \end{bmatrix} \quad
G = \begin{bmatrix} \rho v \cr \rho uv \cr \rho v^2+P \cr v(E+P) \end{bmatrix}$$

高维方程中，数值通量有两个分量$F$与$G$，其正方向分别沿$x,y$轴正方向

对残差方程分部积分后得

$$\int_{\Omega} \frac{\partial U}{\partial t}l_i - F\frac{\partial l_i}{\partial x} - G\frac{\partial l_i}{\partial y}d{\Omega} + \oint_{\partial \Omega}l_i( n_xF + n_yG)^* ds = 0$$

可以看出，我们最后所求仍然是通量沿外法线方向投影$( n_xF + n_yG)^* $，故上面所讨论的坐标轴变换方法仍然适用，这里只需将x轴正向变换为沿外法线方向即可。

新坐标轴$e' = \begin{bmatrix} e_x' \cr e_y' \end{bmatrix} = \begin{bmatrix} nx & ny \cr -ny & nx \end{bmatrix} \begin{bmatrix} e_x \cr e_y \end{bmatrix} $

法向通量$F' = n_xF + n_yG$

**降维**
