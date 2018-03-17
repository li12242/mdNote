#[Eskilsson_2010] An hp-adaptive discontinuous Galerkin method for shallow water flows

*C. Eskilsson*
*hp自适应算法*, *边界条件*

---
###Summary
The model uses an orthogonal modal basis of arbitrary polynomial order p defined on unstructured, possibly non-conforming, triangular elements for the spatial discretization. 

we allow both for the mesh size, h, and polynomial approximation order to dynamically change during the simulation.

It is found that for the case of smooth flows, p-adaptivity is more efficient than h-adaptivity with respect to degrees of freedom and computational time.

---
###1.Introduction

DG求解浅水方程较CG具有优势
DG model was computationally more efficient in achieving a specified error regardless of the larger DoF

DG格式分为两大类
1. models based on a modal expansion basis defined on a collapsed coordinate system
2. models based on nodal expansion basis

CG格式自适应局限在于网格必须一致，已满足$C^0$连续性。
DG格式不需要网格一致，只需要流量连续即可。

---
###2.The Shallow Water Equations
非线性SWE与线性SWE（水深常数）

---
###3.Spectral/hp DG Methods
**Strong form 较 Weak form 有优势**

* it(strong form) involves inner products of the same form as CG schemes.
* the strong form is more robust and generally preferred over the weak form.

**基函数选取**
the hierarchical and modal Proriol–Koornwinder–Dubiner (PKD) basis
其优势
mass matrix is diagonal for straight-sided triangles without resorting to under integration. 

**积分**
线性项完全积分（精确积分），非线性项不完全积分

**自适应**

* 由于阶数不同导致的函数不一致
Functional incompatibility due to difference in polynomial order is handled by using the number of quadrature points corresponding to the largest polynomial order when evaluating the boundary integral
* 由于网格细分导致的几何不一致
Geometric incompatibility due to hanging nodes requires more work. The large edge is split and projected onto two temporary edges. The upwinding is computed using the temporary edges and then projected back to the original large edge.

**边界条件**

* slip wall boundary
classical symmetry technique to evaluate the values at the dummy edges
$\vec{u} \cdot \vec{n} = 0$
* inflow boundaries
set the values at the dummy edge to the known values.
non-reflecting flux function
* outflow boundaries
the values at the dummy edge are set equal to the undisturbed initial state.
non-normal component is significant, sponge layers or relaxation zones should be applied at the open boundary to absorb the outgoing waves.

---
###4.Adaptive
In order to adapt the mesh, an error estimator or error indicator is needed.
typically error indicators rather than error estimators are used.

**误差指示函数**
$$J_e = \sqrt{\int_{K_e}(H_p - H_{p-1})^2 dx } \quad x\in K_e$$

* $J_e$ > tol_refine 
then mark element e for refinement,
* $J_e$ < tol_coarse 
then mark element e for coarsening,
* $max(J_e)$ > tol_restart 
then we refine the mesh and restart the computation from the preceding time-step

**使用p-自适应优点**

* converge to the correct solution faster（assuming that the flow is smooth）
* 比h-自适应有更少的未知数
* simpler and faster as there is no need to update connectivity lists
* the p-derefinement step is conservative

---
###5.算例验证


