!program for calculating end of African humid period
  !input: file containing annual mean (smoothed) bare soil fraction (i.e. slo0021_bsf_loess_smoothed70.nc)
  !       file containing the land-sea-mask (i.e. slm_NAF_neu.nc)
  ! compiled by: nagfor -o AHP_calc.x AHP_calculation.f90 -L/usr/lib -lnetcdff -lnetcdf
  ! output file:  slo0021_AHP_NAF_end_loess70.nc, containing the year of the AHP end (AHP_END), the year of the maximum and minimum bare soil fraction (T_MAX and T_MIN) and the bare soil fraction at the AHP end as difference to the 8k BSF (BSF_AHP)
  
   IMPLICIT NONE
   INCLUDE '/usr/include/netcdf.inc'
! error status return
   INTEGER  ::  IRET
! netCDF id
   INTEGER  ::  IDIN,IDRM,IDLSM,IDMO,IDOUT,IDP,IDMON
! dimensions
   INTEGER  ::  LONIN,LATIN,DIMIDIN
   INTEGER  ::  DIMIN,VARIN,ATTIN,LIMDIMIN
   
   INTEGER  ::  LONRM,LATRM,DIMIDRM
   INTEGER  ::  DIMRM,VARRM,ATTRM,LIMDIMRM

   INTEGER  ::  LONLSM,LATLSM,DIMIDLSM
   INTEGER  ::  DIMLSM,VARLSM,ATTLSM,LIMDIMLSM

   INTEGER  ::  LONP,LATP,DIMIDP
   INTEGER  ::  DIMP,VARP,ATTP,LIMDIMP
     
   INTEGER  ::  LONMO,LATMO,DIMIDMO
   INTEGER  ::  DIMMO,VARMO,ATTMO,LIMDIMMO
     

   INTEGER  ::  LONMON,LATMON,DIMIDMON
   INTEGER  ::  DIMMON,VARMON,ATTMON,LIMDIMMON
   
   
   INTEGER, ALLOCATABLE, DIMENSION(:)  ::  DIMLENIN,DIMLENRM,DIMLENLSM, DIMLENMO, DIMLENP, DIMLENMON
   CHARACTER(LEN=60), ALLOCATABLE, DIMENSION(:)  ::  DIMNAMIN,DIMNAMRM,DIMNAMLSM,DIMNAMMO,DIMNAMP,DIMNAMMON

! variables
   INTEGER  :: ININ(100),INRM(100),INLSM(100),INMO(100),INP(100),INMON(100)
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: VARTYPIN,VARTYPRM,VARTYPLSM,VARTYPMO,VARTYPP,VARTYPMON
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: VARDIMIN,VARDIMRM,VARDIMLSM,VARDIMMO,VARDIMP,VARDIMMON
   INTEGER, ALLOCATABLE, DIMENSION(:,:)  :: VARDIMIDIN,VARDIMIDRM,VARDIMIDLSM,VARDIMIDMO,VARDIMIDP, VARDIMIDMON
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: VARATTIN,VARATTRM,VARATTLSM,VARATTMO,VARATTP,VARATTMON
   CHARACTER(LEN=30), ALLOCATABLE, DIMENSION(:)  ::  VARNAMIN,VARNAMRM,VARNAMLSM,VARNAMMO,VARNAMP,VARNAMMON
   
! units   
  CHARACTER (LEN = *), PARAMETER :: UNITS = "units"
  CHARACTER (LEN = *), PARAMETER :: BARE_UNITS = "fraction per grid-box"
  CHARACTER (LEN = *), PARAMETER :: LAT_UNITS = "degrees_north"
  CHARACTER (LEN = *), PARAMETER :: LON_UNITS = "degrees_east"
  CHARACTER (LEN = *), PARAMETER :: TI_UNITS = "years"


!files 
   CHARACTER(LEN=60)  :: INFILE,RMFILE,OFILE,LSMFILE,MOFILE,PFILE,MONFILE

