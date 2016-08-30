#[Kubatko_2006] hp Discontinuous Galerkin methods for advection dominated problems in shallow water flow


###3.6. Boundary conditions

陆边界采用无通量条件，法向流量相反，切向流量与水位采用无梯度边界条件
$$Q_n^{(ex)} = -Q_n^{(in)} \quad Q_r^{(ex)} = Q_t^{(in)} \quad \zeta^{(ex)} = \zeta^{(in)}$$
开边界条件指定水位或流量，对应的另一变量采用无梯度边界条件
$$\zeta^{(ex)} = \zeta^{b.c} \quad \mathbf{Q^{(ex)} = Q^{(in)}}$$
$$\mathbf{Q^{(ex)} = Q^{b.c}} \quad \zeta^{(ex)} = \zeta^{(in)}$$
