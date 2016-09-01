# 边界面方程

边界面方程的作用是建立流体在边界上满足的方程。界面方程形式一般为

$$F(x,y,z,t) = 0$$

如常用的自由表面方程$z = \eta(x,y)$。

建立界面方程的基本物理依据是，在边界运动过程中，面上每一点在界面法向速度分量与相邻流体质点在同一方向速度分量相同。

## 1.曲面法向向量

假设$\vec{t} = ({\delta x}, {\delta y}, {\delta z})$为沿曲面$F(x,y,z,t) = 0$的微元向量，即在曲面某点$(x_0, y_0, z_0)$处满足

$$\begin{aligned}
& F(x_0, y_0, z_0, t) = 0 \cr
& F(x_0 + {\delta x}, y_0 + {\delta y}, z_0 + {\delta z}, t) = 0 \cr
\end{aligned}$$

根据上述两式进行微分，得

$$\delta F = \frac{\partial F}{\partial x} \delta x + \frac{\partial F}{\partial y} \delta y + \frac{\partial F}{\partial z} \delta z = 0$$

这说明了$\vec{n}$与曲面上微元$\vec{t}$是正交的，因此曲面单位法向向量为

$$\vec{n} = (\frac{\partial F}{\partial x}, \frac{\partial F}{\partial y}, \frac{\partial F}{\partial z}) \Big/ \sqrt{(\frac{\partial F}{\partial x})^2 +(\frac{\partial F}{\partial y})^2 (\frac{\partial F}{\partial z})^2}$$

## 2.曲面法向速度

曲面上某点法向量为$\vec{n}$，假设$\delta$为沿法向上微元，经过时间$\delta t$后，界面由 P 移动至点 P'，那么

$$\begin{aligned}
& F(x_0, y_0, z_0, t) = 0 \cr
& F(x_0 + n_x{\delta}, y_0 + n_y{\delta}, z_0 + n_z{\delta}, t+\delta t) = 0 \cr
\end{aligned}$$

由方程5得微分方程

$$\frac{\partial F}{\partial t} \delta t + (\frac{\partial F}{\partial x} n_x + \frac{\partial F}{\partial y} n_y + \frac{\partial F}{\partial z} n_z )\delta = 0$$

法向速度大小为

$$v = \frac{\delta}{\delta t} = -\frac{\partial F}{\partial t} \Big/ \sqrt{(\frac{\partial F}{\partial x})^2 +(\frac{\partial F}{\partial y})^2 (\frac{\partial F}{\partial z})^2}$$

## 3.曲面相邻流体质点速度

设流体质点速度为$\vec{v} = (u,v,w)$，沿曲面法向速度为

$$v_n = \vec{v} \cdot \vec{n} = u n_x + v n_y + w n_z = (u\frac{\partial F}{\partial x} + v \frac{\partial F}{\partial y}+ w \frac{\partial F}{\partial z}) \Big/ \sqrt{(\frac{\partial F}{\partial x})^2 +(\frac{\partial F}{\partial y})^2 (\frac{\partial F}{\partial z})^2}$$

令$v = v_n$得

$$\frac{\partial F}{\partial t} + u \frac{\partial F}{\partial x} + v \frac{\partial F}{\partial y} + w \frac{\partial F}{\partial z} = 0$$

（即$\frac{DF}{Dt} = 0$）

## 4.应用

### 自由表面波运动方程

$z = \eta(x,y,t)$，对应界面方程为

$$F = \eta(x,y,t) - z = 0$$

根据$\frac{DF}{Dt} = 0$可得

$$\frac{\partial \eta}{\partial t} + u \frac{\partial \eta}{\partial x} + v \frac{\partial \eta}{\partial y} = w$$
