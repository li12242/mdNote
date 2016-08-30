#A Parallel High-Order Discontinuous Galerkin Shallow Water Model

*Claes Eskilsson*

###Abstract
本文目标
The objective of this study is to assess the performance of the computational core

---
###1.Introduction

The ultimate goal is a scalable, parallel, non-hydrostatic wave solver, based on multilayered Boussinesq-type equations including time-dependent bathymetry and sediment transport.

In this paper we outline the ongoing work of the parallel implementation of non-dispersive two-dimensional shallow water equations (SWE).

>Spectral/hp elements provide a flexible setting where both the element size and the polynomial order within the elements can be altered.

DG格式优点
1. the resulting global mass matrix is block-diagonal. 
Thus, any explicit time-stepping scheme can update the numerical solution in an element-by-element fashion.
2. Incorporate shock-capturing techniques from the FVM.

---
###2.Shallow Water Equations
二维浅水方程

---
###3.Numerical Scheme

####3.2.程序结构
**Cactus Framework**
Cactus is an open source problem solving environment designed for scientists and engineers needing to develop collaborative code for large scale parallel machines.

---
###4.Computational Results
####4.1.Convergence
simple case
1. 波长10m
2. 静水深0.5m
3. 港池10mx10m
解析解？

####4.2.Weak Scaling
Weak scaling indicates the ability of a code to scale up a problem on more cores, increasing the domain size or grid refinement while keeping a constant load on each core.

####4.3.Strong Scaling
Strong scaling indicates the ability to decrease the total run time for a particular problem, scaling across more cores while keeping the overall problem size fixed.

---
###5.Concluding Remarks

---
