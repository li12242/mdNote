# Discontinuity detector

KXRCF间断检测器介绍

## 简介
在间断有限元中，最常用的一种间断检测器是 Krivodonova, Xin, Remacle, Chevaugeon 和 Flaherty 于2003年论文 《_Shock Detection and Limiting with Discontinuous Galerkin Methods for Hyperbolic Conservation Laws_》 中提出。其表达式为

$$I_j = \frac{\left| \int_{\partial \Omega_j^-} \left( Q_j - Q_{nbj}\right)ds \right|}{h^{(p+1)/2} \left|\partial \Omega_j^- \right| \| Q_j\|} $$

其中 $\Omega_j^-$ 表示入流边界（$\vec{v}\cdot\vec{n}<0$），而 $Q_j$ 与 $Q_{nbj}$ 为边界上本单元与相邻单元边界值，$\| Q_j\|$ 表示单元内最大值，$h$ 为单元外接圆半径。

根据以上公式对每个单元 $\Omega_j$ 进行计算。当 $I_j>1$ 时，认为单元存在间断；当 $I_j<1$ 时，则为连续单元。

## 代码

实际应用过程中情况更加复杂，原始公式并不适合应用。可能有以下情形发生

1. 单元内不存在入流边界
2. 单元上值全部为0

在这些情形中，公式分母项 $h^{(p+1)/2} \left|\partial \Omega_j^- \right| \| Q_j\|$ 恒为0，而且单元内并不存在间断。因此，更常用的一种方法是采用以下判断形式

$$I_j = \left\{\begin{array}{ll}
1, & \text{if} \, \left| \int_{\partial \Omega_j^-} \left( Q_j - Q_{nbj}\right)ds \right| > o_{distol} \cdot h^{(p+1)/2} \left|\partial \Omega_j^- \right| \| Q_j\| \cr
0, & \text{if} \, \left| \int_{\partial \Omega_j^-} \left( Q_j - Q_{nbj}\right)ds \right| \le o_{distol} \cdot h^{(p+1)/2} \left|\partial \Omega_j^- \right| \| Q_j\| \cr
\end{array}\right.$$

这种方法将分母放在不等式另一侧，避免了分母为0的情形出现。
