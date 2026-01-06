!######################
!  programm to remap the RF99 reference data from the 5°grid to the model grid T31
!  and to split the evergreen/deciduous mixed forestinto boreal (GDD5<900°C) and temperate forest (GDD5 > 900°C),
!  and to merge the temperate Savanna (Tcold < 10°C) with the temperate forest
! 
!  programm is called by the shell script prepare_RF_map.ksh
!#######################
program remap
  implicit none

  real :: BIOME_RF(4320,2160)  ! original biome distribution by RF99 on a 5°grid, 4320x2160 grid-cells (input file)
  real :: BIOME_N(96,48)       ! remapped biome distribution in T31 (96x48 grid-cells)  (output file)
  real :: GDD(4320,2160)       ! binary map for the GDD5-limit (GDD5>900°C -> 1, GDD5<900°C -> 0 )
  real :: Tcold(4320,2160)     ! binary map for the Tcold-limit (Tcold > 10°C -> 1, Tcold < 10°C -> 0 )
  integer :: i, j, k, l, m, n
  integer :: coun(10)=0, t     ! used to count for each model grid-cell the number of grid-cells of RF99 covered by a certain biome

open (10,file='potveg_10.txt',form='formatted',position='rewind')   ! RF99 biome input, 10 mega-biomes (input file)
open (9, file='potveg_t31.txt')                                     ! T31 biome output (output file)
open (11, file='GDD900.txt')                                        ! GDD5 binary map  (input file)  
open (12, file='potveg_9.txt')                                      ! RF99 biome, grouped into the 9 mega-biomes (output file)
open (13, file='Tcold.txt')                                         ! mean temperature of the coldest month binay map (input file)

!read input data 

   do j = 1,2160
      read(10,'(4320f5.1)')(BIOME_RF(i,j),i=1,4320)
      read(11,'(4320f5.1)')(GDD(i,j),i=1,4320)
      read(13,'(4320f5.1)')(Tcold(i,j),i=1,4320)
   end do

!split the evergreen/deciduous mixed forest into temperate forest (biome no.3) and into boreal forest (biome no.4) via the GDD5-limit
do j = 1,2160
   do i = 1,4320
      if ((BIOME_RF(i,j) == 11.0) .and. (GDD(i,j) == 1.0)) then
         BIOME_RF(i,j) = 3.0
      else if ((BIOME_RF(i,j) == 11.0) .and.  (GDD(i,j) == 0.0)) then
         BIOME_RF(i,j) = 4.0
      end if
   end do
end do

!merge the temperate savanna included in RF99 with the temperate forest (biome no.3) via the Tcold-limit
do j = 1,2160
   do i = 1,4320
      if ((BIOME_RF(i,j) == 5.0) .and. (Tcold(i,j) == 0.0)) then
         BIOME_RF(i,j) = 3.0
      end if
   end do
end do

! set all water grid-cells to the value 10.0, to be considered in the counting loop.
do j = 1,2160
   do i = 1,4320
      if ((BIOME_RF(i,j) == 0.0)) then
         BIOME_RF(i,j) = 10.0
      end if
   end do
end do

! remapping from the RF99 grid to T31, the number of grid-cell in the 5°grid is a multiple of the number of grid-cells in T31, containing 45 x 45 grid cells,
do i = 1,48
   do j = 1,96
      coun = 0
      do k = 1,45
         do l = 1,45
            do m = 1,10
               if (BIOME_RF(((j-1)*45+l),((i-1)*45+k)) == REAL(m)) then
                  coun(m) = coun(m) + 1
               end if
            end do
         end do
      end do
       t = maxloc(coun, DIM=1)

       ! The Biomes in the T31 grid-cells are set to the dominant biome (biome no.t) in the RF99 grid-cells that are located in the coarser T31 grid-cells
       BIOME_N(j,i) = REAL(t)
   end do
end do

! ######## end of remapping #######################################

! the grid cells covered by water are set back to the value 0.0
do j = 1,48
   do i = 1,96
      if ((BIOME_N(i,j) == 10.0)) then
         BIOME_N(i,j) = 0.0
      end if
   end do
end do

! write output files
do i = 1,48
   write(9,'(96(f5.1,1x))')(BIOME_N(j,i),j=1,96)
end do
do i = 1,2160
   write(12,'(4320(f5.1,1x))')(BIOME_RF(j,i),j=1,4320)
end do

end program remap

!

         
                             
                                   
                      
      