!variables for calculation

   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: BSF_RM         !INPUT smoothed bare soil fraction 
   REAL, ALLOCATABLE, DIMENSION(:,:) :: LSMASK           !Land Sea mask 
   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: D_BSF_RM       !Slope smoothed bare soil fraction
   REAL, ALLOCATABLE, DIMENSION (:,:) :: D_0K8K          !Slope 0k-8k
   REAL, ALLOCATABLE, DIMENSION (:,:) :: DT              !Slope D_TIME+1000yrs - D_TIME 
   REAL, ALLOCATABLE, DIMENSION (:,:) :: D_TIME          !timestep, where D_BSF exceeds D_0k8k, i.e. the AHP end
   REAL, ALLOCATABLE, DIMENSION (:,:) :: BSF_AHP         !bare soil fraction at the AHP end

   REAL, ALLOCATABLE, DIMENSION (:,:) :: T_MAX, T_MIN   !year of maximum and minimum bare soil fraction 
   REAL, ALLOCATABLE, DIMENSION (:,:) :: B_MAX, B_MIN    ! maximum, minimum bare soil fraction 
   
   ! OUTPUT IDs 
   INTEGER :: LONID,LATID,LOVARID,LAVARID
   INTEGER :: AHPID, MAXID, MINID, BSF_AHPID
   INTEGER :: DIMIDS(2)

   ! Dimensions of output file
   DOUBLE PRECISION, ALLOCATABLE, DIMENSION (:) ::  LATS, LONS, YEARS, TIMESRM
   DOUBLE PRECISION :: TI

!indices  
   INTEGER  :: LON, LAT, YEAR, T, I, II, J, K, NVAR_BSF, NVAR_BT,  NVAR_LO, NVAR_LA, NVAR_TI, NLAT, NLON, AYEARS, NYEARS, R_YEAR
   INTEGER  :: TISTAR, TISTARRM
   

RMFILE='slo0021_bsf_loess_smoothed70min8k.nc'
OFILE='slo0021_AHP_NAF_end_loess70.nc'
LSMFILE='slm_NAF_neu.nc'

! open the input-file
   WRITE (*,*) 'RMFILE: ',RMFILE
   IRET = nf_open(RMFILE,nf_nowrite,IDRM)
   CALL check_err(IRET)
! check what is in the input-file
   IRET = nf_inq(IDRM,DIMRM,VARRM,ATTRM,LIMDIMRM)
   CALL check_err(IRET)
   WRITE (*,*) 'DIMENSION,VARIABLES,ATTRIBUTES,LIMDIM',DIMRM,VARRM,ATTRM,LIMDIMRM

 !get  and check dimensions
  WRITE (*,*) 'Dimensions'
  ALLOCATE (DIMLENRM(DIMRM))
  ALLOCATE (DIMNAMRM(DIMRM))

  DO I=1,DIMRM
     CALL check_err( nf_inq_dim(IDRM,I,DIMNAMRM(I),DIMLENRM(I)) )
     WRITE (*,*) I,DIMNAMRM(I),DIMLENRM(I)
  END DO
 

