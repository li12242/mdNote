# [Dongeren_1997] Absorbing-Generating Boundary Condition for Shallow Water Models
**

---
## Abstract


---
## Introduction

This implies introducing artificial boundaries for the computational region that form the interface to the exterior, which is either not mod- eled or modeled in a simplified way.
人工边界没有模拟或只用简单方法进行模拟

非均匀浅水方程中，在人工边界处指定精确的边界条件也是一个重要内容。

`本文研究目标`
可以在人工边界处生成长波并且吸收向外传出的波动

`目前研究主要内容`
目前人工边界主要集中研究吸收边界（也称辐射，无反射，开）条件

`研究进展`

* Engquist and Majda (1977) 精确的完全无反射边界条件，由于其空间与时间非局部，实际应用存在困难
* Higdon (1986, 1987) 辐射边界一般形式
$$(\frac{\partial}{\partial t} + \frac{c_0}{cos \theta_n} \frac{\partial}{\partial x})^n u = 0$$，其中n为精度，c0为线性相速度
* n=1时，E&M 边界条件简化为 Sommerfeld 辐射条件

以上方法问题：1.入射角已知，反射系数会大幅减小，对一般模型不适用；2.假设解为一定的形式

* Broeze and Van Oaalen (1992) 抛弃以上假设，由边界局部法向能量通量获得边界条件，这种条件只能吸波并应用线性问题
* Hibberd (1977) 非线性浅水方程
* Verboom et al. (1981) 更一般的弱反射边界表达式
* Verboom and Slob (1984) 得到了二阶精度表达式
Verboom两篇文章只合适没有入射波情况

simultaneous generation and absorption


---
## Formulation of the Problem

* 坐标变换，变为特征方程形式，使边界垂直于x轴方向
* 将流量$Q_x$分解为入射流量$Q_{x,i}$与出流流量$Q_{x,r}$两部分
* 根据假设，总体积流量在波传播方向与水位关系 $Q = c_a(\bar{\zeta} - \bar{\bar{\zeta}}) + \bar{\bar{Q}}$
这里假定$\bar{\bar{Q}}$与$\bar{\bar{\zeta}}$同为0，便可得到入射流量、反射流量与对应的入射水位、反射水位的关系 $Q_{x,i}=c \bar{\zeta}_i cos \theta_i; Q_{x,r}=c \bar{\zeta}_r cos \theta_r$

---
