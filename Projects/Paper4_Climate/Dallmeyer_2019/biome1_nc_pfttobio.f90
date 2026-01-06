  ! biome1 program by Prentice et al.1992 (Prentice, I.C., Cramer, W., Harrison, S.P., Leemans, R., Monserud, R.A., and Solomon, A.M.:
  ! A global biome model based on plant physiology and dominance, soil properties and climate. J. Biogeogr., 19, 117-134., 1992.)
  !
  ! modified by A. Dallmeyer 2018 to read netcdf-files and to handle transient simulations (without memory effect from one year to another)
!#######################################################
  ! The Biome1 biomes are further grouped into mega-biomes (no.)
  ! 1 tropical rainforest -> tropical forest (1)
  ! 2 tropical seasonal forest -> tropical forest (1)
  ! 3 savanna  -> savanna and dry woodland (5)
  ! 4 warm-temperate and mixed forest -> warm-temperate forest (2)
  ! 5 temperate deciduous forest -> temperate forest (3)
  ! 6 cool mixed forest -> temperate forest (3)
  ! 7 cool conifer forest -> temperatre forest (3)
  ! 8 Taiga forest -> boreal forest (4)
  ! 9 cold mixed forest -> boreal forest (4)
  ! 10 cold deciduous forest -> boreal forest (4)
  ! 11 xerophytic shrubs -> grassland and dry shrubland (6)
  ! 12 warm grass  -> grassland and dry shrubland (6)
  ! 13 cool grass -> grassland and dry shrubland (6)
  ! 14 tundra -> tundra (8)
  ! 15 desert -> desert (7)
  ! 16 polar desert -> polar desert and ice (9)
  !  #####################################################
 !
  ! start programm
  ! ****************************
IMPLICIT NONE
INCLUDE 'netcdf.inc' 
! error status return
   INTEGER  ::  IRET
! netCDF id
   INTEGER  ::  NCID1,NCID2,NCIDLSM
! dimensions
   INTEGER  ::  NDIMLON1,NDIMLAT1,NDIMID1
   INTEGER  ::  NDIM1,NVAR1,NATTR1,NUNLIMDIM1

   INTEGER  ::  NDIMLONL,NDIMLATL,NDIMIDL
   INTEGER  ::  NDIML,NVARL,NATTRL,NUNLIMDIML

   INTEGER  ::  LONLEN,LATLEN,TIMLEN
   INTEGER, ALLOCATABLE, DIMENSION(:)  ::  NDIMLEN1,NDIMLENL
   CHARACTER(LEN=30), ALLOCATABLE, DIMENSION(:)  ::  FDIMNAM1,FDIMNAML

 ! variables
   INTEGER  ::  NIN1(100),NIN2(100)
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARTYP1,NVARTYPL
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARDIM1,NVARDIML
   INTEGER, ALLOCATABLE, DIMENSION(:,:)  :: NVARDIMID1,NVARDIMIDL
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARATT1,NVARATTL
   INTEGER :: COLDID,WARMID,GDD0ID,GDD5ID,MOISTID,BIOMID,MBIOMID
   CHARACTER(LEN=30), ALLOCATABLE, DIMENSION(:)  ::  FVARNAM1, FVARNAML

! units   
  CHARACTER (LEN = *), PARAMETER :: UNITS = "units"
  CHARACTER (LEN = *), PARAMETER :: TEMP_UNITS = "degree celsius"
  CHARACTER (LEN = *), PARAMETER :: LAT_UNITS = "degrees_north"
  CHARACTER (LEN = *), PARAMETER :: LON_UNITS = "degrees_east"
  CHARACTER (LEN = *), PARAMETER :: TI_UNITS = "years"
   
!  files 
   CHARACTER(LEN=60)  :: INFILE,OFILE,LSMFILE

! variables for biomes
   CHARACTER(LEN=28) :: PFTNAME(14)
   INTEGER ::   PFTTYPE(14)
   REAL, DIMENSION(12) :: MTC,MPR,MCL
   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: TT,PP,CC, TT2
   REAL, ALLOCATABLE, DIMENSION(:) :: RLON,RLAT
   REAL, ALLOCATABLE, DIMENSION(:,:) :: WATC
   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: COLD,WARM,GDD0,GDD5,MOIST,NBIOME, MEBIOME
   REAL, ALLOCATABLE, DIMENSION (:,:) :: LSMASK
   REAL, ALLOCATABLE, DIMENSION (:,:) :: YCOLD,YWARM,YGDD0,YGDD5,YMOIST
   INTEGER :: NLAT,NLON,NYEARS,LONID,LATID,YEARID,LOVARID,LAVARID,TIVARID,TISTAR
   INTEGER :: DIMIDS(3)

! Dimensions of output file
   DOUBLE PRECISION, ALLOCATABLE, DIMENSION (:) ::  LATS, LONS, TIMES, TIMESN
!indices  
  INTEGER  :: NTYPES,MON,LO,LA,NBK,NMBK,K,I,II,M,J,NVAR_TT,NVAR_PP,NVAR_CC,NVAR_LL,NVAR_LA,NVAR_TI,YEAR


  !##############################################################
  READ (*,*) INFILE
  READ (*,*) OFILE
  READ (*,*) LSMFILE