! get variable names, types and shapes
   ALLOCATE (VARNAMRM(VARRM))
   ALLOCATE (VARTYPRM(VARRM))
   ALLOCATE (VARDIMRM(VARRM))
   ALLOCATE (VARDIMIDRM(VARRM,100))
   ALLOCATE (VARATTRM(VARRM))
   
   INRM(:) = 0
   DO I=1,VARRM
     IRET = nf_inq_var(IDRM,I,VARNAMRM(I),VARTYPRM(I),VARDIMRM(I),INRM,VARATTRM(I))
     CALL check_err(IRET)
     DO II=1,100
       VARDIMIDRM(I,II)=INRM(II)
    END DO

  WRITE (*,*) 'Variables / No. of dimensions' 
     WRITE (*,*) 'No.,NAME,TYP,DIM,VARDIMID,VARATTRIBUTES',I,VARNAMRM(I),VARTYPRM(I),VARDIMRM(I),VARDIMIDRM(I,1),VARATTRM(I)
  END DO
 
  ! get variables
  
   DO I =1,VARRM
      IF (VARNAMRM(I) == 'bsf_smoothed') THEN
      NVAR_BT=I
       ALLOCATE (BSF_RM(DIMLENRM(VARDIMIDRM(I,1)),DIMLENRM(VARDIMIDRM(I,2)),DIMLENRM(VARDIMIDRM(I,3))))
       CALL check_err( nf_get_var_real(IDRM,I,BSF_RM))
    ELSE IF (VARNAMRM(I) == 'lon') THEN
          NVAR_LO=I
          ALLOCATE (LONS(DIMLENRM(VARDIMIDRM(I,1))))
          CALL check_err( nf_get_var_double(IDRM,I,LONS) )
           WRITE (*,*) 'read lon'
        ELSE IF (VARNAMRM(I) == 'lat') THEN
          NVAR_LA=I
          ALLOCATE (LATS(DIMLENRM(VARDIMIDRM(I,1))))
          CALL check_err( nf_get_var_double(IDRM,I,LATS) )
           WRITE (*,*) 'read lat'
        ELSE IF (VARNAMRM(I) == 'time') THEN
          NVAR_TI=I
          ALLOCATE (TIMESRM(DIMLENRM(VARDIMIDRM(I,1))))
          CALL check_err( nf_get_var_double(IDRM,I,TIMESRM) )
         WRITE (*,*) 'read time'
         TISTARRM=(INT(TIMESRM(1)/10000.))
      ELSE IF (VARNAMRM(I) .NE. 'lon' .AND. VARNAMRM(I) .NE. 'lat' .AND. VARNAMRM(I) .NE. 'time') THEN 
         WRITE(*,*) 'ERROR: Variables not found' 
      END IF
      
   END DO
! close the input-file
   IRET = nf_close(IDRM)
   CALL check_err(IRET)
  
!#############################################
!Land-sea-mask,input
!-------------------------------------
 WRITE (*,*) 'Land-sea-mask: ', LSMFILE
 WRITE (*,*) '-----------------------------------'
 
 CALL check_err( nf_open(LSMFILE,nf_nowrite,IDLSM) )
 CALL check_err( nf_inq(IDLSM,DIMLSM,VARLSM,ATTLSM,LIMDIMLSM) )

  !get  and check dimensions
  WRITE (*,*) 'Dimensions'

  ALLOCATE (DIMLENLSM(DIMLSM))
  ALLOCATE (DIMNAMLSM(DIMLSM))

  DO I=1,DIMLSM
     CALL check_err( nf_inq_dim(IDLSM,I,DIMNAMLSM(I),DIMLENLSM(I)) )
     WRITE (*,*) I,DIMNAMLSM(I),DIMLENLSM(I)
     IF (DIMNAMLSM(I) == 'lon') THEN
        IF (DIMLENLSM(I) .NE. DIMLENRM(I)) THEN
           WRITE(*,*) 'ERROR: Climate variables and land-sea mask have different dimensions (lon)'
           stop
        END IF
     ELSE IF (DIMNAMLSM(I) == 'lat') THEN
        IF (DIMLENLSM(I) .NE. DIMLENRM(I)) THEN
           WRITE(*,*) 'ERROR: Climate variables and land-sea mask have different dimensions (lat)'
           stop
        END IF
     END IF
  END DO
 
