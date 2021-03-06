!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!                                                                   !!
!!                   GNU General Public License                      !!
!!                                                                   !!
!! This file is part of the Flexible Modeling System (FMS).          !!
!!                                                                   !!
!! FMS is free software; you can redistribute it and/or modify       !!
!! it and are expected to follow the terms of the GNU General Public !!
!! License as published by the Free Software Foundation.             !!
!!                                                                   !!
!! FMS is distributed in the hope that it will be useful,            !!
!! but WITHOUT ANY WARRANTY; without even the implied warranty of    !!
!! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the     !!
!! GNU General Public License for more details.                      !!
!!                                                                   !!
!! You should have received a copy of the GNU General Public License !!
!! along with FMS; if not, write to:                                 !!
!!          Free Software Foundation, Inc.                           !!
!!          59 Temple Place, Suite 330                               !!
!!          Boston, MA  02111-1307  USA                              !!
!! or see:                                                           !!
!!          http://www.gnu.org/licenses/gpl.txt                      !!
!!                                                                   !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!$Id: convert_fluxes.F90,v 1.1.2.1 2007/09/11 13:01:46 smg Exp $
#include"cppdefs.h"
!-----------------------------------------------------------------------
!BOP
! !ROUTINE: Convert between buoyancy fluxes and others \label{sec:convertFluxes}
!
! !INTERFACE:
  subroutine  convert_fluxes(nlev,g,cp,rho_0,heat,p_e,rad,T,S,           &
                            tFlux,sFlux,btFlux,bsFlux,tRad,bRad)
!
! !DESCRIPTION:
!  This subroutine computes the buoyancy fluxes that are due
!  to
!  \begin{enumerate}
!    \item the surface heat flux,
!    \item the surface salinity flux caused by the value of
!          P-E (precipitation-evaporation),
!    \item and the short wave radiative flux.
!  \end{enumerate}
!  Additionally, it outputs the temperature flux ({\tt tFlux})
!  corresponding to the surface heat flux, the salinity flux
!  ({\tt sFlux})  corresponding to the value P-E, and the profile
!  of the temperature flux ({\tt tRad}) corresponding to the profile
!  of the radiative heat flux.
!
! This function is only called when the KPP turbulence model is used.
! When you call the KPP routines from another model outside GOTM, you
! are on your own in computing the  fluxes required by the KPP model, because
! they have to be consistent with the equation of state used in your model.
!
! !USES:
  use eqstate
  IMPLICIT NONE
!
! !INPUT PARAMETERS:
  integer,  intent(in)                :: nlev
  REALTYPE, intent(in)                :: g,cp,rho_0
  REALTYPE, intent(in)                :: heat,p_e
  REALTYPE, intent(in)                :: rad(0:nlev)
  REALTYPE, intent(in)                :: T(0:nlev)
  REALTYPE, intent(in)                :: S(0:nlev)
!
! !OUTPUT PARAMETERS:
  REALTYPE, intent(out)              ::  tFlux,sFlux
  REALTYPE, intent(out)               :: btFlux,bsFlux
  REALTYPE, intent(out)               :: tRad(0:nlev)
  REALTYPE, intent(out)               :: bRad(0:nlev)
!
! !REVISION HISTORY:
!  Original author(s): Lars Umlauf
!  $Log: convert_fluxes.F90,v $
!  Revision 1.1.2.1  2007/09/11 13:01:46  smg
!  Add these files to the mom4p1 branch.
!  AUTHOR:Griffies
!  REVIEWERS:
!  TEST STATUS:
!  CHANGES PUBLIC INTERFACES?
!  CHANGES ANSWERS?
!
!  Revision 1.2  2005-08-11 12:34:32  lars
!  corrected indentation for Protex
!
!  Revision 1.1  2005/06/27 10:54:33  kbk
!  new files needed
!
!
!EOP
!
! !LOCAL VARIABLES:
   integer                   :: i
   REALTYPE                  :: alpha,beta
!
!-----------------------------------------------------------------------
!BOC

   alpha   = eos_alpha(S(nlev),T(nlev),_ZERO_,g,rho_0)
   beta    = eos_beta (S(nlev),T(nlev),_ZERO_,g,rho_0)


   tFlux   =  heat/(rho_0*cp)
   btFlux  =  g*alpha*tFlux

   sFlux   =  -S(nlev)*p_e
   bsFlux  =  -g*beta*sFlux

   alpha   = eos_alpha(S(1),T(1),_ZERO_,g,rho_0)
   tRad(0) = rad(0)/(rho_0*cp)
   bRad(0) = g*alpha*tRad(0)

   do i=1,nlev
      alpha   = eos_alpha(S(i),T(i),_ZERO_,g,rho_0)
      tRad(i) = rad(i)/(rho_0*cp)
      bRad(i) = g*alpha*tRad(i)
   enddo

   return
   end subroutine convert_fluxes
!EOC

!-----------------------------------------------------------------------
! Copyright by the GOTM-team under the GNU Public License - www.gnu.org
!-----------------------------------------------------------------------
