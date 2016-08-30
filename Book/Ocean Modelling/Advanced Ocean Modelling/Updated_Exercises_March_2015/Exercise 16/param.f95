MODULE param

INTEGER(4), PARAMETER :: nx = 101 ! horizontal dimension	
INTEGER(4), PARAMETER :: nz = 51 ! vertical dimension
REAL, PARAMETER :: G = 9.81 ! acceleration due to gravity
REAL, PARAMETER :: RHOREF = 1028.0 ! reference density

REAL, PARAMETER :: PI = 3.1416 ! pi

REAL :: dt, dx, dz
REAL :: drdz, drdx 
REAL :: ad
REAL :: kh, kz ! density diffusivities
REAL :: ah, az ! viscosities
REAL :: r ! bottom friction coefficient

INTEGER :: n,i,k, ist
REAL :: randm

REAL :: rho(0:nz+1,0:nx+1),rhon(0:nz+1,0:nx+1), rhozero(0:nz+1)
REAL :: p(0:nz+1,0:nx+1) ! hydrostatic pressure
REAL :: dq(0:nz+1,0:nx+1) ! pressure correction
REAL :: q(0:nz+1,0:nx+1) ! nonhydrostatic pressure
REAL :: u(0:nz+1,0:nx+1), un(0:nz+1,0:nx+1) 
REAL :: v(0:nz+1,0:nx+1), vn(0:nz+1,0:nx+1) 
REAL :: w(0:nz+1,0:nx+1), wn(0:nz+1,0:nx+1)  
REAL :: usum(0:nx+1) ! depth-integrated flow
LOGICAL :: wet(0:nz+1,0:nx+1) ! wet/dry pointer

! parameters for S.O.R iteration
REAL :: ustar(0:nz+1,0:nx+1), wstar(0:nz+1,0:nx+1), vstar(0:nz+1,0:nx+1), qstar(nz,nx)
REAL :: omega 
REAL :: at(nz,nx), ab(nz,nx), ae(nz,nx), aw(nz,nx)
REAL :: atot(nz,nx) 
REAL :: peps 

! parameters for Coriolis force
REAL :: f, alpha, beta

! arrays for advection subroutine
REAL :: CuP(0:nz+1,0:nx+1), CuN(0:nz+1,0:nx+1)
REAL :: CwP(0:nz+1,0:nx+1), CwN(0:nz+1,0:nx+1)
REAL :: B(0:nz+1,0:nx+1), BN(0:nz+1,0:nx+1)

END MODULE param