! get variable names, types and shapes
   ALLOCATE (VARNAMLSM(VARLSM))
   ALLOCATE (VARTYPLSM(VARLSM))
   ALLOCATE (VARDIMLSM(VARLSM))
   ALLOCATE (VARDIMIDLSM(VARLSM,100))
   ALLOCATE (VARATTLSM(VARLSM))
   
   INLSM(:) = 0
   
   WRITE (*,*) 'Variables / No. of dimensions'

   DO I=1,VARLSM
     CALL check_err( nf_inq_var(IDLSM,I,VARNAMLSM(I),VARTYPLSM(I),VARDIMLSM(I),INLSM,VARATTLSM(I)) )
     DO K=1,100
       VARDIMIDLSM(I,K)=INLSM(K)
     END DO
     WRITE (*,*) I,VARNAMLSM(I),VARDIMLSM(I)
   END DO

  !get variable
   J=0
     DO I=1,VARLSM
        IF (VARNAMLSM(I) == 'lsm') THEN
           
           ALLOCATE (LSMASK(DIMLENLSM(VARDIMIDLSM(I,1)),DIMLENLSM(VARDIMIDLSM(I,2))))
           CALL check_err( nf_get_var_real(IDLSM,I,LSMASK) )
      END IF  
   END DO
  
!close input file
  CALL check_err( nf_close(IDLSM) )
 WRITE (*,*) 'Start Calculations'

 
