# Boussinesq approximation and Hydrostatic

### 0.Formulation of the RANS equations

不可压缩流体控制方程

$$\begin{array}{l l}
\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}+\frac{\partial w}{\partial z}=0  \cr
\frac{Du}{Dt}-fv=-\frac{1}{\rho}\frac{\partial p}{\partial x}+\frac{\partial }{\partial z} N_z \frac{\partial u}{\partial z} + N_h\Delta u  \cr
\frac{Dv}{Dt}+fu=-\frac{1}{\rho}\frac{\partial p}{\partial y}+\frac{\partial }{\partial z} N_z \frac{\partial v}{\partial z} + N_h\Delta v  \cr
\frac{Dw}{Dt}=-\frac{1}{\rho}\frac{\partial p}{\partial z}-g+\frac{\partial }{\partial z} N_z \frac{\partial w}{\partial z} + N_h\Delta w  \cr
\end{array}$$
其中$N_z$为垂向涡粘系数，$N_h$为水平涡粘系数，分子粘性系数已忽略。

### 1.Boussinesq approximation
Boussinesq 近似假定密度在参考密度附近变化不大，即
$$\rho(\vec{x},t) = \rho_0 + \rho'(\vec{x},t)$$

将控制方程内除了重力之外，所有密度替换为参考密度$\rho_0$，即

$$\begin{array}{l l}
\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}+\frac{\partial w}{\partial z}=0  \cr
\rho_0\frac{Du}{Dt}-fv=-\frac{\partial p}{\partial x}+\rho_0(\frac{\partial }{\partial z} N_z \frac{\partial u}{\partial z} + N_h\Delta u)  \cr
\rho_0\frac{Dv}{Dt}+fu=-\frac{\partial p}{\partial y}+\rho_0(\frac{\partial }{\partial z} N_z \frac{\partial v}{\partial z} + N_h\Delta v)  \cr
\rho_0\frac{Dw}{Dt}=-\frac{\partial p}{\partial z}-\rho g+\rho_0(\frac{\partial }{\partial z} N_z \frac{\partial w}{\partial z} + N_h\Delta w)  \cr
\end{array}$$

### 2.Hydrostic approximation

静压假定包括

1. 忽略垂向粘性
2. 忽略垂向加速度

此时，垂向方程变为
$$\frac{\partial p}{\partial z} = -\rho g$$

注意，此时密度并非为参考密度，而是水体总密度。将动量方程沿垂向进行积分，得
$$p(x,y,z=z_0) = p_a(x,y) + \int_{z=z_0}^{\zeta(x,y)}\rho gdz$$

$p_a(x,y)$为自由表面处大气压强。

将$\rho(\vec{x},t) = \rho_0 + \rho'(\vec{x},t)$代入方程，便可得到压力表达式
$$p(x,y,z=z_0) = p_a(x,y) + (-\rho_0gz_0 + \rho_0g\zeta(x,y) + \int_{z=z_0}^{\zeta(x,y)}\rho' gdz) $$
其中三项分别为正压项，动压项与斜压项。其中$\rho'(x,y,z,t)$根据状态方程求得。

### Appendix A.Mode Splitting
内外模分离方法主要目的是解决海洋模拟中水平计算最大时间步和垂向计算时间步不匹配的问题。

为了模拟表面重力波，根据CFL准则，最大时间步应满足
$$T_h\le \frac{\Delta x}{\sqrt{2gH}}$$
而垂向计算所需时间步仅需满足
$$T_z\le \frac{h_z^2}{2N_z}$$

一般情况下，T_z大约为T_z的10倍以上（FVCOM中推荐取10）。
因此，内外模分离方法主要是解决海洋模拟问题计算过程中，水平尺度和垂直尺度计算时间步不匹配问题。

在水平模拟过程中，由于表面重力波在沿水深方向变化不大，因此可采用垂向积分方程
$$\begin{array}{l l}
\frac{\partial D\bar{u}}{\partial x} + \frac{\partial D\bar{v}}{\partial y} + \frac{\partial \zeta}{\partial t}=0 \cr
\frac{\partial \bar{u}}{\partial t}+A_x -fv=-\frac{1}{\rho_0}\frac{\partial p_a}{\partial x} -g \frac{\partial \zeta}{\partial x} -B_x + C_x+ N_h\Delta \bar{u}  \cr
\frac{\partial \bar{v}}{\partial t}+A_y -fv=-\frac{1}{\rho_0}\frac{\partial p_a}{\partial y} -g \frac{\partial \zeta}{\partial y} -B_y + C_y + N_h\Delta \bar{v}  \cr
\end{array}$$

其中$D=H+\zeta$为总水深。
求解内模时将各层流速时将速度分解为
$$u = \bar{u}+u' ,\quad v = \bar{v}+v' $$
将原始动量方程与垂向积分动量方程作差，可得
$$\begin{array}{l l}
\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}+\frac{\partial w}{\partial z}=0  \cr
\frac{\partial u'}{\partial t}+ u \frac{\partial u}{\partial x} + v \frac{\partial u}{\partial y}+ w \frac{\partial u}{\partial z} - A_x -fv'  = B_x  - \frac{g}{\rho_0}\frac{\partial}{\partial x}\int_z^{\zeta}\rho'dz -C_x + N_h\Delta u' \cr
\frac{\partial v'}{\partial t}+ u \frac{\partial v}{\partial x} + v \frac{\partial v}{\partial y}+ w \frac{\partial v}{\partial z} - A_y +fu'  = B_y  - \frac{g}{\rho_0}\frac{\partial}{\partial y}\int_z^{\zeta}\rho'dz -C_x + N_h\Delta v' \cr
\end{array}$$

根据三个方程，便可求解各层水体流速$u,v,w$
