  ! Fortran script to calculate the growing degree days on the basis of 5°C and 0°C and the mean temperature of the coldest and warmest month by using monthly mean temperature data as input.
  ! This programm is based on the BIOME1 model by Prentice et al.1992 (Prentice, I.C., Cramer, W., Harrison, S.P., Leemans, R., Monserud, R.A., and Solomon, A.M.:
  !     A global biome model based on plant physiology and dominance, soil properties and climate. J. Biogeogr., 19, 117-134., 1992.)
  ! modified by A. Dallmeyer 2018 to read netcdf-files and to handle transient simulations (without memory effect from one year to another).
  ! We reduced the programm to the relevant sub routines (daily and stemp and xtemp)
!####################################################################################################
  
 ! start program
! #############################

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

   INTEGER, ALLOCATABLE, DIMENSION(:)  ::  NDIMLEN1,NDIMLENL
   CHARACTER(LEN=30), ALLOCATABLE, DIMENSION(:)  ::  FDIMNAM1,FDIMNAML

 ! variables
   INTEGER  ::  NIN1(100),NIN2(100)
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARTYP1,NVARTYPL
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARDIM1,NVARDIML
   INTEGER, ALLOCATABLE, DIMENSION(:,:)  :: NVARDIMID1,NVARDIMIDL
   INTEGER, ALLOCATABLE, DIMENSION(:)  :: NVARATT1,NVARATTL
   INTEGER :: COLDID,WARMID,GDD0ID,GDD5ID
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
   REAL, DIMENSION(12) :: MTC
   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: TT, TT2
   REAL, ALLOCATABLE, DIMENSION(:) :: RLON,RLAT
   REAL, ALLOCATABLE, DIMENSION(:,:) :: WATC
   REAL, ALLOCATABLE, DIMENSION(:,:,:) :: GDD0,GDD5, COLD, WARM
   REAL, ALLOCATABLE, DIMENSION (:,:) :: LSMASK
   REAL, ALLOCATABLE, DIMENSION (:,:) :: YCOLD,YWARM,YGDD0,YGDD5
   INTEGER :: NLAT,NLON,NYEARS,LONID,LATID,YEARID,LOVARID,LAVARID,TIVARID,TISTAR
   INTEGER :: DIMIDS(3)

! Dimensions of output file
   DOUBLE PRECISION, ALLOCATABLE, DIMENSION (:) ::  LATS, LONS, TIMES, TIMESN
!indices  
  INTEGER  :: NTYPES,MON,LO,LA,NBK,K,I,II,M,J,NVAR_TT,NVAR_LL,NVAR_LA,NVAR_TI,YEAR


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
    WRITE(*,*) 'hier'
     WRITE (*,*) I,FVARNAM1(I),NVARDIM1(I)
   END DO

