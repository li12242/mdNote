# TVB间断检测器

Qiu 和 Shu (2005)[^1] 文献中将TVB限制器作为间断检测器，然后和WENO重构格式一起使用：即当TVB限制器需要修改单元内梯度时，认为此单元为问题单元。

[^1]:	Qiu, J., Shu, C.-W.: Runge--Kutta Discontinuous Galerkin Method Using WENO Limiters. SIAM J. Sci. Comput. 26, 907–929 (2005).
