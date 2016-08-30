# TVB斜率限制器

本文参考源程序来自[Fluidity](http://fluidityproject.github.io/)。

## 简介

TVB斜率限制器最早由Cockburn和Shu（1989）提出，其主要特点是提出了修正minmod函数

$$\tilde{m}(a_1, a_2, \cdots, a_n) = \left\{
\begin{array}{ll}
a_1 & \text{if} \, \left| a_1 \right| \le Mh^2, \cr
m\left(a_1, a_2, \cdots, a_n\right) & \text{otherwise}, \end{array}\right.$$

其中$m\left(a_1, a_2, \cdots, a_n\right)$为原始minmod函数，$M$为系数。

## 高维TVB限制器

针对高维情形可以参考Cockburn和Shu[2]的研究，其中最关键的步骤在于构造修正minmod函数的两个参数

$$a_1 = \tilde{u}_h(m_i, K_0), \quad a_2 = v\Delta\bar{u}_h(m_i, K_0)$$

![](http://ww3.sinaimg.cn/large/7a1c18a8jw1f71rel68p5j209o07ut8w.jpg)

其中 $\tilde{u}_h(m_i, K_0)$ 为边界中点处近似解与单元均值之差 $u_h(m_i, K_0) - \bar{u}_{K_0}$，$\bar{u}_{K_0}$ 为单元 $K_0$ 的单元均值。而这个 $\Delta\bar{u}_h(m_i, K_0)$ 则是根据几何坐标插值后得到的边界中心值 $u_h(m_1)$ 与 $\bar{u}_{K_0}$ 之间差值，$v$ 为大于1的系数，一般取1.5左右。

几何插值系数根据三个单元间坐标关系而定。如在计算边中点 $m_1$ 的系数时，首先需确定除 $b_0$ 和 $b_1$ 外要取哪个单元进行插值（$b_2$ 或 $b_3$），其中选取原则为以下两点

1. 单元 $b_1$ 所占比例尽量大
2. 中点 $m_1$ 尽量在两条射线 $b_0 - b_1$ 与 $b_0 - b_2$ 之间

在确定第三个单元之后，我们便可以确定中点 $m_1$ 插值系数。插值公式为

$$u_h(m_1) - u_h(b_0) = \alpha_1 \left( u_h(b_1) - u_h(b_0) \right) + \alpha_2 \left( u_h(b_2) - u_h(b_0) \right)$$

其中插值系数根据三个三角形单元形心坐标而定

$$\left\{ \begin{array}{ll}
x_{m_1} - x_{b_0} = \alpha_1 \left( x_{b_1} - x_{b_0} \right) + \alpha_2 \left( x_{b_2} - x_{b_0} \right) \cr
y_{m_1} - y_{b_0} = \alpha_1 \left( y_{b_1} - y_{b_0} \right) + \alpha_2 \left( y_{b_2} - y_{b_0} \right)
\end{array} \right.$$

在得到修正后的边界值与均值之差后，修正过程并没有结束。因为可能TVB限制器只修正了三个边中某两个边中点值，而剩下的边中点值保持不变，若此时采用新的三个边中点值进行重构，得到的重构值均值区别于原始单元均值，造成单元不守恒。

为解决此问题，需要对修正后的插值进行修正。假设 $\Delta_i$ 为限制器得到的解

$$\Delta_i = \tilde{m}\left(\tilde{u}_h(m_i, K_0),  v\Delta\bar{u}_h(m_i, K_0)\right)$$

由于 $\Delta_i$ 代表限制后边界中点值与单元均值之差，因此应当满足 $\sum_{i=1}^3 \Delta_i = 0$。若 $\sum_{i=1}^3 \Delta_i \neq 0$，计算修正系数 $\theta^+$ 与 $\theta^-$

$$\begin{array}{ll}
pos = \sum_{i=1}^3 \text{max} \left(0, \Delta_i\right), \quad neg = \sum_{i=1}^3 \text{max} \left(0, -\Delta_i\right) \cr
\theta^+ = \text{min} \left(1, \frac{neg}{pos} \right), \quad \theta^- = \text{min} \left(1, \frac{pos}{neg} \right)
\end{array}$$

其中 $pos$ 与 $neg$ 分别是 $\Delta_i$ 中正系数与负系数总和。采用 $\theta^+$ 与 $\theta^-$ 修正后限制值为

$$\hat{\Delta}_i = \theta^+ \text{max} \left(0, \Delta_i\right) - \theta^- \text{max} \left(0, -\Delta_i\right)$$

此时满足 $\sum_{i=1}^3 \hat{\Delta}_i = 0$，根据 $\hat{\Delta}_i$ 进行重构便可得到限制后的解。

## 扩展至四边形单元

在四边形单元中计算时，大部分过程都与三角形单元相同，唯一区别是确定如何由四个边上的限制后的 $\hat{\Delta}_i$ 获得单元内分布解。这里我们采用一种简单方法，首先利用Green-Gauss公式计算出单元内近似斜率 $\frac{\partial u}{\partial x}$ 与 $\frac{\partial u}{\partial y}$，随后根据此斜率与均值便可获得单元内限制后的解。

其中斜率的近似公式采用下式计算

$$\begin{array}{ll}
\frac{\partial u}{\partial x} = \frac{1}{A}\int_{\Omega_A}\frac{\partial u}{\partial x} \mathrm{dA} = \frac{1}{A}\oint_{\partial \Omega_A} \hat{u} \mathrm{dy} = \sum_{i=1}^{Nfaces} \hat{u}_i \Delta y_i \cr
\frac{\partial u}{\partial y} = \frac{1}{A}\int_{\Omega_A}\frac{\partial u}{\partial y} \mathrm{dA} =\frac{1}{A}\oint_{\partial \Omega_A} -\hat{u} \mathrm{dx} = \sum_{i=1}^{Nfaces} - \hat{u}_i \Delta x_i
\end{array}$$

## 代码

源程序文件为`/assemble/Slope_limiters_DG.F90`。

```
subroutine cockburn_shu_setup_ele(ele, T, X)
integer, intent(in) :: ele
type(scalar_field), intent(inout) :: T
type(vector_field), intent(in) :: X

integer, dimension(:), pointer :: neigh, x_neigh
real, dimension(X%dim) :: ele_centre, face_2_centre
real :: max_alpha, min_alpha, neg_alpha
integer :: ele_2, ni, nj, face, face_2, i, nk, ni_skip, info, nl
real, dimension(X%dim, ele_loc(X,ele)) :: X_val, X_val_2
real, dimension(X%dim, ele_face_count(T,ele)) :: neigh_centre,&
     & face_centre
real, dimension(X%dim) :: alpha1, alpha2
real, dimension(X%dim,X%dim) :: alphamat
real, dimension(X%dim,X%dim+1) :: dx_f, dx_c
integer, dimension(mesh_dim(T)) :: face_nodes

X_val=ele_val(X, ele)

ele_centre=sum(X_val,2)/size(X_val,2)

neigh=>ele_neigh(T, ele)
! x_neigh/=t_neigh only on periodic boundaries.
x_neigh=>ele_neigh(X, ele)

searchloop: do ni=1,size(neigh)

   !----------------------------------------------------------------------
   ! Find the relevant faces.
   !----------------------------------------------------------------------
   ele_2=neigh(ni)

   ! Note that although face is calculated on field U, it is in fact
   ! applicable to any field which shares the same mesh topology.
   face=ele_face(T, ele, ele_2)
   face_nodes=face_local_nodes(T, face)

   face_centre(:,ni) = sum(X_val(:,face_nodes),2)/size(face_nodes)

   if (ele_2<=0) then
      ! External face.
      neigh_centre(:,ni)=face_centre(:,ni)
      cycle
   end if

   X_val_2=ele_val(X, ele_2)

   neigh_centre(:,ni)=sum(X_val_2,2)/size(X_val_2,2)
   if (ele_2/=x_neigh(ni)) then
      ! Periodic boundary case. We have to cook up the coordinate by
      ! adding vectors to the face from each side.
      face_2=ele_face(T, ele_2, ele)
      face_2_centre = &
           sum(face_val(X,face_2),2)/size(face_val(X,face_2),2)
      neigh_centre(:,ni)=face_centre(:,ni) + &
           (neigh_centre(:,ni) - face_2_centre)
   end if

end do searchloop

do ni = 1, size(neigh)
   dx_c(:,ni)=neigh_centre(:,ni)-ele_centre !Vectors from ni centres to
   !                                         !ele centre
   dx_f(:,ni)=face_centre(:,ni)-ele_centre !Vectors from ni face centres
                                          !to ele centre
end do

alpha_construction_loop: do ni = 1, size(neigh)
   !Loop for constructing Delta v(m_i,K_0) as described in C&S
   alphamat(:,1) = dx_c(:,ni)

   max_alpha = -1.0
   ni_skip = 0

   choosing_best_other_face_loop: do nj = 1, size(neigh)
      !Loop over the other faces to choose best one to use
      !for linear basis across face

      if(nj==ni) cycle

      !Construct a linear basis using all faces except for nj
      nl = 1
      do nk = 1, size(neigh)
         if(nk==nj.or.nk==ni) cycle
         nl = nl + 1
         alphamat(:,nl) = dx_c(:,nk)
      end do

      !Solve for basis coefficients alpha
      alpha2 = dx_f(:,ni)
      call solve(alphamat,alpha2,info)

      if((.not.any(alpha2<0.0)).and.alpha2(1)/norm2(alpha2)>max_alpha) &
           & then
         alpha1 = alpha2
         ni_skip = nj
         max_alpha = alpha2(1)/norm2(alpha2)
      end if

   end do choosing_best_other_face_loop

   if(max_alpha<0.0) then
      if(tolerate_negative_weights) then
         min_alpha = huge(0.0)
         ni_skip = 0
         choosing_best_other_face_neg_weights_loop: do nj = 1, size(neigh)
            !Loop over the other faces to choose best one to use
            !for linear basis across face

            if(nj==ni) cycle

            !Construct a linear basis using all faces except for nj
            nl = 1
            do nk = 1, size(neigh)
               if(nk==nj.or.nk==ni) cycle
               nl = nl + 1
               alphamat(:,nl) = dx_c(:,nk)
            end do

            !Solve for basis coefficients alpha
            alpha2 = dx_f(:,ni)
            call solve(alphamat,alpha2,info)

            neg_alpha = 0.0
            do i = 1, size(alpha2)
               if(alpha2(i)<0.0) then
                  neg_alpha = neg_alpha + alpha2(i)**2
               end if
            end do
            neg_alpha = sqrt(neg_alpha)

            if(min_alpha>neg_alpha) then
               alpha1 = alpha2
               ni_skip = nj
               min_alpha = neg_alpha
            end if
         end do choosing_best_other_face_neg_weights_loop
      else
         FLAbort('solving for alpha failed')
      end if
   end if

   alpha(ele,ni,:) = 0.0
   alpha(ele,ni,ni) = alpha1(1)
   nl = 1
   do nj = 1, size(neigh)
      if(nj==ni.or.nj==ni_skip) cycle
      nl = nl + 1
      alpha(ele,ni,nj) = alpha1(nl)
   end do

   dx2(ele,ni) = norm2(dx_c(:,ni))

end do alpha_construction_loop

end subroutine cockburn_shu_setup_ele
```

```
subroutine limit_slope_ele_cockburn_shu(ele, T, X)
!!< Slope limiter according to Cockburn and Shu (2001)
!!< http://dx.doi.org/10.1023/A:1012873910884
integer, intent(in) :: ele
type(scalar_field), intent(inout) :: T
type(vector_field), intent(in) :: X

integer, dimension(:), pointer :: neigh, x_neigh, T_ele
real :: ele_mean
real :: pos, neg
integer :: ele_2, ni, face
real, dimension(ele_loc(T,ele)) :: T_val, T_val_2
real, dimension(ele_face_count(T,ele)) :: neigh_mean, face_mean
real, dimension(mesh_dim(T)+1) :: delta_v
real, dimension(mesh_dim(T)+1) :: Delta, new_val
integer, dimension(mesh_dim(T)) :: face_nodes

T_val=ele_val(T, ele)

ele_mean=sum(T_val)/size(T_val)

neigh=>ele_neigh(T, ele)
! x_neigh/=t_neigh only on periodic boundaries.
x_neigh=>ele_neigh(X, ele)

searchloop: do ni=1,size(neigh)

   !----------------------------------------------------------------------
   ! Find the relevant faces.
   !----------------------------------------------------------------------
   ele_2=neigh(ni)

   ! Note that although face is calculated on field U, it is in fact
   ! applicable to any field which shares the same mesh topology.
   face=ele_face(T, ele, ele_2)
   face_nodes=face_local_nodes(T, face)

   face_mean(ni) = sum(T_val(face_nodes))/size(face_nodes)

   if (ele_2<=0) then
      ! External face.
      neigh_mean(ni)=face_mean(ni)
      cycle
   end if

   T_val_2=ele_val(T, ele_2)

   neigh_mean(ni)=sum(T_val_2)/size(T_val_2)

end do searchloop

delta_v = matmul(alpha(ele,:,:),neigh_mean-ele_mean)

delta_loop: do ni=1,size(neigh)

   Delta(ni)=TVB_minmod(face_mean(ni)-ele_mean, &
        Limit_factor*delta_v(ni), dx2(ele,ni))

end do delta_loop

if (abs(sum(Delta))>1000.0*epsilon(0.0)) then
   ! Coefficients do not sum to 0.0

   pos=sum(max(0.0, Delta))
   neg=sum(max(0.0, -Delta))

   Delta = min(1.0,neg/pos)*max(0.0,Delta) &
        -min(1.0,pos/neg)*max(0.0,-Delta)

end if

new_val=matmul(A,Delta+ele_mean)

! Success or non-boundary failure.
T_ele=>ele_nodes(T,ele)

call set(T, T_ele, new_val)

end subroutine limit_slope_ele_cockburn_shu
```

---
[1]	COCKBURN B, SHU C-W. TVB Runge-Kutta local projection discontinuous Galerkin finite element method for conservation laws. II. General framework[J]. Mathematics of Computation, 1989, 52(186): 411–411.

[2]	COCKBURN B, SHU C-W. The Runge-Kutta discontinuous Galerkin method for conservation laws. V. Multidimensional systems[J]. Journal of Computational Physics, 1998, 141(2): 199–224.