!get variable
   J=0
   DO I=1,NVAR1
      WRITE (*,*) I
      IF (FVARNAM1(I) == 'temp2') THEN
         NVAR_TT=I
         ALLOCATE (TT(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         ALLOCATE (TT2(NDIMLEN1(NVARDIMID1(I,1)),NDIMLEN1(NVARDIMID1(I,2)),NDIMLEN1(NVARDIMID1(I,3))))
         CALL check_err( nf_get_var_real(NCID1,I,TT) )
         J=J+1
      ELSE IF (FVARNAM1(I) == 'x') THEN
          NVAR_LL=I
          ALLOCATE (LONS(NDIMLEN1(NVARDIMID1(I,1))))
          CALL check_err( nf_get_var_double(NCID1,I,LONS) )
          J=J+1
           WRITE (*,*) 'read lon'
       ELSE IF (FVARNAM1(I) == 'y') THEN
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
      ELSE IF (FVARNAM1(I) .NE. 'xt' .AND. FVARNAM1(I) .NE. 'yt' .AND. FVARNAM1(I) .NE. 'time') THEN 
         WRITE(*,*) 'ERROR: Variables not found' 
      END IF
      WRITE (*,*) J
   END DO

   WRITE (*,*) 'finish reading'

  

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
        IF (FDIMNAML(I) .NE. FDIMNAM1(I) .OR. NDIMLENL(I) .NE. NDIMLEN1(I)) THEN
        WRITE(*,*) 'ERROR: Climate variables and land-sea mask have different dimensions (lon)'
        END IF
     ELSE IF (FDIMNAML(I) == 'lat') THEN
        IF (FDIMNAML(I) .NE. FDIMNAM1(I) .OR. NDIMLENL(I) .NE. NDIMLEN1(I)) THEN
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
           
           ALLOCATE (LSMASK(NDIMLENL(NVARDIMIDL(I,1)),NDIMLENL(NVARDIMIDL(I,2))))
           CALL check_err( nf_get_var_real(NCIDLSM,I,LSMASK) )
         J=J+1
      ELSE IF (FVARNAML(I) == 'lon' ) THEN
         ALLOCATE (RLON(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_real(NCIDLSM,I,RLON) )
         ALLOCATE (LONS(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_double(NCIDLSM,I,LONS) )
         WRITE (*,*) 'read lon'
     
             
      ELSE IF (FVARNAML(I) == 'lat' ) THEN
         ALLOCATE (RLAT(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_real(NCIDLSM,I,RLAT) )
         ALLOCATE (LATS(NDIMLENL(NVARDIMIDL(I,1))))
         CALL check_err( nf_get_var_double(NCIDLSM,I,LATS) )
         WRITE (*,*) 'read lat'

         
      END IF  
   END DO
   IF (J < 1) THEN
         WRITE(*,*) 'land sea mask missing '
         WRITE(*,*) 'stop program'
         stop
   END IF

!close input file
  CALL check_err( nf_close(NCIDLSM) )
 WRITE (*,*)


!###################################################################################################
!++++++++++++++++++++++++   MAIN PROGRAM   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!###################################################################################################
WRITE (*,*) '*  *  *  *   START   MAIN   PROGRAM  *  *   *   *'
!###################################################################################################

   NLON = NDIMLEN1(1)
   NLAT = NDIMLEN1(2)
   NYEARS = (NDIMLEN1(3)/12)
 
   ALLOCATE (GDD0(NLON,NLAT,NYEARS))
   ALLOCATE (GDD5(NLON,NLAT,NYEARS))
   ALLOCATE (COLD(NLON,NLAT,NYEARS))
   ALLOCATE (WARM(NLON,NLAT,NYEARS))
   ALLOCATE (WATC(NLON,NLAT))
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
 !        PRINT*, 'LO,LA :', RLON(LO),RLAT(LA), LO, LA
              IF (LSMASK(LO,LA) < 0.5) THEN
                 COLD(LO,LA,YEAR)=-9999
                 WARM(LO,LA,YEAR)=-9999
                 GDD0(LO,LA,YEAR)=-9999
                 GDD5(LO,LA,YEAR)=-9999
                ELSE
              WATC(LO,LA)=WATC(LO,LA)*1000.
                 DO MON = 1,12
                    M = K-1+MON
                    MTC(MON)=TT(LO,LA,M)-273.16
                   END DO
!              WRITE (*,*) 'call STEMP'
             CALL STEMP(MTC,YGDD0(LO,LA),YGDD5(LO,LA),YCOLD(LO,LA),YWARM(LO,LA))
              COLD(LO,LA,YEAR)=YCOLD(LO,LA)
              WARM(LO,LA,YEAR)=YWARM(LO,LA)
              GDD0(LO,LA,YEAR)=YGDD0(LO,LA)
              GDD5(LO,LA,YEAR)=YGDD5(LO,LA)
              ENDIF
           END DO
   
        END DO
     END DO


!creating time-axis
DO J = 1,NYEARS

   TIMESN(J)=TISTAR-1+J

END DO

!WRITE (*,*) TIMESN     
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
WRITE (*,*) 'define vars'

  DIMIDS = (/ LONID, LATID, YEARID /)


   CALL check_err( nf_def_var(NCID2,'Tcold',NF_REAL,3,DIMIDS(1),COLDID) )

   CALL check_err( nf_def_var(NCID2,'Twarm',NF_REAL,3,DIMIDS(1),WARMID) )

   CALL check_err( nf_def_var(NCID2,'GDD0',NF_REAL,3,DIMIDS(1),GDD0ID) )

   CALL check_err( nf_def_var(NCID2,'GDD5',NF_REAL,3,DIMIDS(1),GDD5ID) )

   WRITE (*,*) 'define units'
   
   ! units
    CALL check_err( nf_put_att_text(NCID2, COLDID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, WARMID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, GDD0ID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )
    CALL check_err( nf_put_att_text(NCID2, GDD5ID, UNITS, LEN(TEMP_UNITS), TEMP_UNITS) )

  CALL check_err( nf_enddef(NCID2) ) 
    WRITE (*,*) 'output'
    ! write output   


  write (*,*) LATS
  write (*,*) LONS
   CALL check_err( nf_put_var(NCID2, LAVARID, LATS) )
   CALL check_err( nf_put_var(NCID2, LOVARID, LONS) )
   CALL check_err( nf_put_var(NCID2, TIVARID, TIMESN) )

   CALL check_err( nf_put_var_real(NCID2,COLDID,COLD) )
   CALL check_err( nf_put_var_real(NCID2,WARMID,WARM) )
   CALL check_err( nf_put_var_real(NCID2,GDD0ID,GDD0) )
   CALL check_err( nf_put_var_real(NCID2,GDD5ID,GDD5) )

   

   CALL check_err( nf_close(NCID2) )


  WRITE (*,*)  'ENDE GUT,ALLES GUT? '

END program

!***************************************************************************
!äääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääää
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
!***************************************************************************
!---------------------------------------------------------------------------
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

SUBROUTINE STEMP(MTC,YGDD0,YGDD5,YCOLD,YWARM)

  REAL :: GDD0,GDD5,COLD,WARM
  REAL :: MTC(12)

  CALL XTEMP(MTC,YGDD0,YGDD5,YCOLD,YWARM)

  RETURN
END SUBROUTINE STEMP

!---------------------------------------------------------------------------
!***************************************************************************
!---------------------------------------------------------------------------






