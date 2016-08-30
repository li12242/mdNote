!=============================
! Exercise 8: Free convection
!=============================
! Author: J. Kaempf, August 2009 

PROGRAM slice

USE param
USE sub

! local parameters
INTEGER :: ntot, nout

!**********
CALL INIT  ! initialisation
!**********

! runtime
ntot = INT(6.*3600./dt)
time = 0.0

! output frequency
nout = INT(5.*60./dt)

! open files for ouput
OPEN(10,file ='q.dat',form='formatted')
OPEN(20,file ='u.dat',form='formatted')
OPEN(30,file ='w.dat',form='formatted')
OPEN(40,file ='eta.dat',form='formatted')
OPEN(50,file ='rho.dat',form='formatted')
OPEN(60,file ='c.dat',form='formatted')

!---------------------------
! simulation loop
!---------------------------
DO n = 1,ntot

time = time + dt
write(6,*)"time (hours)", time/(3600.)

! prognostic equations
CALL dyn

! data output
IF(MOD(n,nout)==0)THEN
  DO i = 1,nz
    WRITE(10,'(201F12.6)')(q(i,k)/(RHOREF*G),k=1,nx)
    WRITE(20,'(201F12.6)')(u(i,k),k=1,nx)
    WRITE(30,'(201F12.6)')(w(i,k),k=1,nx)
    WRITE(50,'(201F12.6)')(rho(i,k),k=1,nx)
    WRITE(60,'(201F12.6)')(c(i,k),k=1,nx)
  END DO
  WRITE(40,'(201F12.6)')(q(0,k)/(RHOREF*G),k=1,nx)
  WRITE(6,*)"Data output at time = ",time/(24.*3600.)
ENDIF
!ENDIF

END DO ! end of iteration loop

END PROGRAM slice
