#[Sanders_2001] Non-reflecting boundary flux function for finite volume shallow-water models

**Abstract**
implement non-reflecting boundary conditions in finite-volume based shallow-water models


---
##1. Introduction

在缓流（subcritical flow）条件下，开边界指定水位或流量会导致非物理反射生成

The general idea is to introduce a constraint that allows Riemann variables moving along outward-bound characteristics to leave the domain unhampered, while information is simultaneously supplied to the solution domain by the Riemann variables moving along inward-bound characteristics.

---
##2. Background

* At shoreline boundaries, the component of the fluid velocity normal to the boundary is set to zero.
* For Fr > 1, U is completely specified at inflow boundaries and completely unspecified at outflow boundaries. 
* For Fr < 1, U is not completely specified. 

---