!###############################################################

!INPUT FILE
!-----------------------------------------------------------------
!open and check file

 WRITE (*,*) 'Infile: ',INFILE
 WRITE (*,*) '------------------------------'
 CALL check_err( nf_open(INFILE,nf_nowrite,NCID1) )
 CALL check_err( nf_inq(NCID1,NDIM1,NVAR1,NATTR1,NUNLIMDIM1) )

!get dimensions
  ALLOCATE (NDIMLEN1(NDIM1))
  ALLOCATE (FDIMNAM1(NDIM1))
  WRITE (*,*) 'Dimensions'
  
  DO I=1,NDIM1
     CALL check_err( nf_inq_dim(NCID1,I,FDIMNAM1(I),NDIMLEN1(I)) )
     WRITE (*,*) I,FDIMNAM1(I),NDIMLEN1(I)

     IF (FDIMNAM1(I) == 'lon') THEN
        LONLEN = NDIMLEN1(I)
     ELSE IF (FDIMNAM1(I) == 'lat') THEN
        LATLEN = NDIMLEN1(I)
     ELSE IF (FDIMNAM1(I) == 'time') THEN
        TIMLEN = NDIMLEN1(I)
     END IF
 
  END DO

! get variable names, types and shapes
   ALLOCATE (FVARNAM1(NVAR1))
   ALLOCATE (NVARTYP1(NVAR1))
   ALLOCATE (NVARDIM1(NVAR1))
   ALLOCATE (NVARDIMID1(NVAR1,100))
   ALLOCATE (NVARATT1(NVAR1))
   
   NIN1(:) = 0
   
   WRITE (*,*) 'Variables / No. of dimensions'
   
   DO I=1,NVAR1
     CALL check_err( nf_inq_var(NCID1,I,FVARNAM1(I),NVARTYP1(I),NVARDIM1(I),NIN1,NVARATT1(I)) )
     DO K=1,100
       NVARDIMID1(I,K)=NIN1(K)
     END DO
     WRITE (*,*) I,FVARNAM1(I),NVARDIM1(I)
   END DO