!##############################################
!#########################################
! CALCULATIONS
 !###########################################
   NLON = DIMLENRM(1)
   NLAT = DIMLENRM(2)
   AYEARS = DIMLENRM(3)
 
 
 ALLOCATE (D_BSF_RM(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2)),DIMLENRM(VARDIMIDRM(NVAR_BT,3))))
 D_BSF_RM(:,:,:)=0.0
 
 ALLOCATE (D_0K8K(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 D_0K8K(:,:)=0.0
 ALLOCATE (D_TIME(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 D_TIME(:,:)=-7974.

 ALLOCATE (DT(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 DT(:,:)=0.
 
 ALLOCATE (T_MAX(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 T_MAX(:,:)=-7974.
 ALLOCATE (B_MAX(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 B_MAX(:,:)=0.
 ALLOCATE (T_MIN(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 T_MIN(:,:)=-7974.
 ALLOCATE (B_MIN(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
 B_MIN(:,:)=1.

 ALLOCATE (BSF_AHP(DIMLENRM(VARDIMIDRM(NVAR_BT,1)),DIMLENRM(VARDIMIDRM(NVAR_BT,2))))
  BSF_AHP(:,:)=-9999.0
 
WRITE (*,*) 'Allocation complete'

DO LAT = 1,NLAT
   DO LON = 1,NLON
!       WRITE(*,*) LON,LAT
      IF (LSMASK(LON,LAT) < 0.5) THEN
           D_TIME(LON,LAT)=-9999.0
           T_MAX(LON,LAT)=-9999.0
           T_MIN(LON,LAT)=-9999.0
        ELSE
           D_BSF_RM(LON,LAT,1)=0.0
 
           ! calculating time of MAX BSF and MIN BSF
           DO YEAR = 1,AYEARS 
           
              IF (BSF_RM(LON,LAT,YEAR) > B_MAX(LON,LAT)) THEN
                 B_MAX(LON,LAT) = BSF_RM(LON,LAT,YEAR)
                 T_MAX(LON,LAT) = -7999+(YEAR)
              END IF

              IF (BSF_RM(LON,LAT,YEAR) < B_MIN(LON,LAT)) THEN
                 B_MIN(LON,LAT) = BSF_RM(LON,LAT,YEAR)
                 T_MIN(LON,LAT) = -7999+(YEAR)
              END IF
                                    
           END DO
           

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!           
  !TIME OF END OF AHP based on slope of running mean (see manuscript, Fig.1)

           D_0K8K(LON,LAT)= (( SUM(BSF_RM(LON,LAT,AYEARS-100:AYEARS)))/100 - (SUM(BSF_RM(LON,LAT,1:100))/100)) /AYEARS  ! calculating the slope of the straight line between 8k (mean of first 100 years) and PI (last 100years)
 
           DO YEAR = 2,AYEARS
              R_YEAR = -7999+(YEAR-1)
            
              D_BSF_RM(LON,LAT,YEAR)=BSF_RM(LON,LAT,YEAR) - BSF_RM(LON,LAT,YEAR-1)  !slope between two consecutive timesteps
              IF (D_TIME(LON,LAT) == -7974.) THEN
                 
                 IF (D_0K8K(LON,LAT) > 0. ) THEN
                    
                    IF (R_YEAR > T_MIN(LON,LAT)) THEN                             ! proves if the minimum in BSF has already been passed

                       IF (D_BSF_RM(LON,LAT,YEAR) > D_0K8K(LON,LAT) ) THEN
                          DT(LON,LAT) = (BSF_RM(LON,LAT,YEAR+499) - BSF_RM(LON,LAT,YEAR))/500.   ! slope after 500 years

                          IF ( (DT(LON,LAT) >  D_0K8K(LON,LAT) )) THEN                            ! proving if the slope after 500 years still exceeds the slope of the straight line
                             D_TIME(LON,LAT) = -7999+(YEAR)
                             BSF_AHP(LON,LAT) = BSF_RM(LON,LAT,YEAR)
                                                       
                          END IF
                          
                       END IF
                     
                    END IF

                 ELSE
                    D_TIME(LON,LAT) = 0.
                 END IF
                 
              END IF

           END DO

 
      END IF

   END DO
END DO
TI = 1000.

 !################
!####################################
!output files
!####################################

   WRITE (*,*) 'creating output-file: ',OFILE
   IRET = nf_create(OFILE,nf_clobber,IDOUT)
   CALL check_err(IRET)

 !set latitudes and longtitudes

!define dimension names and length
   CALL check_err( nf_def_dim(IDOUT,'lon',NLON,LONID))
   CALL check_err( nf_def_dim(IDOUT,'lat',NLAT,LATID) )


   CALL check_err( nf_def_var(IDOUT,'lat',NF_DOUBLE,1,LATID,LAVARID) )

   CALL check_err( nf_def_var(IDOUT,'lon',NF_DOUBLE,1,LONID,LOVARID) )


  CALL check_err( nf_put_att_text(IDOUT, LAVARID, UNITS, LEN(LAT_UNITS),LAT_UNITS) )
   CALL check_err( nf_put_att_text(IDOUT, LOVARID, UNITS, LEN(LON_UNITS),LON_UNITS) )

! define variable names
WRITE (*,*) 'define vars'

  DIMIDS = (/ LONID, LATID /)

  CALL check_err( nf_def_var(IDOUT,'AHP_END',NF_REAL,2,DIMIDS(1),AHPID) )
  CALL check_err( nf_def_var(IDOUT,'T_MAX_BSF',NF_REAL,2,DIMIDS(1),MAXID) )
  CALL check_err( nf_def_var(IDOUT,'T_MIN_BSF',NF_REAL,2,DIMIDS(1),MINID) )
  CALL check_err( nf_def_var(IDOUT,'BSF_AHP',NF_REAL,2,DIMIDS(1),BSF_AHPID) )

   ! units
 !   CALL check_err( nf_put_att_text(IDOUT, AHPID, UNITS, LEN(TI_UNITS), TI_UNITS) )
 
  CALL check_err( nf_enddef(IDOUT) ) 

   CALL check_err( nf_put_var(IDOUT, LAVARID, LATS) )
   CALL check_err( nf_put_var(IDOUT, LOVARID, LONS) )

   CALL check_err( nf_put_var_real(IDOUT,AHPID,D_TIME) )
   CALL check_err( nf_put_var_real(IDOUT,MAXID,T_MAX) )
   CALL check_err( nf_put_var_real(IDOUT,MINID,T_MIN) )
   CALL check_err( nf_put_var_real(IDOUT,BSF_AHPID,BSF_AHP) )
   CALL check_err( nf_close(IDOUT) )

  WRITE (*,*)  'ready? '

  !####

END PROGRAM
!##########################################

 SUBROUTINE check_err(IRET)
   INTEGER IRET
   INCLUDE '/usr/include/netcdf.inc'
   IF (IRET .NE. NF_NOERR) THEN
   PRINT *, nf_strerror(IRET)
   STOP
   END IF

 END SUBROUTINE check_err

 


!#######

