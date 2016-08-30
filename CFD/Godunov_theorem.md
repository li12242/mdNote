#Godunov's theorem

转自[Wiki](https://en.wikipedia.org/w/index.php?title=Godunov%27s_theorem&oldid=629042350)

[TOC]

##简介

在数值计算和计算流体动力学中，Godunov定理（Godunov's theorem 或 Godunov's order barrier theorem）是采用高精度数值方法计算偏微分方程中的重要数学定理。

定理陈述为：
>采用线性数值格式求解偏微分方程时，如果数值解不产生新的极值，那么格式精度最多为1阶。

Sergei K. Godunov 教授首先在其博士阶段（莫斯科国立大学）证明这个定理。这是他在应用数学研究中最具影响的工作，对科学与工程及其他领域特别是计算流体力学（CFD）有深刻的影响。

##定理

同样可参考Wesseling (2001)。

假设一个连续体问题由PDE描述，并且使用数值方法在进行计算，只进行一步，均匀网格，$M$个节点，积分算法，显式或者隐式。如果 $x_j = j\Delta x$，$t^n = n\Delta t$，那么一个数值格式可以表示为

$$\begin{equation}
\sum^{M}\_{m = 1}\beta_m \varphi\_{j+m}^{n+1} = \sum^{M}\_{m = 1}\alpha_m \varphi\_{j+m}^{n} 
\end{equation}$$

换句话说，计算值 $\varphi\_{j}^{n+1}$ 在时刻 $n+1$ 节点 $j$ 是当前时刻解 $n$ 的线性函数形式。我们假设 $\beta_m$ 唯一的决定了 $\varphi\_{j}^{n+1}$。现在，既然上述方程代表了 $\varphi\_{j}^{n+1}$ 与 $\varphi\_{j}^{n}$ 之间线性关系，那么我们可以采用线性转换得到下面等价形式，

$$\begin{equation}
\varphi\_{j}^{n+1} = \sum^{M}\_{m = 1}\gamma_m \varphi\_{j+m}^{n} 
\end{equation}$$


###定理1. 单调保持性（Monotonicity preserving）

>若格式（2）是单调保持的，那么
$$\begin{equation}
\gamma_m \ge 0
\end{equation}$$

证明：Godunov (1959)

**case 1：充分性**

假设 $\varphi\_{j}^{n}$ 是随 $j$ 单调递增的，那么，由于 $\varphi\_{j}^{n} \le \varphi\_{j+1}^{n} \le \cdots \le \varphi\_{j+m}^{n} $，因此 

$$\begin{equation}
\varphi\_{j}^{n+1} - \varphi\_{j-1}^{n+1} = \sum^{M}\_{m = 1}\gamma_m (\varphi\_{j+m}^{n} -  \varphi\_{j+m-1}^{n}) \ge 0
\end{equation}$$

即 $\varphi\_{j}^{n+1} \le \varphi\_{j+1}^{n+1} \le \cdots \le \varphi\_{j+m}^{n+1} $，得证。

**case 2：必要性**

由矛盾证明必要性。
假设 $\gamma_p < 0$，$p$ 为某个节点，采用如下单调增加的序列 $\varphi\_{j}^{n}$

$$\begin{equation}
\varphi\_{j}^{n} = 0, \quad i < k; \quad \varphi\_{j}^{n} = 1, \quad i \ge k.
\end{equation}$$

根据方程（2）可以得到

$$\begin{equation}
\varphi\_{j}^{n+1} - \varphi\_{j-1}^{n+1} = \sum^{M}\_{m = 1}\gamma_m (\varphi\_{j+m}^{n} -  \varphi\_{j+m-1}^{n}) = \left\\{ 
\begin{array}{ll}
0, & [j+m \ne k] \cr
\gamma_m, & [j+m =k]
\end{array}
\right.
\end{equation}$$

现在令 $j = k - p$， 那么

$$\begin{equation}
\varphi\_{k-p}^{n+1} - \varphi\_{k-p-1}^{n+1} = \gamma_p(\varphi\_{k}^{n} -  \varphi\_{k-1}^{n}) < 0
\end{equation}$$

这与 $\varphi\_{j}^{n+1}$ 的单调性矛盾，得证。

###定理2. Godunov’s Order Barrier Theorem

>若使用单步，二阶精度求解对流方程
$$\begin{equation}
\frac{\partial \varphi}{\partial t} + c \frac{\partial \varphi}{\partial x} = 0,AcademicWriting \quad t>0
\end{equation}$$
只有当
$$\begin{equation}
\sigma = |c|\frac{\Delta t}{\Delta x} \in \mathcal{N}
\end{equation}$$
时，格式才是单调保持的，
其中 $\sigma$ 为柯朗数（Courant–Friedrichs–Lewy condition number）


证明：Godunov (1959)

假设初始解为

$$\begin{equation}
\varphi(0,x) = \big(\frac{x}{\Delta x} - \frac{1}{2} \big)^2 - \frac{1}{4}
\end{equation}$$

那么其精确解为

$$\begin{equation}
\varphi(t,x) = \big(\frac{x - ct}{\Delta x} - \frac{1}{2} \big)^2 - \frac{1}{4}
\end{equation}$$

假设格式至少有二阶精度，那么第0步与第1步精确解如下

$$\begin{equation}
\varphi_j^1 = \big(j - \sigma - \frac{1}{2} \big)^2 - \frac{1}{4}, \quad \varphi_j^0 = \big(j - \frac{1}{2} \big)^2 - \frac{1}{4}
\end{equation}$$

将方程（2）代入，得：

$$\begin{equation}
\big(j - \sigma - \frac{1}{2} \big)^2 - \frac{1}{4} = \sum_m^M \gamma_m \big[ \big(j+m - \frac{1}{2} \big)^2 - \frac{1}{4} \big]
\end{equation}$$

假设格式具有单调保持性质，那么根据定理1，$\gamma_m \ge 0$

因此

$$\begin{equation}
\big(j - \sigma - \frac{1}{2} \big)^2 - \frac{1}{4} \ge 0
\end{equation}$$

假设 $\sigma>0$，并且 $\sigma \notin \mathcal{N}$，那么存在 $j$ 使得 $j>\sigma>(j-1)$，这使得

$$\begin{equation}
\big(j - \sigma - \frac{1}{2} \big)^2 - \frac{1}{4} = (j- \sigma)(j - \sigma - 1) < 0
\end{equation}$$

这与方程（16）矛盾，因此得证。

这里 $\sigma = |c|\frac{\Delta t}{\Delta x} \in \mathcal{N}$ 仅是用于理论证明，并无法将其当作实际计算时系数，CFL为整数情况在实际计算中并不实用。

---

这里，单调保持的格式即保证不出现新的极值

##参考