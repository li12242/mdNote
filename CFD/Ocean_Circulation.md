
## 1.科氏力和科氏参数

局地旋转角速度

![](http://images.cnblogs.com/cnblogs_com/li12242/755838/o_Rotation.png)

## 2.大尺度运动和Rossby数

| 大气过程 | 长度尺度（km） | 水平速度尺度（m/s） | 时间尺度 |
| --- | --- | --- | --- |
| 海陆风 | 5~50 | 1~10 | 12 h
| 天气过程 | 100~5000 | 1~50 | 天~周
| 盛行风 | 全球尺度 | 5~50 | 季~年
| 气候 | 全球尺度 | 1~50 | 十年以上


| 海洋过程 | 长度尺度（km） | 水平速度尺度（m/s） | 时间尺度 |
| --- | --- | --- | --- |
| 内波 | 1~20 | 0.05~0.5 | 分~小时
| 上升流 | 1~10 | 0.1~1 | 天
| 大涡和锋面 | 0.1~1 | 5~50 | 天~周
| 主要流 | 10~1000 | 0.1~2 | 周~季
| 大尺度环流 | 海盆尺度 | 0.01~0.1 | 十年以上

运动空间尺度特点

* 范围大，基本100km以上

时间尺度特点

* 时间尺度长，一般1个月以上

物理意义：流体相对运动的时间尺度远大于地球自转周期，运动过程自转效应能够感觉到。

Rossby数定义：

$$\xi = \frac{U}{fL}$$

## 3.正压海洋和斜压海洋

正压海洋等密度面和等压面平行，可以将密度看作常数，即

$$\triangledown\rho \times \triangledown p = 0$$

斜压海洋中等密度面不平行于等压面，密度（温度）不是常数

$$\triangledown\rho \times \triangledown p \ne 0$$

## 4.地转运动

基本运动方程为

$$\begin{aligned}
& \frac{du}{dt} -fv = - \frac{1}{\rho}\frac{\partial p}{\partial x} + F_x
& \frac{dv}{dt} +fu = - \frac{1}{\rho}\frac{\partial p}{\partial y} + F_y
\end{aligned}$$

实际海洋中摩擦力等外力很小，相对于科氏力和压力可以忽略，这样运动称之为地转运动。

定常条件下地转运动方程

$$\begin{aligned}
& fv = \frac{1}{\rho}\frac{\partial p}{\partial x}
& fu = - \frac{1}{\rho}\frac{\partial p}{\partial y}
\end{aligned}$$

运动特点：流动垂直于压强梯度，即平行于等压线。在北半球，高压在右手方向。

$$\vec{v} = \vec{k} \times \frac{1}{\rho f}\triangledown p$$

运动状态下的压力$p$可以表示为静压$p_0$和动压$p'$之和

$$p(x,y,z,t) = p_0(z) + p'(x,y,z,t)$$


## 5.准地转运动-$\beta$平面近似

在纬距Y上，$f$的增量为

$$\Delta f = \frac{Y}{r}\frac{\partial f}{\partial \theta} = \frac{Y}{r} 2\Omega cos\theta$$

在一定南北向范围内$f$可以近似看作随维度线性变化

$$\begin{aligned}
& f = f_0 + \beta y
& \beta = \frac{\partial f}{partial y} = \frac{2\Omega}{r}cos\theta \approx const
\end{aligned}$$

这种线性近似称为$\beta$-平面近似。
