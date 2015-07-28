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
! Program unit: DefineBoundarySideRelativeAngles2D                                      
! Description: Detection of the previous adjacent side and associated relative angle (for each boundary side). 
!              (Di Monaco et al., 2011, EACFM)                        
!----------------------------------------------------------------------------------------------------------------------------------

subroutine DefineBoundarySideRelativeAngles2D
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
integer(4) :: nti,ntj,isi,jsi,ksi
double precision :: sinangle,cosangle
double precision,dimension(1:SPACEDIM,1:SPACEDIM) :: Tmx, PTmx
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
! Loop over all the domain boundary sides
do isi=1,NumBSides
   nti = BoundarySide(isi)%stretch
! .. skips the perimeter and pool types
   if ((Tratto(nti)%tipo/="peri").AND.(Tratto(nti)%tipo/="pool")) then
! .. loops on all the other sides
      ksi=0
      do jsi=1,NumBSides
         ntj = BoundarySide(jsi)%stretch
         if ((Tratto(ntj)%tipo=="peri").or.(Tratto(ntj)%tipo=="pool")) cycle
! To check if the sides are adjacents ("ksi" is the previous adjacent side)
         if (BoundarySide(jsi)%Vertex(2)==BoundarySide(isi)%Vertex(1)) then
            ksi = jsi                    
            exit
         endif
      enddo
      BoundarySide(isi)%angle = zero
! An adjacent side has been found
      if (ksi>0) then
! To compute the angle between the two sides (in radians)
         ntj = BoundarySide(ksi)%stretch
         if ((Tratto(ntj)%tipo/="peri").AND.(Tratto(ntj)%tipo/="pool")) then
            Tmx  = BoundarySide(isi)%T
            PTmx = BoundarySide(ksi)%T
            sinangle = PTmx(1,1) * Tmx(3,1) - PTmx(3,1) * Tmx(1,1)
            cosangle = PTmx(1,1) * Tmx(1,1) + PTmx(3,1) * Tmx(3,1)
            BoundarySide(isi)%angle = Atan2(sinangle, cosangle)
         endif
      endif
      BoundarySide(isi)%previous_side = ksi
   endif
enddo
!------------------------
! Deallocations
!------------------------
return
end subroutine DefineBoundarySideRelativeAngles2D