!get variable
   J=0
   DO I=1,NVAR1
      IF (FVARNAM1(I) == 'temp2') THEN
         NVAR_TT=I
         ALLOCATE (TT(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         ALLOCATE (TT2(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         CALL check_err( nf_get_var_real(NCID1,I,TT) )
         J=J+1
         WRITE (*,*) 'read temp2'
      ELSE IF (FVARNAM1(I) == 'precip') THEN
         NVAR_PP=I
         ALLOCATE (PP(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         CALL check_err( nf_get_var_real(NCID1,I,PP) )
         J=J+1
          WRITE (*,*) 'read precip'
      ELSE IF (FVARNAM1(I) == 'aclcov') THEN
         NVAR_CC=I
         ALLOCATE (CC(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         CALL check_err( nf_get_var_real(NCID1,I,CC) )
         J=J+1
          WRITE (*,*) 'read cloud'
      ELSE IF (FVARNAM1(I) == 'lon') THEN
          NVAR_LL=I
          ALLOCATE (LONS(NDIMLEN1(NVARDIMID1(I,1))))
          CALL check_err( nf_get_var_double(NCID1,I,LONS) )
          J=J+1
           WRITE (*,*) 'read lon'
       ELSE IF (FVARNAM1(I) == 'lat') THEN
          NVAR_LL=I
          ALLOCATE (LATS(NDIMLEN1(NVARDIMID1(I,1))))
          CALL check_err( nf_get_var_double(NCID1,I,LATS) )
          J=J+1
           WRITE (*,*) 'read lat'
      ELSE IF (FVARNAM1(I) == 'time') THEN
          NVAR_LL=I
          ALLOCATE (TIMES(NDIMLEN1(NVARDIMID1(I,1))))
          CALL check_err( nf_get_var_double(NCID1,I,TIMES) )
         J=J+1  
         WRITE (*,*) 'read time'
         TISTAR=(INT(TIMES(1)/10000.))
      ELSE IF (FVARNAM1(I) .NE. 'lon' .AND. FVARNAM1(I) .NE. 'lat' .AND. FVARNAM1(I) .NE. 'time') THEN 
         WRITE(*,*) 'ERROR: Variables not found' 
      END IF
   END DO

   WRITE (*,*) 'finish reading'
   IF (J < 3) THEN
         WRITE(*,*) 'missing variables: ', -J+3
         WRITE(*,*) 'stop program'
         stop
   END IF

   TT2=TT
   
!close input file
  CALL check_err( nf_close(NCID1) )
!Land-sea-mask,input
!-------------------------------------
 WRITE (*,*) 'Land-sea-mask: ',LSMFILE
 WRITE (*,*) '-----------------------------------'
 
 CALL check_err( nf_open(LSMFILE,nf_nowrite,NCIDLSM) )
 CALL check_err( nf_inq(NCIDLSM,NDIML,NVARL,NATTRL,NUNLIMDIML) )

  !get  and check dimensions
  WRITE (*,*) 'Dimensions'

  ALLOCATE (NDIMLENL(NDIML))
  ALLOCATE (FDIMNAML(NDIML))

  DO I=1,NDIML
     CALL check_err( nf_inq_dim(NCIDLSM,I,FDIMNAML(I),NDIMLENL(I)) )
     WRITE (*,*) I,FDIMNAML(I),NDIMLENL(I)
     IF (FDIMNAML(I) == 'lon') THEN
        IF (NDIMLENL(I) .NE. LONLEN) THEN
        WRITE(*,*) 'ERROR: Climate variables and land-sea mask have different dimensions (lon)'
        END IF
     ELSE IF (FDIMNAML(I) == 'lat') THEN
        IF (NDIMLENL(I) .NE. LATLEN) THEN
        WRITE(*,*) 'ERROR: Climate variables and land-sea mask have different dimensions (lat)'
        END IF
     END IF
  END DO
 
! get variable names, types and shapes
   ALLOCATE (FVARNAML(NVARL))
   ALLOCATE (NVARTYPL(NVARL))
   ALLOCATE (NVARDIML(NVARL))
   ALLOCATE (NVARDIMIDL(NVARL,100))
   ALLOCATE (NVARATTL(NVARL))
   
   NIN1(:) = 0
   
   WRITE (*,*) 'Variables / No. of dimensions'

   DO I=1,NVARL
     CALL check_err( nf_inq_var(NCIDLSM,I,FVARNAML(I),NVARTYPL(I),NVARDIML(I),NIN1,NVARATTL(I)) )
     DO K=1,100
       NVARDIMIDL(I,K)=NIN1(K)
     END DO
     WRITE (*,*) I,FVARNAML(I),NVARDIML(I)
   END DO

  !get variable
   J=0
     DO I=1,NVARL
        IF (FVARNAML(I) == 'lsm') THEN
           
           WRITE (*,*) 'read lsm'
           ALLOCATE (LSMASK(NDIMLENL(NVARDIMIDL(I,1)),NDIMLENL(NVARDIMIDL(I,2))))
           CALL check_err( nf_get_var_real(NCIDLSM,I,LSMASK) )
           J=J+1
      ELSE IF (FVARNAML(I) == 'lon' ) THEN
         ALLOCATE (RLON(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_real(NCIDLSM,I,RLON) )
      ELSE IF (FVARNAML(I) == 'lat' ) THEN
         ALLOCATE (RLAT(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_real(NCIDLSM,I,RLAT) )
      END IF  
   END DO
   IF (J < 1) THEN
         WRITE(*,*) 'land sea mask missing '
         WRITE(*,*) 'stop program'
         stop
   END IF

!close input file
  CALL check_err( nf_close(NCIDLSM) )
 


!###################################################################################################
!++++++++++++++++++++++++   MAIN PROGRAM   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!###################################################################################################
WRITE (*,*) '*  *  *  *   START   MAIN   PROGRAM  *  *   *   *'
!###################################################################################################

   NLON = LONLEN
   NLAT = LATLEN
   NYEARS = (TIMLEN/12)
 
   ALLOCATE (NBIOME(NLON,NLAT,NYEARS))
   ALLOCATE (MEBIOME(NLON,NLAT,NYEARS))
   ALLOCATE (COLD(NLON,NLAT,NYEARS))
   ALLOCATE (WARM(NLON,NLAT,NYEARS))
   ALLOCATE (GDD0(NLON,NLAT,NYEARS))
   ALLOCATE (GDD5(NLON,NLAT,NYEARS))
   ALLOCATE (MOIST(NLON,NLAT,NYEARS))
   ALLOCATE (WATC(NLON,NLAT))
   ALLOCATE (YMOIST(NLON,NLAT))
   ALLOCATE (YCOLD(NLON,NLAT))
   ALLOCATE (YWARM(NLON,NLAT))
   ALLOCATE (YGDD0(NLON,NLAT))
   ALLOCATE (YGDD5(NLON,NLAT))
   ALLOCATE (TIMESN(NYEARS))


 DO YEAR = 1,NYEARS  
    
  WATC=0.15
    K = (YEAR*12)-11
   DO LA = 1,NLAT
      DO LO = 1,NLON
         ! PRINT*, 'LO,LA :', RLON(LO),RLAT(LA), LO, LA
              IF (LSMASK(LO,LA) < 0.5) THEN
                 NBIOME(LO,LA,YEAR) = 0
                 MEBIOME(LO,LA,YEAR) = 0
                 COLD(LO,LA,YEAR)=-9999
                 WARM(LO,LA,YEAR)=-9999
                 GDD0(LO,LA,YEAR)=-9999
                 GDD5(LO,LA,YEAR)=-9999
                 MOIST(LO,LA,YEAR)=-9999
              ELSE
              WATC(LO,LA)=WATC(LO,LA)*1000.
                 DO MON = 1,12
                    M = K-1+MON
                    MTC(MON)=TT(LO,LA,M)-273.16
                   !WRITE (*,*) MTC (MON), TT(LO,LA,M)
                   !WRITE (*,*) LO, LA
                    MPR(MON)=MAX(0.,PP(LO,LA,M)*2628000.)
                    IF (CC(LO,LA,M) > 1.) THEN
                       CC(LO,LA,M) = 1.
                    END IF  
                     MCL(MON)=1.-CC(LO,LA,M)
                  END DO
!              WRITE (*,*) 'call SMOIST'    
              CALL SMOIST(RLON(LO),RLAT(LA),MTC,MPR,MCL,WATC(LO,LA),YMOIST(LO,LA))
!              WRITE (*,*) 'call STEMP'
              CALL STEMP(MTC,YGDD0(LO,LA),YGDD5(LO,LA),YCOLD(LO,LA),YWARM(LO,LA))
              CALL BIOME(YCOLD(LO,LA),YWARM(LO,LA),YGDD0(LO,LA), &
                   YGDD5(LO,LA),YMOIST(LO,LA),PFTNAME,PFTTYPE,NTYPES)
              CALL OUTP(PFTNAME,PFTTYPE,NBK,NMBK)
              NBIOME(LO,LA,YEAR)=REAL(NBK)
              MEBIOME(LO,LA,YEAR)=REAL(NMBK)
              COLD(LO,LA,YEAR)=YCOLD(LO,LA)
              WARM(LO,LA,YEAR)=YWARM(LO,LA)
              GDD0(LO,LA,YEAR)=YGDD0(LO,LA)
              GDD5(LO,LA,YEAR)=YGDD5(LO,LA)
              MOIST(LO,LA,YEAR)=YMOIST(LO,LA)
              
              ENDIF
           END DO
   
        END DO
     END DO


!creating time-axis
DO J = 1,NYEARS

   TIMESN(J)=TISTAR-1+J

END DO

!####################################
!output files
!####################################

   WRITE (*,*) 'creating output-file: ',OFILE
   IRET = nf_create(OFILE,nf_clobber,NCID2)
   CALL check_err(IRET)

 !set latitudes and longtitudes

!define dimension names and length
   CALL check_err( nf_def_dim(NCID2,'lon',NLON,LONID))
   CALL check_err( nf_def_dim(NCID2,'lat',NLAT,LATID) )
   CALL check_err( nf_def_dim(NCID2,'time',NYEARS,YEARID) )
 
   CALL check_err( nf_def_var(NCID2,'lat',NF_DOUBLE,1,LATID,LAVARID) )

   CALL check_err( nf_def_var(NCID2,'lon',NF_DOUBLE,1,LONID,LOVARID) )

   CALL check_err( nf_def_var(NCID2,'time',NF_DOUBLE,1,YEARID,TIVARID) )
   
  CALL check_err( nf_put_att_text(NCID2, LAVARID, UNITS, LEN(LAT_UNITS),LAT_UNITS) )
   CALL check_err( nf_put_att_text(NCID2, LOVARID, UNITS, LEN(LON_UNITS),LON_UNITS) )
   CALL check_err( nf_put_att_text(NCID2, TIVARID, UNITS, LEN(TI_UNITS), TI_UNITS) )

! define variable names
WRITE (*,*) 'define variabless'

DIMIDS = (/ LONID, LATID, YEARID /)

  CALL check_err( nf_def_var(NCID2,'Biome',NF_REAL,3,DIMIDS(1),BIOMID) )
  
  CALL check_err( nf_def_var(NCID2,'Mega-Biomes',NF_REAL,3,DIMIDS(1),MBIOMID) )
  
   
   CALL check_err( nf_def_var(NCID2,'Tcold',NF_REAL,3,DIMIDS(1),COLDID) )

   CALL check_err( nf_def_var(NCID2,'Twarm',NF_REAL,3,DIMIDS(1),WARMID) )

   CALL check_err( nf_def_var(NCID2,'moist',NF_REAL,3,DIMIDS(1),MOISTID) )

   CALL check_err( nf_def_var(NCID2,'GDD0',NF_REAL,3,DIMIDS(1),GDD0ID) )

   CALL check_err( nf_def_var(NCID2,'GDD5',NF_REAL,3,DIMIDS(1),GDD5ID) )

   ! units
    CALL check_err( nf_put_att_text(NCID2, COLDID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, WARMID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, GDD0ID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, GDD5ID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )

  CALL check_err( nf_enddef(NCID2) ) 
   
    ! write output   

   CALL check_err( nf_put_var(NCID2, LAVARID, LATS) )
   CALL check_err( nf_put_var(NCID2, LOVARID, LONS) )
   CALL check_err( nf_put_var(NCID2, TIVARID, TIMESN) )

   CALL check_err( nf_put_var_real(NCID2,BIOMID,NBIOME) )
   CALL check_err( nf_put_var_real(NCID2,MBIOMID,MEBIOME) )
   
   CALL check_err( nf_put_var_real(NCID2,COLDID,COLD) )
   CALL check_err( nf_put_var_real(NCID2,WARMID,WARM) )
   CALL check_err( nf_put_var_real(NCID2,MOISTID,MOIST) )
   CALL check_err( nf_put_var_real(NCID2,GDD0ID,GDD0) )
   CALL check_err( nf_put_var_real(NCID2,GDD5ID,GDD5) )

   

   CALL check_err( nf_close(NCID2) )


!  WRITE (*,*)  'YES! '

END program

!***************************************************************************
!***************************************************************************

SUBROUTINE check_err(IRET)
INCLUDE 'netcdf.inc'
  INTEGER IRET
  IF (IRET .NE. NF_NOERR) THEN
     PRINT *, nf_strerror(IRET)
     STOP
     END IF
END SUBROUTINE check_err


!####################################

SUBROUTINE BIOME(YCOLD,YWARM,YGDD0,YGDD5,YMOIST,PFTNAME,PFTTYPE,NTYPES)

  INTEGER, PARAMETER :: NPFT=14, NCLIN=5  !Number of Plant functional types and climate indices
  REAL, PARAMETER :: UNDEF=-99.9          !undefined values in limits of plant functional types

  REAL :: YCOLD,YWARM            !mean temp of coldest and warmest month, read only
  REAL :: YGDD0,YGDD5            !growing degree days, base0 and base5, read only
  REAL :: YMOIST                !moisture index

 !output from this routine
  CHARACTER(LEN=26) :: PFTNAME(14)
  INTEGER :: PFTTYPE(14), NTYPES

 !local variables
  INTEGER :: IP,IV,IL        !plant functional type, Climate index and upper/lower climate index

 !temporay variables and arrays               
  CHARACTER(LEN=26) :: BIOTYP(14)  ! Defined names of plant functional types 
  REAL :: LIMITS(14,5,2)           ! Climatic limits for plant functional types 
  REAL :: CLINDEX(5)               ! Climate indices
  INTEGER :: HIERAR(14)            ! Hierarchy definition plant functional types
  INTEGER :: PFT(14)=0             ! Available plant functional types
  INTEGER :: MINDOM                ! Minimum value in dominance hierarchy

! DATA STATEMENTS:
! define and initialize the plant functional types
  DATA (BIOTYP(IP),IP=1,14) /'Tropical Evergreen Trees ','Tropical Deciduous Trees ', &
       'Tropical Shrubs/Grasses  ','Temperate Evergreen Trees', &
       'Temperate Deciduous Trees','Temperate Shrubs/Grasses ', &
       'Boreal Evergreen Trees   ','Boreal Deciduous Trees   ', &
       'Boreal Scrubs/Grasses    ','Hot Desert Plants        ', &
       'Cool Desert Plants       ','Cold Desert Plants       ', &
       'Medit. Sclerophyl. Scrubs','Cool Conifer Trees       '/

! define and initialize the limits of all climatic indices  
  DATA (((LIMITS(IP,IV,IL),IL=1,2),IV=1,5),IP=1,14)/   &
       15.5,-99.9, -99.9,-99.9,-99.9,-99.9,-99.9,-99.9, 0.80,-99.9, &
       15.5,-99.9, -99.9,-99.9,-99.9,-99.9,-99.9,-99.9, 0.45, 0.95, &
      -99.9,-99.9, -99.9,-99.9,-99.9,-99.9, 22.0,-99.9, 0.18,-99.9, &
        5.0,-99.9, -99.9,-99.9,-99.9,-99.9,-99.9,-99.9, 0.65,-99.9, &
      -15.0, 15.5,1200.0,-99.9,-99.9,-99.9,-99.9,-99.9, 0.65,-99.9, &
      -99.9,-99.9, 500.0,-99.9,-99.9,-99.9,-99.9,-99.9, 0.33,-99.9, &
      -35.0, -2.0, 350.0,-99.9,-99.9,-99.9,-99.9,-99.9, 0.75,-99.9, &
      -99.9,  5.0, 350.0,-99.9,-99.9,-99.9,-99.9,-99.9, 0.65,-99.9, &
      -99.9,-99.9, -99.9,-99.9,100.0,-99.9,-99.9,-99.9, 0.33,-99.9, &
      -99.9,-99.9, -99.9,-99.9,-99.9,-99.9, 22.0,-99.9,-99.9,-99.9, &
      -99.9,-99.9, -99.9,-99.9,100.0,-99.9,-99.9, 15.0,-99.9,-99.9, &
      -99.9,-99.9, -99.9,-99.9,-99.9,-99.9,-99.9,-99.9,-99.9,-99.9, &
        5.0,-99.9, -99.9,-99.9,-99.9,-99.9,-99.9,-99.9, 0.28,-99.9, &
      -19.0,  5.0, 900.0,-99.9,-99.9,-99.9,-99.9,-99.9, 0.65,-99.9/ 

! define and initialize the dominance hierarchy
  DATA (HIERAR(IP),IP=1,14) /1,1,5,2,3,6,3,3,6,7,8,9,4,3/

! set up climate indices array:
      CLINDEX(1)=YCOLD
      CLINDEX(2)=YGDD5
      CLINDEX(3)=YGDD0
      CLINDEX(4)=YWARM
      CLINDEX(5)=YMOIST

      DO IP=1,NPFT
         PFTTYPE(IP)=0
      END DO
      
! Determines the values of the climatic indices are within the specific climatic limits 
      DO IP=1,NPFT
         DO IV=1,NCLIN

! both limits given, value inside - PRESENT:
            IF(LIMITS(IP,IV,1).le.CLINDEX(IV).and.    &
              LIMITS(IP,IV,1).ne.UNDEF.and.           &
              LIMITS(IP,IV,2).ne.UNDEF.and.           &
              LIMITS(IP,IV,2).gt.CLINDEX(IV)) THEN
              PFT(IP)=1

! or lower limit missing, value below upper level - PRESENT:
            ELSEIF(LIMITS(IP,IV,1).eq.UNDEF.and.        &
                 LIMITS(IP,IV,2).ne.UNDEF.and.          & 
                 LIMITS(IP,IV,2).gt.CLINDEX(IV)) THEN
                 PFT(IP)=1

! or upper limit missing, value above lower level - PRESENT:
            ELSEIF(LIMITS(IP,IV,1).le.CLINDEX(IV).and.  &
                 LIMITS(IP,IV,1).ne.UNDEF.and.          &
                 LIMITS(IP,IV,2).eq.UNDEF) THEN
                  PFT(IP)=1

! both LIMITS missing 
            ELSEIF(LIMITS(IP,IV,1).eq.UNDEF.and.        &
               LIMITS(IP,IV,2).eq.UNDEF) THEN
               PFT(IP)=1

! none of these - ABSENT:
            ELSE
               PFT(IP)=0
               GOTO 100
            ENDIF
         END DO
100   ENDDO

! Apply dominance hierarchy
                
      MINDOM=9999
      DO IP=1,NPFT
         IF (PFT(IP).ne.0) MINDOM=min(MINDOM,int(HIERAR(IP)))
      END DO   
      
      DO IP=1,NPFT
         IF(PFT(IP).ne.0.and.HIERAR(IP).gt.MINDOM) PFT(IP)=0
      END DO

! fill in return arguments

      NTYPES=0
      DO IP=1,NPFT
         IF(PFT(IP).ne.1) goto 300       
         NTYPES=NTYPES+1
         PFTTYPE(NTYPES)=IP
         PFTNAME(NTYPES)=BIOTYP(IP)
300      CONTINUE
      ENDDO
      RETURN
    END SUBROUTINE BIOME

!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------
   SUBROUTINE BUCKET (LON,LAT,WATC,MTC,MPR,MCL,SCR,APET,AAET)

     INTEGER :: MAXIT   !maximum number of iterations to achieve convergence
     REAL :: EPS, CW    !convergence parameter for soil moisture, maximum evap rate
     PARAMETER(EPS=1.,MAXIT=175,CW=1.) 

     INTEGER :: DAYS(12),DAYN,YEARN,IM,ID,SCR

     REAL :: LON,LAT,WATC
     REAL :: LSM,YSM,SUPP               !soil moisture last year, this year, supply evaporation
     REAL :: DAET,DPET,APET,AAET        !Evaporation variables
     REAL :: MTC(12),MPR(12),MCL(12)    !monthly climate parameters
     REAL :: DTC(365),DPR(365),DCL(365),DSM(365)  !daily climateparameters
     REAL :: MAET(12),MPET(12),PPR(12)  !montly actual and potential evap
       


     DATA DAYS /31,28,31,30,31,30,31,31,30,31,30,31/           

! subroutines called:
! daily   converts monthly to daily data (separate file)
! evapo   performs the actual ET estimation (daily)

! ---------------------------------
! make pseudo-daily interpolated arrays of climate variables

      call daily(mtc,dtc)
! for precipitation, we divide first with the number of days for the month
      do im=1,12
         ppr(im)=mpr(im)/REAL(days(im))
      end do
      call daily(ppr,dpr)
      call daily(mcl,dcl)

      dayn=0

! soil moisture for the first day of the first year is initialized to
! maximum value (water capacity)

      dsm(1)=watc
      lsm=dsm(1)
      yearn=1

120   continue

      dayn=0
      apet=0.
      aaet=0.

! ------------------ start monthly calculation loop --------------------

      do im=1,12
         mpet(im)=0.
         maet(im)=0.
!         WRITE (*,*) im
! ------------------- start daily calculation loop --------------------

         do id=1,days(im)
            dayn=dayn+1
 !           write (*,*) id
            if(dayn.eq.1) then
               ysm=lsm
            else
               ysm=dsm(dayn-1)
            endif
           
            if(watc.eq.0) then
               supp=0.
            else
               supp=cw*(ysm/watc)
            endif

            call evapo(dtc(dayn),dcl(dayn),dayn,lat,supp,daet,dpet)

            dsm(dayn)=ysm+dpr(dayn)-daet

            if(dsm(dayn).gt.watc) then

               dsm(dayn)=watc

            else

               if(dsm(dayn).lt.0) dsm(dayn)=0.

            endif


            mpet(im)=mpet(im)+dpet
            maet(im)=maet(im)+daet

            end do 

         apet=apet+mpet(im)
         aaet=aaet+maet(im)

      end do

      if(abs(lsm-dsm(365)).gt.eps) then
         lsm=dsm(365)
         yearn=yearn+1
         if(yearn.gt.maxit) then
            write(scr,'('' No convergence at'',2f8.2)') lon,lat
            apet=-99.
            aaet=-99.
            return
         endif
         goto 120
      endif

    end subroutine bucket

!---------------------------------------------------------------------------

      subroutine evapo(dtc,dcl,dayn,lat,supp,daet,dpet)

      REAL alb,solc,alpha,k1,k2,k3,ecce,pi,pi180,peri,obliq

      parameter(alb=0.17,solc=1360.,alpha=1.,k1=610.78,k2=17.269,k3=237.3,pi=3.141592654,pi180=57.29577951)
      parameter(ecce=0.01675,peri=004.4,obliq=23.45)

      INTEGER dayn
      REAL dtc,dcl,lat,supp,dpet,daet
      REAL delta,gamma,lambda,sat,msolc,arg,h0,h1,u,v
!   write (*,*) 'hier'
      arg=(360.*dayn/365.)/pi180
      msolc=solc*(1.+2.*ecce*cos(arg))
      arg=(360.*dayn/365.)/pi180
      delta=-obliq*cos(arg)

      call table(dtc,gamma,lambda)
!      write (*,*) 'sat in evap', k1,k2,k3,dtc
       sat=k1*k2*k3*exp(k2*dtc/(k3+dtc))/((k3+dtc)**2)
       
!      write (*,*) 'u'
      u=(0.0036/lambda)*alpha*(sat/(sat+gamma))*(msolc*(0.25+0.5*dcl)*(1.-alb)* &
           sin(lat/pi180)*sin(delta/pi180)-((0.2+0.8*dcl)*(107-dtc)))

      v=(0.0036/lambda)*alpha*(sat/(sat+gamma))*(msolc*(0.25+0.5*dcl)*(1.-alb)* &
           cos(lat/pi180)*cos(delta/pi180))
! write (*,*) 'hier'
      if((supp-u).ge.v) then
         h1=0.
      elseif((supp-u).le.(0.-v)) then
         h1=pi
         h0=pi
      else
         arg=((supp-u)/v)
         h1=acos(arg)
      endif
!       write (*,*) 'hier'
      if(u.ge.v) then

         h0=pi
      elseif(u.le.(0.-v)) then

         h1=0.
         h0=0.
      else

         arg=(u/v)*(-1.)
         h0=acos(arg)
      endif
!      write (*,*) 'hier'
      u=(0.0036/lambda)*alpha*(sat/(sat+gamma))*(msolc*(0.25+0.5*dcl)*(1.-alb)* &
           sin(lat/pi180)*sin(delta/pi180)-((0.2+0.8*dcl)*(107.-dtc)))
      dpet=(((2.*u*h0)+(2.*v*sin(h0)))/(pi/12.))/alpha
      daet=((2.*u*(h0-h1)+2.*v*(sin(h0)-sin(h1))+2.*supp*h1)/(pi/12.))
!    write (*,*) 'ende evapo'
    end subroutine evapo

!---------------------------------------------------------------------------

      subroutine table(tc,gamma,lambda)

      INTEGER ir,il
      REAL gbase(2,11),lbase(2,11)
      REAL gamma,lambda,tc

      data ((gbase(ir,il),ir=1,2),il=1,11) &
     /-5.,64.6, 0.,64.9, 5.,65.2,10.,65.6,15.,65.9,20.,66.1, &
       25.,66.5,30.,66.8,35.,67.2,40.,67.5,45.,67.8/

      data ((lbase(ir,il),ir=1,2),il=1,11) &
     /-5.,2.513, 0.,2.501, 5.,2.489,10.,2.477,15.,2.465,20.,2.454, &
      25.,2.442,30.,2.430,35.,2.418,40.,2.406,45.,2.394/


      if(tc.gt.gbase(1,11)) then
         gamma=gbase(2,11)
         lambda=lbase(2,11)
         return
      endif

      do il=1,11
         if(tc.le.gbase(1,il)) then
            gamma=gbase(2,il)
            lambda=lbase(2,il)
            return
         endif
       end do

     end subroutine table
!------------------------------------------------

SUBROUTINE DAILY(MLY,DLY)

! Interpolates montly values to daily values by using linear estimation

!ARGUMENTS:

  REAL :: MLY(12)     !  Monthly values
  REAL :: DLY(365)    !  yearly values

! LOCAL VARIABLES:

  REAL :: MIDDAY(12)  !Median cummulative day of each month
  REAL :: VINC        !increment for daily values
  INTEGER :: IM, ID       !variable  integer index for months, days

  DATA (MIDDAY(IM),IM=1,12)/16., 44., 75.,105.,136.,166.,197.,228.,258.,289.,319.,350./

! interpolate linearly the daily values
  VINC=(MLY(1)-MLY(12))/31.0
  DLY(350)=MLY(12)
  DO  ID=351,365
     DLY(ID)=DLY(ID-1)+VINC
  END DO
  DLY(1)=DLY(365)+VINC
  
  DO ID=2,15
     DLY(ID)=DLY(ID-1)+VINC
  END DO

  DO IM=1,11
     VINC=(MLY(IM+1)-MLY(IM))/(MIDDAY(IM+1)-MIDDAY(IM))
     
     DLY(INT(MIDDAY(IM)))=MLY(IM)
    
     DO ID=INT(MIDDAY(IM))+1,INT(MIDDAY(IM+1))-1
        DLY(ID)=DLY(ID-1)+VINC
     END DO
  END DO
  RETURN

END SUBROUTINE DAILY

!---------------------------------------------------------------------------
!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------

SUBROUTINE XTEMP (MTC,YGDD0,YGDD5,MTCO,MTWA)

implicit none

! input variable
  REAL :: MTC(12)        ! monthly mean temperature

! output variables
  REAL :: YGDD0,YGDD5     !growing degree days on zero and five degree basis
  REAL :: MTCO,MTWA           ! mean temperature of coldest and warmest month

! internal variables
  REAL :: DTC(365)       !daily temperature values

! indices
  INTEGER :: ID,IM
! subroutines called
! > daily  to convert monthly data to pseudo-daily values

  CALL DAILY(MTC,DTC)

  YGDD0=0.
  YGDD5=0.
 
  DO ID=1,365

     IF(DTC(ID).gt.0) YGDD0=YGDD0+DTC(ID)
     IF(DTC(ID).gt.5) YGDD5=YGDD5+DTC(ID)-5.

  END DO

  MTCO=999.
  MTWA=-999.

  DO IM=1,12

     IF(MTC(IM).lt.MTCO) MTCO=MTC(IM)
     IF(MTC(IM).gt.MTWA) MTWA=MTC(IM)
  END DO

END SUBROUTINE XTEMP

!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------

SUBROUTINE SMOIST(LON,LAT,MTC,MPR,MCL,WATC,YMOIST)

  INTEGER :: SCR
  REAL :: LON,LAT
  REAL :: YMOIST,WATC,APET,AATT
  REAL :: MTC(12),MPR(12),MCL(12) 

  CALL BUCKET(LON,LAT,WATC,MTC,MPR,MCL,SCR,APET,AAET)
!       WRITE (*,*) 'BUCKET'
  IF(AAET.gt.0.and.APET.gt.0) THEN
     YMOIST=AAET/APET
  ELSEIF(AAET.eq.0.or.AAET.eq.-99..or.APET.eq.0.or.APET.eq.-99.) THEN
     YMOIST=0.
  ELSE
     WRITE(*,*) 'ERROR: negative AAET/APET at ' , LON, LAT
     STOP
  ENDIF

  RETURN
END SUBROUTINE SMOIST

!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------

SUBROUTINE STEMP(MTC,YGDD0,YGDD5,YCOLD,YWARM)

  REAL :: GDD0,GDD5,COLD,WARM
  REAL :: MTC(12)

  CALL XTEMP(MTC,YGDD0,YGDD5,YCOLD,YWARM)

  RETURN
END SUBROUTINE STEMP

!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------

SUBROUTINE OUTP(PFTNAME,PFTTYPE,NBK,MNBK)
  
  INTEGER, PARAMETER :: NPFT=14,NBIO=17
  CHARACTER(LEN=26) ::PFTNAME(NPFT)
  INTEGER :: PFTTYPE(NPFT)
  INTEGER :: IP,NBK,MNBK

  IF(PFTTYPE(1).eq.1)  THEN
     NBK=1
     MNBK=1
     
  ELSEIF(PFTTYPE(1).eq.2)  THEN
     NBK=3
     MNBK=5
  
  ELSEIF(PFTTYPE(1).eq.3) THEN
     NBK=12
     MNBK=6

  ELSEIF(PFTTYPE(1).eq.4) THEN
     NBK=4
     MNBK=2
     
  ELSEIF(PFTTYPE(1).eq.8) THEN
     NBK=10
     MNBK=4

  ELSEIF(PFTTYPE(1).eq.9)  THEN
     NBK=14
     MNBK=8
     
  ELSEIF(PFTTYPE(1).eq.10) THEN
     NBK=15
     MNBK=7
     
  ELSEIF(PFTTYPE(1).eq.11) THEN
     NBK=16
     MNBK=7

  ELSEIF(PFTTYPE(1).eq.12) THEN
     NBK=17
     MNBK=9
     
  ELSEIF(PFTTYPE(1).eq.13) THEN
     NBK=11
     MNBK=6
  ENDIF
  
  IF(PFTTYPE(1).eq.1.and.PFTTYPE(2).eq.2) THEN
     NBK=2
     MNBK=1
  ENDIF
  
  IF(PFTTYPE(1).eq.6.and.PFTTYPE(2).eq.9) THEN
     NBK=13
     MNBK=6
  ENDIF
  
  IF(PFTTYPE(1).eq.7.and.PFTTYPE(2).eq.8) THEN
     NBK=8
     MNBK=4
  ENDIF
  
  IF(PFTTYPE(1).eq.8.and.PFTTYPE(2).eq.14) THEN
     NBK=9
     MNBK=4
  ENDIF
  
  IF(PFTTYPE(1).eq.5.and.PFTTYPE(2).eq.8.and.PFTTYPE(3).eq.14) THEN
     NBK=5
     MNBK=3
  ENDIF
  
  IF(PFTTYPE(1).eq.7.and.PFTTYPE(2).eq.8.and.PFTTYPE(3).eq.14) THEN
     NBK=7
     MNBK=3
  ENDIF
  
  IF(PFTTYPE(1).eq.5.and.PFTTYPE(2).eq.7.and. &
       PFTTYPE(3).eq.8.and.PFTTYPE(4).eq.14) THEN
     NBK=6
     MNBK=3
  ENDIF
  
  RETURN
END SUBROUTINE OUTP




