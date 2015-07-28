!----------------------------------------------------------------------------------------------------------------------------------
! SPHERA (Smoothed Particle Hydrodynamics research software; mesh-less Computational Fluid Dynamics code).
! Copyright 2005-2015 (RSE SpA -formerly ERSE SpA, formerly CESI RICERCA, formerly CESI-; SPHERA has been authored for RSE SpA by 
!    Andrea Amicarelli, Antonio Di Monaco, Sauro Manenti, Elia Bon, Daria Gatti, Giordano Agate, Stefano Falappi, 
!    Barbara Flamini, Roberto Guandalini, David Zuccalà).
! Main numerical developments of SPHERA: 
!    Amicarelli et al. (2015,CAF), Amicarelli et al. (2013,IJNME), Manenti et al. (2012,JHE), Di Monaco et al. (2011,EACFM). 
! Email contact: andrea.amicarelli@rse-web.it

! This file is part of SPHERA.
! SPHERA is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! SPHERA is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
! You should have received a copy of the GNU General Public License
! along with SPHERA. If not, see <http://www.gnu.org/licenses/>.
!----------------------------------------------------------------------------------------------------------------------------------

!----------------------------------------------------------------------------------------------------------------------------------
! Program unit: viscomorris
! Description: 
!----------------------------------------------------------------------------------------------------------------------------------

subroutine viscomorris(npi,npj,npartint,dervel,rvw)
!------------------------
! Modules
!------------------------ 
use Static_allocation_module
use Hybrid_allocation_module
use Dynamic_allocation_module
!------------------------
! Declarations
!------------------------
implicit none
integer(4), intent(IN) :: npi,npj,npartint
double precision,intent(IN) :: dervel(3)
double precision,intent(OUT) :: rvw(3)
double precision :: amassj,rhotilde,anuitilde,factivis
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
!------------------------
! Statements
!------------------------
if (pg(npj)%vel_type/="std") then 
   amassj = pg(npi)%mass
   rhotilde = pg(npi)%dens
   anuitilde = two * pg(npi)%visc
   else
      amassj = pg(npj)%mass
      rhotilde  = (pg(npi)%visc * pg(npi)%dens + pg(npj)%visc * pg(npj)%dens   &
                  + 0.001d0)
! Kinematic viscosity 
      anuitilde = 4.0d0 * (pg(npi)%visc * pg(npj)%visc)      
end if
factivis = amassj * anuitilde / rhotilde
rvw(1:3) = factivis * ( - dervel(1:3) * PartKernel(2,npartint) *               &
           (rag(1,npartint) * rag(1,npartint) + rag(2,npartint) *              &
           rag(2,npartint) + rag(3,npartint) * rag(3,npartint)))
!------------------------
! Deallocations
!------------------------
return
end subroutine viscomorris
