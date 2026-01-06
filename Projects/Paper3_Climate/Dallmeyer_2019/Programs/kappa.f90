program kappa
! calculates the kappa metric and a weighted kappa metric,
! as input text-files containing the reference (BIOME_RF) and the pft-based or climate-based biome distribution (BIOME4) are needed.
! output: ${model}_${simid}_${timid}_kappa_pft.txt (detailed metric, kappa and weighted kappa)
!         ${model}_${simid}_${timid}_kappa_p.txt (list of all kappa per mega-biome (1-9) and in total (10)
  
  implicit none

  real, ALLOCATABLE, DIMENSION(:,:) :: BIOME_RF, BIOME4, COUNTM, LANDM
  integer :: i, j, m, n
  real :: ERR(9,9)=0.
  integer :: nx, ny
  character(len=:), ALLOCATABLE :: cformat   
  character(len=15) :: buffer  
  real :: P0, PE, KAPPAH, LAND, GOOD
  real :: ERR_DIA(9), ERR_ROW(9), ERR_COL(9), PEM(9), GOOD_BIO(9), KAPPAH_BIO(9)
  real :: WEIGHTS(9,9), ERRWEI(9,9), ERR_DIA_W(9), ERR_ROW_W(9), ERR_COL_W(9), PEM_W(9)
  real :: P0W, PEW, KAPPAHW, GOOD_W, GOOD_BIO_W(9)
  
!  files 
   character(LEN=60)  :: INFILE,REFILE,OFILE,OFILE_K, MODEL

   READ (*,*) INFILE                      ! PFT- or climate-based Biome distribution 
   READ (*,*) REFILE                      ! reference biome distribution
   READ (*,*) OFILE                       ! ${model}_${simid}_${timid}_kappa_pft.txt 
   READ (*,*) OFILE_K                     ! ${model}_${simid}_${timid}_kappa.txt
   READ (*,*) MODEL 
   READ (*,*) nx,ny                       ! grid-resolution (e.g. T31: 96 x 48)

WRITE(buffer,'(A1,I0,A5)') '(',nx,'f5.1)'
cformat = TRIM(buffer)

open (10, file=REFILE,form='formatted',position='rewind')
open (11, file=INFILE)
open (22, file=OFILE)
open (23, file=OFILE_K)

! allocate  matrices
ALLOCATE (BIOME_RF(nx,ny))
ALLOCATE (BIOME4(nx,ny))
ALLOCATE (COUNTM(nx,ny))
ALLOCATE (LANDM(nx,ny))

!read input data 

do j = 1,ny
      read(10,cformat)(BIOME_RF(i,j),i=1,nx)
      read(11,cformat)(BIOME4(i,j),i=1,nx)
end do

!+++++++++++++ calculating the numbers of land grid-cells
   where (BIOME_RF > 0.5)
      LANDM = 1.
   elsewhere
      LANDM = 0.
   end where

   LAND = SUM(LANDM)
!+++++++++++++++++++++++ error matrix   
   do m = 1,9
      COUNTM = 0.
      do n = 1,9
        
         where ( BIOME_RF == REAL(m) .and. BIOME4 == REAL(n) )
            COUNTM = 1.
         elsewhere
            COUNTM = 0.
         end where
         
         ERR(m,n) = SUM (COUNTM)
      end do
   end do


!*********************************************************
 ! kappa
 
 do i= 1,9
   ERR_DIA(i)=ERR(i,i)
   ERR_ROW(i)=SUM(ERR(i,:))
   ERR_COL(i)=SUM(ERR(:,i))
   PEM(i)= (ERR_ROW(i)*ERR_COL(i))/(LAND*LAND)
end do


P0=(SUM(ERR_DIA))/LAND
PE=SUM(PEM)
KAPPAH=(P0 - PE)/(1.-PE)

!+++++++ kappa for the ind. biomes
do i = 1,9
KAPPAH_BIO(i) = ((ERR_DIA(i)-PEM(i))/(((ERR_ROW(i)+ERR_COL(i))/2)-PEM(i)))
end do

!++++++++++++++++++++++++++++++++++++++++++++++
! percent of total agreement
GOOD = P0 
!  percent of biome agreement
GOOD_BIO = ERR_DIA / ERR_ROW


!++++++++++++++++++++++++ weighted kappa
WEIGHTS(1,:) = (/1., 1., 1., 1., 2., 3., 4., 3., 4./)
WEIGHTS(2,:) = (/1., 1., 1., 1., 2., 3., 4., 3., 4./)
WEIGHTS(3,:) = (/1., 1., 1., 1., 2., 3., 4., 3., 4./)
WEIGHTS(4,:) = (/1., 1., 1., 1., 2., 3., 4., 3., 4./)
WEIGHTS(5,:) = (/2., 2., 2., 2., 1., 2., 3., 2., 3./)
WEIGHTS(6,:) = (/3., 3., 3., 3., 2., 1., 2., 2., 2./)
WEIGHTS(7,:) = (/4., 4., 4., 4., 3., 2., 1., 2., 1./)
WEIGHTS(8,:) = (/3., 3., 3., 3., 2., 2., 2., 1., 2./)
WEIGHTS(9,:) = (/4., 4., 4., 4., 3., 2., 1., 2., 1./)

do i=1,9
   do j=1,9
      ERRWEI(i,j) = ERR(i,j) * WEIGHTS(i,j)
   end do
end do
do i= 1,9
   ERR_DIA_W(i)=ERRWEI(i,i)
   ERR_ROW_W(i)=SUM(ERRWEI(i,:))
   ERR_COL_W(i)=SUM(ERRWEI(:,i))
end do
do i=1,9
   PEM_W(i)= (ERR_ROW_W(i)/SUM(ERR_ROW_W))*(ERR_COL_W(i)/SUM(ERR_COL_W))
end do

P0W=(SUM(ERR_DIA_W))/SUM(ERR_COL_W)
PEW=SUM(PEM_W)
KAPPAHW=(P0W - PEW)/(1.-PEW)

! percent of total agreement (weighted kappa)
GOOD_W = P0W 

!  percent of biome agreement (weighted kappa)
GOOD_BIO_W = ERR_DIA_W / ERR_ROW_W


!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!output
write (22,*) 'REF vs. ', MODEL
write (22,*) ' '
write (22,*) 'Biomes'
write (22,*) '1 tropical forest'
write (22,*) '2 warm mixed forest'
write (22,*) '3 temperate forest'
write (22,*) '4 boreal forest'
write (22,*) '5 Savanna'
write (22,*) '6 Grassland'
write (22,*) '7 Desert'
write (22,*) '8 Tundra'
write (22,*) '9 pol.desert'
write (22,*) ' '
write (22,*) 'ERROR MATRIX:'
do n = 1,9
   write(22,'(9(f8.1,1x))')(ERR(n,m),m=1,9)
end do
write (22,*) ' '
write (22,*) 'sum of Grid boxes indiv.biomes REF:'
write (22,*) ERR_ROW
write (22,*) ' '
write (22,*) 'sum of Grid boxes indiv. biomes ', MODEL, ': '
write (22,*) ERR_COL
write (22,*) ' '
write (22,*) 'agreement for indiv. biomes (%): '
write (22,*) GOOD_BIO
write (22,*) ' '
write (22,*) 'equal grid boxes: ', P0*LAND, 'total number of grid boxes:', LAND, 'Agreement (%): ', GOOD
write (22,*) ' '
write (22,*) 'Kappa:'
write (22,*) KAPPAH
write (22,*) ' '
write (22,*) 'ind. Kappa:'
write (22,*) KAPPAH_BIO
write (22,*) ' '
write (22,*) 'weighted kappa:', KAPPAHW, 'Agreement score:', GOOD_W
write (22,*) 'agreement individual biomes (%)'
write (22,*) GOOD_BIO_W

do n = 1,9
   write(23,'((f8.3))')(KAPPAH_BIO(n))
end do
write (23,'(f8.3)') KAPPAH


write (*,*) '###############################################################'
write (*,*) 'Kappa: ', KAPPAH
write (*,*) 'weighted Kappa: ', KAPPAHW
write (*,*) 'Agreement score:', GOOD_W
write (*,*) '###############################################################'



end program kappa

!

         
                             
                                   
                      
      
