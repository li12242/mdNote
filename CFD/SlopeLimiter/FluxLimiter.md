内容翻译自[wikipedia](https://en.wikipedia.org/w/index.php?title=Flux_limiter&oldid=645121326)

# Flux limiter

流量限制器（Flux limiters）应用在高精度格式中-这种数值方法用来求解科学与工程问题，特别是由偏微分方程（PDE's）描述的流体动力学。高精度数值方法，如MUSCL格式，可以避免由于高阶空间离散格式在间断或大梯度处引起的高阶振荡（wiggles）。使用流量限制器，并且配合合适的高精度格式，可使格式满足总变差减小（TVD）性质。

注意流量限制器也称作梯度限制器，因为他们有相同的数学形式，都能够限制间断位置附近解的梯度。通常“流量限制器”用在限制算子作用在方程组流量项时候，而“梯度限制器”应用与限制器作用在方程变量上情况（system states）

# 如何工作

构建通量限制器的主要思想是限制空间导数计算使其接近实际值 - 在科学和工程问题中，这通常是指物理上可实现的并且有意义的值。它们被用在高分辨率的方法中来解决由偏微分方程描述的问题，并且只有大梯度的锋面存在时才发挥作用。对于平滑变换波形，通量限制器不起作用而空间导数可通过高阶近似方法求解并且不会引入高阶振荡。考虑下面的一维半离散格式，

$$
\frac{d u_i}{d t} + \frac{1}{\Delta x_i} \left[
F \left( u_{i + \frac{1}{2}} \right) - F \left( u_{i - \frac{1}{2}} \right)  \right] =0
$$

这里 $F( u_{i + \frac{1}{2}} )$ 与 $F ( u_{i - \frac{1}{2}} )$ 代表边界 $i$ 上数值通量。如果边界上通量可以有高阶和低阶两种格式，那么流量限制器就可以依据附近单元梯度使边界流量在这两种流量之间进行转换，如

$$
\begin{aligned}
& F \left( u_{i + \frac{1}{2}} \right) = f^{low}\_{i + \frac{1}{2}}  - \phi\left( r_i \right)
\left( f^{low}\_{i + \frac{1}{2}}  - f^{high}\_{i + \frac{1}{2}}  \right)  \cr
& F \left( u_{i - \frac{1}{2}} \right) = f^{low}\_{i - \frac{1}{2}}  - \phi\left( r_{i-1} \right)
\left( f^{low}\_{i - \frac{1}{2}}  - f^{high}\_{i - \frac{1}{2}}  \right)\end{aligned}
$$

这里

$f^{low}$ 低精度，高分辨率流量
$f^{high}$ 高精度，低分辨率流量
$\phi(r)$ 流量限制器函数

并且$r$代表网格上连续梯度比值

$$
r_{i} = \frac{u_{i} - u_{i-1}}{u_{i+1} - u_{i}}
$$

限制函数要求大于或者等于0，$\phi(r)\geq 0$。因此，当限制器为0时（附近存在大梯度，相反的斜率符号或者0梯度），流量项相当于低精度格式。类似的，当限制器为1时（连续解），就由高分辨率格式表示。不同的限制器有不同的切换特性，根据不同的问题和求解格式而选择不同格式。没有发现哪种限制器能够完美解决所有问题，限制器格式的选择通常由反复的试验决定。

# 限制函数

下面是一些常用的流量限制器/斜率限制器形式，$\phi(r)$：
1. CHARM [not 2nd order TVD] (Zhou, 1995)

$$
\phi_{cm}(r)=\left\{ \begin{array}{ll}
\frac{r \left( 3r+1 \right)}{\left(r+1 \right)^{2}} \quad r>0 \quad\lim_{r\rightarrow\infty}\phi_{cm}(r)=3 \cr
0 \quad , \quad r\le 0
\end{array}\right.
$$

2. HCUS [not 2nd order TVD] (Waterson & Deconinck, 1995)

$$
\phi_{hc}(r) =  \frac{ 1.5 \left(r+\left| r \right| \right)}{ \left(r+2 \right)} ; \quad \lim_{r \rightarrow \infty}\phi_{hc}(r) = 3
$$

3. HQUICK [not 2nd order TVD] (Waterson & Deconinck, 1995)

$$
\phi_{hq}(r) =  \frac{2 \left(r + \left|r \right| \right)}{ \left(r+3 \right)} ; \quad \lim_{r \rightarrow \infty}\phi_{hq}(r) = 4
$$

4. Koren (Koren, 1993) – third-order accurate for sufficiently smooth data[1]

$$
\phi_{kn}(r) = \max \left[ 0, \min \left(2 r, \left(2 + r \right)/3, 2 \right) \right]; \quad \lim_{r \rightarrow \infty}\phi_{kn}(r) = 2
$$

5. minmod – symmetric (Roe, 1986)

$$
\phi_{mm} (r) = \max \left[ 0 , \min \left( 1 , r \right) \right] ; \quad \lim_{r \rightarrow \infty}\phi_{mm}(r) = 1
$$

6. monotonized central (MC) – symmetric (van Leer, 1977)

$$
\phi_{mc} (r) = \max \left[ 0 , \min \left( 2 r, 0.5 (1+r), 2 \right) \right]  ; \quad \lim_{r \rightarrow \infty}\phi_{mc}(r) = 2
$$

7. Osher (Chatkravathy and Osher, 1983)

$$
\phi_{os} (r) = \max \left[ 0 , \min \left( r, \beta \right) \right], \quad \left(1 \leq \beta \leq 2 \right) ; \quad \lim_{r \rightarrow \infty}\phi_{os} (r) = \beta
$$

8. ospre – symmetric (Waterson & Deconinck, 1995)

$$
\phi_{op} (r) = \frac{1.5 \left(r^2 + r  \right) }{\left(r^2 + r +1 \right)}  ; \quad \lim_{r \rightarrow \infty}\phi_{op} (r) = 1.5
$$

9. smart [not 2nd order TVD] (Gaskell & Lau, 1988)

$$
\phi_{sm}(r) = \max \left[ 0, \min \left(2 r, \left(0.25 + 0.75 r \right), 4 \right)  \right] ; \quad \lim_{r \rightarrow \infty}\phi_{sm}(r) = 4
$$

10. superbee – symmetric (Roe, 1986)

$$
\phi_{sb} (r) = \max \left[ 0, \min \left( 2 r , 1 \right), \min \left( r, 2 \right) \right]  ; \quad \lim_{r \rightarrow \infty}\phi_{sb} (r) = 2
$$

11. Sweby – symmetric (Sweby, 1984)

$$
\phi_{sw} (r) = \max \left[ 0 , \min \left( \beta r, 1 \right), \min \left( r, \beta \right) \right],  \quad    \left(1 \leq \beta \leq 2 \right) ; \quad \lim_{r \rightarrow \infty}\phi_{sw} (r) = \beta
$$

12. UMIST (Lien & Leschziner, 1994)

$$
\phi_{um}(r) = \max \left[ 0, \min \left(2 r, \left(0.25 + 0.75 r \right),  \left(0.75 + 0.25 r \right), 2 \right)  \right]  ; \quad \lim_{r \rightarrow \infty}\phi_{um}(r) = 2
$$

13. van Albada 1 – symmetric (van Albada, et al., 1982)

$$
\phi_{va1} (r) = \frac{r^2 + r}{r^2 + 1 }  ; \quad \lim_{r \rightarrow \infty}\phi_{va1} (r) = 1
$$

14. van Albada 2 – alternative form [not 2nd order TVD] used on high spatial order schemes (Kermani, 2003)

$$
\phi_{va2} (r) = \frac{2 r}{r^2 + 1} ; \quad \lim_{r \rightarrow \infty}\phi_{va2} (r) = 0
$$

15. van Leer – symmetric (van Leer, 1974)
$$
\phi_{vl} (r) = \frac{r + \left| r \right| }{1 +  \left| r \right| }  ; \quad \lim_{r \rightarrow \infty}\phi_{vl} (r) = 2
$$

上面所有对称型限制器都具有如下对称性质：

$$
\begin{aligned}
\frac{ \phi \left( r \right)}{r} = \phi \left( \frac{1}{r} \right)
\end{aligned}
$$

这个对称性质可以保证限制过程不管是向前或者向后结果都是相同的。

除非明确指出，以上限制器函数都是二阶。这代表它们都设计为通过解的某个特殊区域，及TVD区域，来保证格式的稳定性。二阶精度，TVD限制器至少满足以下条件

* $r \le \phi(r) \le 2r, \left( 0  \le r \le 1 \right)$
* $1 \le \phi(r) \le r, \left( 1 \le r \le 2 \right)$
* $1 \le \phi(r) \le 2, \left( r > 2 \right)$
* $\phi(1) = 1$

二阶TVD格式的允许区域如下图所示（Sweby Diagram），每个限制函数同时绘制在图中。在Osher和Sweby限制函数中，$\beta$取值为1.5

![](https://upload.wikimedia.org/wikipedia/en/thumb/b/bc/LimiterPlots1.png/650px-LimiterPlots1.png)

## 一般的minmod限制器

余下的一种限制器形式较特殊，val-Leer的单变量限制器(van Leer, 1979; Harten and Osher, 1987; Kurganov and Tadmor, 2000)。其形式如下

$$
\phi_{mg}(u,\theta)=\max\left(0,\min\left(\theta r,\frac{1+r}{2},\theta\right)\right),\quad\theta\in\left[1,2\right].
$$

注意：当 $\theta=1$ 时 $\phi_{mg}$ 耗散形最强，当 $\theta=2$ 时， $\phi_{mg}$ 简化为 $\phi_{mm}$，耗散性最小。
