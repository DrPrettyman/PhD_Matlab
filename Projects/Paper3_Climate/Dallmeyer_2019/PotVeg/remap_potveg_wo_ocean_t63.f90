!######################
!  programm to remap the RF99 reference data from the 5min-grid to the model grid T63
!  and to split the evergreen/deciduous mixed forestinto boreal (GDD5<900°C) and temperate forest (GDD5 > 900°C),
!  and to merge the temperate Savanna (Tcold < 10°C) with the temperate forest
! 
!  programm is called by the shell script prepare_RF_map.ksh
!#######################

program remap
  implicit none

  real :: BIOME_RF(4320,2160)    ! original biome distribution by RF99 on a 5min-grid, 4320x2160 grid-cells (input file)
  real :: BIOME_N(192,96)        ! remapped biome distribution in T63 (192x96 grid-cells)  (output file)
  real :: GDD(4320,2160)         ! binary map for the GDD5-limit (GDD5>900°C -> 1, GDD5<900°C -> 0 )
  real :: Tcold(4320,2160)       ! binary map for the Tcold-limit (Tcold > 10°C -> 1, Tcold < 10°C -> 0 ) 
  integer :: i, j, k, l, m, n, a, b, c, d, v, w
  integer :: coun(10)=0, coun2(10)=0, s, r, t, u, coun3(10), coun4(10)  ! used to count for each model grid-cell the number of grid-cells of RF99 covered by a certain biome

!open the input and output files
open (10,file='potveg_10.txt',form='formatted',position='rewind')   ! RF99 biome input, 10 mega-biomes (input file)
open (9, file='potveg_t63.txt')                                     ! T63 biome output (output file)    
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

! remapping from the RF99 grid to T63, the number of grid-cell in the 5min-grid is not a multiple of the number of grid-cells in T63
! (one T63 grid box contains 22.5 x 22.5 grid-cells), therefore, we let the grid-cells partly overlap, please see the Appendix of the manuscript for details.
do i = 1,96,2
   do j = 1,192,2
      coun = 0
      coun2 = 0
      coun3 = 0
      coun4 = 0
      do k = 1,23
         do l = 1,23
            a = INT(((j-1.)*22.5+l))
            b = INT(((i-1.)*22.5+k))
            c = INT((j*22.5)+(l-0.5))
            d = INT((i*22.5)+(k-0.5))
          
            do m = 1,10
               if (BIOME_RF(a,b) == REAL(m)) then
                  coun(m) = coun(m) + 1
               end if
               
               if (BIOME_RF(c,b) == REAL(m)) then   
                  coun2(m) = coun2(m) + 1
               end if
               if (BIOME_RF(a,d) == REAL(m)) then
                  coun3(m) = coun3(m) + 1
               end if
               if (BIOME_RF(c,d) == REAL(m)) then
                  coun4(m) = coun4(m) + 1
               end if
               
            end do
         end do
      end do
      
      t = maxloc(coun, DIM=1)
      u = maxloc(coun2, DIM=1)
      s = maxloc(coun3, DIM=1)
      r = maxloc(coun4, DIM=1)

! The Biomes in the T63 grid-cells are set to the dominant biome in the RF99 grid-cells that are located in the coarser T63 grid-cells
      BIOME_N(j,i) = REAL(t)
      BIOME_N(j+1,i) = REAL(u)
      BIOME_N(j,i+1) = REAL(s)
      BIOME_N(j+1,i+1) = REAL(r)
      
   end do
end do
! ######## end of remapping #######################################


! the grid cells covered by water are set back to the value 0.0
do j = 1,96
   do i = 1,192
      if ((BIOME_N(i,j) == 10.0)) then
         BIOME_N(i,j) = 0.0
      end if
   end do
end do

! write output files
do i = 1,96
   write(9,'(192(f5.1,1x))')(BIOME_N(j,i),j=1,192)     ! potveg_t63.txt (remapped to T63 grid)
end do
do i = 1,2160
   write(12,'(4320(f5.1,1x))')(BIOME_RF(j,i),j=1,4320)  ! potveg_9.txt (on the RF99 grid, with only 9 Mega-biomes)
end do

end program remap



         
                             
                                   
                      
      
