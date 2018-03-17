#[Eskilsson_2000] A triangular spectral/hp discontinuous Galerkin method for modelling 2D shallow water equations

*C. Eskilsson*

---
###Summary

---
###1.Introduction

---
###2.控制方程
系数矩阵特征变量
$$\lambda_1 = u s_x + v s_y -c, \quad \lambda_2 = u s_x + v s_y, \quad \lambda_3= u s_x + v s_y + c$$

对应的右/左特征矩阵R与L
$$R = [r_1, r_2, r_3] \quad L=[l_1, l_2, l_3]^T$$

---
###3.间断有限元模型
基函数与collapsed coordinate system

数值通量
旋转矩阵$T$及其逆矩阵$T^{-1}$，将未知数旋转为外法线方向，而后将流量项作逆变换
>we subsequently define $Q = TU_{\delta} = [H,Hu^-,Hv^-]^T$; where $u^-$ and $v^-$ are the velocities in the direction normal and tangential to the edge, respectively. The 1D flux at a Gauss point can be written $$F(U_{\delta})\cdot n = T^{-1}E(Q)$$

---
