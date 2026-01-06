#!/bin/ksh
#set -ex
###################################################################################################################################################################################
# This is a shell script for calculating mega-biome distributions from plant functional type (PFT) distributions simulated by Earth System Models (ESM).                         
# As input data, climatological monthly mean 2m-temperature and climatological annual mean growing degree days distributions (GDD) on the basis of 5°C and 0°C,
#     and the respective multi-year mean PFT cover fractions are needed.
#     When using the Biome1 model, a forcing file with the following variables is required: 2m-temperature [K], precipitation [mm/s], total cloud cover [fraction between 0-1],
#      the Biome model can also be used to calculate the growing degree days distributions. We additionally provide a reduced BIOME1 model that only requires the monthly mean temperatures 
#      and that can be used to calculate the growing degree days.
#
# The tool works for the vegetation models JSBACH, TRIFFID, ORCHIDEE, LPJ, SEIB, and VECODE. Other models have not been included.
#
# Please notice that this biomisation tool was tested on individual simulations using PFT cover fractions that may deviate from other simulations in the same models (e.g. LPJ). 
# Please look in the pre-processing file of the model you use, if the PFT types agree with those included in this study. Otherwise, you can easily modify the pre-processing script
###################################################################################################################################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A detailed description of the methods and the simulations used and the evaluation of this method can be found in:
# Dallmeyer, A., Claussen, M. and Brovkin, V.: Harmonizing plant functional type distributions for evaluating Earth System Models, CP, 2018
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#############################################################################################################################################
# This tool can be used for free and can be further distributed, as long as the original source is properly cited !!!
# Please mark any changes you make on the model code !!!
#--------------------------------------------------------------------------------------------------------------------------------------------
#
# This Tool requires the following programs
# a) climate data operators (CDO), developed by the Max-Planck-Institute for Meteorology, available at: https://code.mpimet.mpg.de/projects/cdo
# b) Biome1 model by Prentice et al. 1992 (optional), which is included in this package, also in reduced model
# c) R (optional for calculating and plotting metrics): R Core Team (2014). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.
#    URL http://www.R-project.org/ , including the follwing packages:
#    'lattice' -> Sarkar, Deepayan (2008) Lattice: Multivariate Data Visualization with R. Springer, New York. ISBN 978-0-387-75968-5
#    'ncdf4' -> David Pierce (2014). ncdf4: Interface to Unidata netCDF (version 4 or earlier) format data files. R package version 1.13. http://CRAN.R-project.org/package=ncdf4
#    'irr' -> Gamer M, Fellows J, Lemon I, Singh P (2012) PAckage “irr”. Various Coefficients of Interrater Reliability and Agreement, http://www.r-project.org
#    'plotrix' -> Lemon, J. (2006) Plotrix: a package in the red light district of R. R-News, 6(4): 8-12. 
# d) Generic Mapping Tool (GMT, optional for plotting): Wessel, P., W. H. F. Smith, R. Scharroo, J. Luis, and F. Wobbe, Generic Mapping Tools:
#    Improved Version Released, EOS Trans. AGU, 94(45), p. 409-410, 2013. doi:10.1002/2013EO450001. see: https://www.soest.hawaii.edu/gmt/
# e) A Fortran compiler and the netCDF C and Fortran development libraries.
#    This script is set up for the NAG or gcc (gfortran) compilers (set variable "compiler" below
#    to choose which one to use). On a Debian or Ubuntu Linux system, the gcc Fortran compiler
#    can be installed with:
#        sudo apt-get install gfortran
#    Both the C and Fortran interfaces for the netCDF libraries are required (libnetcdf resp. 
#    libnetcdff). On Debian or Ubuntu Linux systems, these can be installed with:
#       sudo apt-get install libnetcdf-dev libnetcdff-dev
#    which installs the include files in /usr/include and the libraries in /usr/lib. If you install
#    to a non-standard location, you can adapt these locations below (INCLUDE_F, LIB_C and LIB_F).
#---------------------------------------------------------------------------------------------------------------------------------------------
#
################################################################################################################################################################################
################################################################################################################################################################################
###############################################################################################################################################################################
#########################################################
#
# user setup (has to be modified for each simulation !!!
#**********************************************************
#
# Model: choose JSBACH, TRIFFID, ORCHIDEE, LPJ, SEIB, VECODE, or JSBACHC (for cmorized JSBACH output)
export model="JSBACH"

# inputdata  
export climfile="mkl_pi_biome1_input.nc"               # = forcing file for BIOME1 or the 2m-Temperature (if BIOME1 is not used)
export gddfile="no"                                    # = file with GDD5 and GDD0 distribution, only needed if BIOME1 is not used (biome1=0) or the GDDcalculator is not used (gddcalc=0)
export pftfile="mkl_pi_veg_JSBACH.nc"                  # = file containing the PFT distribution
export icemask="no"                                    # = land-ice mask, if not included in the PFT distribution (e.g. ORCHIDEE and VECODE), otherwise choose "no"

# simulation 
export simid="mkl"                                   # = ID of the simulations (e.g. r1i1p1)
export LU=0                                             # = Land use switch (=1 if Land use is included and = 0 otherwise)
export inpol=0                                          # = Must be set to 1 if data needs to be interpolated. The tool can only work with the resolution T31, T63 and a regular 10° grid,
                                                        # Any other resolution must be interpolated to one of these three grids 
export igrid=t31                                        # resolution of the model (t31, t63, 10deg) or the desired resolution after interpolation

export preproc=1                                        # = Must be set to 1 if pre-processing of the PFT data is required, we strongly recommend to use this program

# time-slice information (choose: timid = PI and palaeo = 0, or 6k or LGM and palaeo = 1)
export timid="PI"
export palaeo=0

# reference data for the vegetation
# (choose: "RF" for Ramankutty and Foley 1999 (modern gridded pot. nat. vegetation, or "biome6000" for BIOME6000 reconstructions (Harrison, 2017))
export bioref="RF"

# additional  analysis and plots
export biome1=1        # set to 1 to also run the Biome1 model, 0 otherwise
export gddcalc=0       # set to 1 to run the GDD calculator instead of the Biome1 model, 0 otherwise
export plot=1          # set to 1 to create spatial biome distribution plots using GMT, 0 otherwise
export zonmn=1         # set to 1 to calculate zonal mean PFT and biome fractions, 0 otherwise
export kappa=1         # set to 1 to calculate kappa (only for gridded references) using Fortran90 (includes netcdf!), 0 otherwise
export metric=1        # set to 1 to calculate the FSS or BNS metric (using R), 0 otherwise
#
# Configuration of compiler and netCDF library
compiler=gcc               # gcc (for gfortran) or nag
LIB_C='/usr/lib'           # Location of netCDF C library (libnetcdf)
INCLUDE_F='/usr/include'   # Location of netCDF Fortran include file (netcdf.inc)
LIB_F='/usr/lib'           # Location of netCDF Fortran library (libnetcdff)
#
#--------------------------------------------------------------------------------------------------------------------------------------
# end of user setup
#************************************************************
#########################################################################################################################################
####################################
####################################
####     START PROGRAM    ##########
#######################################################
####################################

#create output folder
mkdir vegetation_${model}_${simid}_${timid}
cd vegetation_${model}_${simid}_${timid}
# ---------------------------------------------

# data preparation
# i.e. renaming variables, grid interpolation, copying working files in the output folder
#########################################################################################

var="`cdo showvar ./../$climfile`"

for a in ${var}; do
    echo ${a}
    case ${a} in
	pr|precip|prec|p|pre|var4|prc|Rainf)
	    cdo chname,${a},precip -selvar,${a} ./../${climfile} ${climfile}_p
	    ;;
	ts|tas|temp|temp2|var167|Tair|tmp)
	    cdo chname,${a},temp2 -selvar,${a} ./../${climfile} ${climfile}_t
	    ;;
	clt|cloud|aclcov|var164|cld)
	    cdo chname,${a},aclcov  -selvar,${a} ./../${climfile} ${climfile}_c
	    ;;
    esac
    
done
cdo merge ${climfile}_? ${climfile}

rm -f ${climfile}_?

if    [ "$model" == "VECODE" ]  ; then
      cdo splitvar ${climfile} ${model}.
      cdo addc,273.15 ${model}.temp2.nc ${model}.temp2_K
      cdo divc,86400 ${model}.precip.nc ${model}.pr_F
      cdo merge ${model}.pr_F ${model}.temp2_K ${model}.aclcov.nc ${climfile}
      rm -f  ${model}.temp2_K ${model}.pr_F ${model}.aclcov.nc ${model}.precip.nc  ${model}.temp2.nc
      
fi

###
var="`cdo showvar ./../$pftfile`"
for a in ${var}; do
    case ${a} in
	var12|landCoverFrac|pft|cfpc|FRAC|fpc)
	    cdo -timmean -chname,${a},cover_fract  ./../${pftfile} ${pftfile}
	    ;;
	ft|cover_fract)
	    cdo -timmean ./../${pftfile} ${pftfile}
	    ;;
    esac
done

################### interpolation to grid given in $igrid

if [ "$inpol" -eq 1 ] ; then
    echo 'interpolation to:' $igrid
    cp ${pftfile} ${pftfile}.org
    cp ${climfile} ${climfile}.org
      
    cdo remapbil,${igrid}grid ${pftfile}.org ${pftfile}
    cdo remapbil,${igrid}grid ${climfile}.org ${climfile}
  
    if [ "$icemask" != "no" ] ; then
	cp ./../${icemask} ${icemask}.org
	cdo remapbil,${igrid}grid ${icemask}.org ${icemask}
    fi

    if  [ "$biome1" -eq 0 -a "$gddcalc" -eq 0] ; then
	cp ./../${gddfile} ${gddfile}.org
	cdo remapbil,${igrid}grid ${gddfile}.org ${gddfile}
    fi
else
    if  [ "$icemask" != "no" ] ; then
    	cp ./../${icemask} ${icemask}
    fi
fi

# preparation for individual models, i.e. creating land sea mask and glacial mask, grouping of PFTs, and calculating the desert fraction
# by the subprogram ${model}_preproc.ksh
# output: ${model}_${simid}_${timid}_slm.nc
#         ${model}_${simid}_${timid}_DESfrac.nc
#         ${model}_${simid}_${timid}_PFTfrac.nc
#         ${model}_${simid}_${timid}_FOREST.nc
#         ${model}_${simid}_${timid}_SHRUBS.nc
#         ${model}_${simid}_${timid}_GRASS.nc
#         ${model}_${simid}_${timid}_VEGCOV.nc
#         ${model}_${simid}_${timid}_WOODY.nc

./../Preproc/${model}_preproc.ksh

########################################################################################################################################
# BIOMISATION 
###############################
#######################################

#1. BIOME1, calculation of the Bioclimate and Biomes (climate based)
####################################################################

 case ${compiler} in
 nag) WLFLAG='-Wl,-Wl,'
      FFLAGS='-w=unused'
      FC=nagfor
      ;;
 gcc) WLFLAG='-Wl'
      FFLAGS=
      FC=gfortran
      ;;
 esac
 LIB_F="-L${LIB_F} ${WLFLAG},-rpath ${WLFLAG},${LIB_F}"
 LIB_C="-L${LIB_C} ${WLFLAG},-rpath ${WLFLAG},${LIB_C}"

 if [ "$biome1" -eq 1 ] ; then
    echo 'biome distribution and bioclimate calculation by BIOME1'

    echo 'compiling BIOME1'

    ${FC} -o biome1.x ${FFLAGS} -I${INCLUDE_F} ./../biome1_nc_pfttobio.f90 ${LIB_F} -lnetcdff ${LIB_C} -lnetcdf
    ./biome1.x <<EOF

$climfile
${model}_${simid}_${timid}_bio1out.nc
${model}_${simid}_${timid}_slm.nc
EOF

 elif [ "$gddcalc" -eq 1 ] ; then
    echo 'calculating GDDs'

    ${FC} -o gddcalc.x ${FFLAGS} -I${INCLUDE_F} ./GDD_calc.f90 ${LIB_F} -lnetcdff ${LIB_C} -lnetcdf
    ./gddcalc.x <<EOF

$climfile
${model}_${simid}_${timid}_bio1out.nc
${model}_${simid}_${timid}_slm.nc
EOF

 else	  
      echo 'no biome1 calulation'
 fi

# 2. BIOME4-based PFT biomisation, partly  model dependant
#    GDD5 needed as input data,  (could either be provided in an extra file (gdd5) or from BIOME1 or GDD_calc calculation)
#######################################################################################################

 if [ "$biome1" -eq 0 -a "$gddcalc" -eq 0] ; then
	 cp ${gddfile} ${model}_${simid}_${timid}_bio1out.nc
 fi

 # preparing the climate variables needed
 cdo -subc,273.15 -ymonmean -selvar,temp2 ${climfile} clim
 cdo mul -setctomiss,0 ${model}_${simid}_${timid}_slm.nc clim T2m.nc
 rm clim

 cdo -selvar,GDD5 ${model}_${simid}_${timid}_bio1out.nc GDD5.nc
 cdo -selvar,GDD0 ${model}_${simid}_${timid}_bio1out.nc GDD0.nc

 ##### create masks for regions with dominant vegetation type
 cdo gt ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_GRASS.nc for_gt_gra_mask.nc
 cdo gt ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_DESfrac.nc for_gt_des_mask.nc
 cdo gtc,1.5 -add for_gt_gra_mask.nc for_gt_des_mask.nc for_dom.nc
 
 cdo gt ${model}_${simid}_${timid}_WOODY.nc ${model}_${simid}_${timid}_GRASS.nc wood_gt_gra_mask.nc
 cdo gt ${model}_${simid}_${timid}_WOODY.nc ${model}_${simid}_${timid}_DESfrac.nc wood_gt_des_mask.nc
 cdo gtc,1.5 -add wood_gt_gra_mask.nc wood_gt_des_mask.nc wood_dom.nc
 
 rm for_gt_gra_mask.nc for_gt_des_mask.nc wood_gt_gra_mask.nc wood_gt_des_mask.nc
 
 ##### create vegetation masks (> 50% mix-vegetation and mask for wood presence (>25%)
 cdo gec,0.5  ${model}_${simid}_${timid}_VEGCOV.nc mix_veg_mask.nc
 cdo -gec,0.25 ${model}_${simid}_${timid}_WOODY.nc treepres_mask.nc
 
 #### create GDD5- and temperature-masks to define climate region
 # (boreal (> 350°C and < 900°C); temperate (> 900°C & < 3000°C); warm_mixed (>3000°C); tropical (Tmin > 15.5°C)
 # savanna (>1200°C and Tc > 10°C); tundra (GDD0 < 800°C) )
 
 cdo -gtc,900 GDD5.nc GDD5_900_mask.nc
 cdo -lec,900 GDD5.nc GDD5_l900_mask.nc
 cdo -gec,3000 GDD5.nc GDD5_3000_mask.nc
 cdo -ltc,3000 GDD5.nc GDD5_l3000_mask.nc
 cdo -gec,1200 GDD5.nc GDD5_1200_mask.nc
 cdo gtc,350 GDD5.nc GDD5_350_mask.nc
 cdo gec,800 GDD0.nc GDD0_800_mask.nc
 cdo ltc,800 GDD0.nc GDD0_l800_mask.nc
 cdo gtc,15.5 -timmin T2m.nc T15_mask.nc
 cdo lec,15.5 -timmin T2m.nc Tl15_mask.nc
 cdo -gtc,10 -timmin T2m.nc Tcm_10_mask.nc
 
 # model dependant preparation
 ###################################
 case ${model} in
     "JSBACH")
	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,1,2,3,4 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,1,2,3,4,5,6 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 
	 # split forest into tropical,temperate and boreal forest/wood PFTs
	 cdo vertsum -sellevel,1,2 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo mul GDD5_900_mask.nc -vertsum -sellevel,3,4,5 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
	 cdo mul GDD5_900_mask.nc -vertsum -sellevel,3,4 for_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo mul GDD5_l900_mask.nc -vertsum -sellevel,3,4,5,6 wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "JSBACHC")
	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,2,3,4,5 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo vertsum -sellevel,2,3 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo mul GDD5_900_mask.nc -vertsum -sellevel,4,5,6 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
	 cdo mul GDD5_900_mask.nc -vertsum -sellevel,4,5 for_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo mul GDD5_l900_mask.nc -vertsum -sellevel,4,5,6,7 wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "TRIFFID")
	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,1,2 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,1,2,5 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo -chname,temp2,cover_fract -mul T15_mask.nc -vertsum -sellevel,1,2 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo -chname,GDD5,cover_fract -mul Tl15_mask.nc -mul GDD5_900_mask.nc -mul GDD5_350_mask.nc -vertsum -sellevel,1,2,5 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
	 cdo -chname,GDD5,cover_fract -mul Tl15_mask.nc -mul GDD5_900_mask.nc -mul GDD5_350_mask.nc -vertsum -sellevel,1,2 wood_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo -chname,GDD5,cover_fract -mul GDD5_l900_mask.nc -mul GDD5_350_mask.nc -vertsum -sellevel,1,2,5 wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "ORCHIDEE")
	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 cdo gt -vertsum -sellevel,4,5,6 for_PFT.nc -vertsum -sellevel,7,8,9 for_PFT.nc temp_gt_bor.nc 
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo vertsum -sellevel,2,3 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,4,5,6 wood_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,4,5,6 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
         cdo -mul -addc,1 -mulc,-1 temp_gt_bor.nc -vertsum -sellevel,7,8,9  wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "SEIB")
 	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,1,2,3,4,5 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,1,2,3,4,5 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 cdo gt -vertsum -sellevel,2,3 for_PFT.nc -vertsum -sellevel,4,5 for_PFT.nc temp_gt_bor.nc 
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo vertsum -sellevel,1 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,2,3 wood_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,2,3 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
         cdo -mul -addc,1 -mulc,-1 temp_gt_bor.nc -vertsum -sellevel,4,5  wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "VECODE")
	 # create PFT files including dominance
	 cdo mul for_dom.nc ${model}_${simid}_${timid}_FOREST.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc ${model}_${simid}_${timid}_FOREST.nc wood_PFT.nc
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo -chname,temp2,cover_fract -mul T15_mask.nc for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo -chname,GDD5,cover_fract -mul Tl15_mask.nc -mul GDD5_900_mask.nc wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
	 cdo -chname,GDD5,cover_fract -mul Tl15_mask.nc -mul GDD5_900_mask.nc for_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo -chname,GDD5,cover_fract -mul GDD5_l900_mask.nc wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
     
     "LPJ")
	 # create PFT files including dominance
	 cdo mul for_dom.nc -sellevel,1,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac.nc for_PFT.nc
	 cdo gtc,1.5 -add treepres_mask.nc mix_veg_mask.nc woodveg_mask.nc
	 cdo mul woodveg_mask.nc -sellevel,1,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac.nc wood_PFT.nc
	 cdo gt -vertsum -sellevel,3,4,5 for_PFT.nc -vertsum -sellevel,6,7 for_PFT.nc temp_gt_bor.nc 
	 
	 # split forest into tropical,temperate and boreal forest PFTs
	 cdo vertsum -sellevel,1,2 for_PFT.nc ${model}_${simid}_${timid}_trop_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,3,4,5 wood_PFT.nc ${model}_${simid}_${timid}_temp_for.nc
	 cdo -mul temp_gt_bor.nc -vertsum -sellevel,3,4,5 wood_PFT.nc ${model}_${simid}_${timid}_temp_wood.nc
         cdo -mul -addc,1 -mulc,-1 temp_gt_bor.nc -vertsum -sellevel,6,7  wood_PFT.nc ${model}_${simid}_${timid}_bor_for.nc
	 
	 ;;
 esac
 
####################################################
  # start of biomisation
############################
 #
 #  FORESTS 
 #------------------
 # 1.) tropical forest
 cdo gtc,0.01 ${model}_${simid}_${timid}_trop_for.nc biome01.nc
 
 # 2.) warm.mixed.forest
 cdo -mulc,2 -gtc,0.01 -mul GDD5_3000_mask.nc ${model}_${simid}_${timid}_temp_for.nc biome02.nc
 
 # 3.) temperate forest
 cdo -mulc,3 -gtc,0.01 -mul GDD5_l3000_mask.nc ${model}_${simid}_${timid}_temp_wood.nc biome03.nc
 
 # 4.) boreal forest
 cdo mulc,4 -gtc,0.01  ${model}_${simid}_${timid}_bor_for.nc biome04.nc
 
 ##### sum of all forest biomes
 cdo gtc,0.5 -add biome01.nc -add biome02.nc -add biome03.nc biome04.nc ${model}_${simid}_${timid}_biome_forest.nc 
 ###############
 
 # 5.) Savanna and dry woodland, including temp.savanna (biome05_temp)
 cdo -gtc,1.5 -add treepres_mask.nc GDD5_1200_mask.nc sav_mask.nc
 cdo -gtc,0.5 -sub sav_mask.nc ${model}_${simid}_${timid}_biome_forest.nc savwofor_mask.nc
 cdo -gtc,1.5 -add Tcm_10_mask.nc savwofor_mask.nc savanna.nc
 cdo mulc,5 savanna.nc biome05.nc
 
 #### sum of woody biomes
 cdo gtc,0.5 -add ${model}_${simid}_${timid}_biome_forest.nc biome05.nc ${model}_${simid}_${timid}_biome_wood.nc
 #######################
 
 # 6.) grassland and dry shrubland
 cdo gtc,0.5 -sub GDD0_800_mask.nc ${model}_${simid}_${timid}_biome_wood.nc grass_mask.nc
 cdo gtc,0.2 ${model}_${simid}_${timid}_VEGCOV.nc veg_mask.nc
 cdo gtc,1.5 -add grass_mask.nc veg_mask.nc ${model}_${simid}_${timid}_biome_grass.nc
 cdo mulc,6 ${model}_${simid}_${timid}_biome_grass.nc biome06.nc
 
 ### sum of all forest, Savanna and grassland biomes
 cdo -gtc,0.5 -add ${model}_${simid}_${timid}_biome_wood.nc biome06.nc biowarm.nc 
 ###
 
 # 8.) tundra
 cdo gtc,0.1 ${model}_${simid}_${timid}_VEGCOV.nc veg_mask.nc
 cdo sub veg_mask.nc -gtc,0.5 biowarm.nc tun_mask.nc
 cdo gtc,1.5 -add GDD0_l800_mask.nc tun_mask.nc ${model}_${simid}_${timid}_biome_tundra.nc
 cdo mulc,8 ${model}_${simid}_${timid}_biome_tundra.nc biome08.nc
 
 #### sum of grassland and tundra biomes
 cdo -gtc,0.5 -add biome06.nc biome08.nc biome_grastun.nc
 #########################################################
 
 # 7.) desert
 cdo -lec,0.2 ${model}_${simid}_${timid}_VEGCOV.nc des_mask.nc
 cdo gec,0.5 -add ${model}_${simid}_${timid}_biome_wood.nc biome_grastun.nc bioveg_mask.nc
 cdo -gec,0.5 -sub des_mask.nc bioveg_mask.nc ${model}_${simid}_${timid}_biome_desert.nc
 
 cdo -gtc,2 -timmean T2m.nc T_frost.nc #seperates polar and hot desert
 
 cdo -gec,0  ${model}_${simid}_${timid}_DESfrac.nc poldes_mask.nc
 
 cdo mulc,7 -gtc,2.5 -add poldes_mask.nc -add ${model}_${simid}_${timid}_biome_desert.nc T_frost.nc biome07.nc
 cdo mulc,9 -gtc,0.5 -sub ${model}_${simid}_${timid}_biome_desert.nc biome07.nc biome09.nc
 
 #### total biomes #####
 cdo -chname,lsm,cover_fract -add biome01.nc -add biome02.nc -add biome03.nc -add biome04.nc -add biome05.nc -add biome06.nc -add biome07.nc -add biome08.nc biome09.nc ${model}_${simid}_${timid}_biomePFT.nc
 #################################
 
 ###clean up
 rm -f T2m.nc GDD5.nc GDD0.nc GDD*mask.nc T*mask.nc
 rm -f for*mask.nc wood*mask.nc gra*mask.nc mix*mask.nc tree*mask.nc *_dom.nc poldes_mask.nc
 rm -f for_PFT.nc wood_PFT.nc
 rm -f biome??.nc biome05_*.nc
 rm -f T_frost.nc  bioveg_mask.nc des_mask.nc tundra.nc tun_mask.nc Tcm_10_mask.nc
 rm -f savanna.nc sav*.nc veg_mask.nc biowarm.nc biome_grastun.nc 

##################################################################################
###  end of biomisation #############
##################################################################################
#############################

 
######################################################################################
# additional analysis (optional)
 #######################################################################################
 
case ${bioref} in
    "RF")
	cdo -setmisstoc,0 -mul ./../PotVeg/RF_potveg_${igrid}.nc -sellonlatbox,0,360,-90,90 ${model}_${simid}_${timid}_slm.nc reference_veg_${igrid}_${simid}.nc
	      ;; 
esac

 ##############################
 # a) calculating kappa for gridded data via Fortran programs (./../kappa_${bioref}_${igrid}.f90)
 #      output: ${model}_${simid}_${timid}_kappa_pft.txt (detailed metric, kappa and weighted kappa)
 #              ${model}_${simid}_${timid}_kappa.txt (list of all kappa per mega-biome (1-9) and in total (10)

if [ "$kappa" -eq 1 -a "$palaeo" -eq 0 ] ; then
    ./../Programs/run_kappa.ksh 
else
    echo 'kappa is not calculated'
fi

 #-------------------------------------------------------------------------------------------
 # b) calculating the zonal mean biome and PFT fractions (if preproc = 1) by the subprogram zonmean.ksh
 #    requires the PFTfractions grouped into Mega-PFTs (e.g. calculated by the pre-processing sub-programm)
 #    output: ascii-files: ${model}_${simid}_${timid}_PFT_zonalmeans.txt
 #                         ${model}_${simid}_${timid}_PFT_globmean.txt
 #                         ${model}_${simid}_${timid}_bio1_zonalmeans.txt
 #                         reference_veg_${igrid}_${simid}_zonalmeans.txt  
 
 if [ "$zonmn" -eq 1 ] ; then
     ./../Programs/zonmean.ksh
 else
     echo 'zonal means are not calculated'
 fi

# ---------------------------------------------------------------------------------------------     
# c) calculating additional metrics: FSS (for gridded data) or BNS (for site-based data) metric
#    requires R and specific libraries (see programs fss.r and poll_comp.r
#    output

if [ "$metric" -eq 1 ] ; then
    
    ./../Programs/run_metric.ksh
else
    echo 'further metrics are not calculated' 
fi
     
#------------------------------------
# d) plotting using GMT and R
#
#  output:
#  ${model}_${simid}_${timid}_biomePFT_${region}.pdf            (displaying PFT-based and climate-based biomisation (if biome1=1))
#  ${model}_${simid}_${timid}_biome_reference_${region}.pdf     (displaying the reference biome distribution (if palaeo = 0)) 
#  ${model}_${simid}_${timid}_biomePFT_recs_${region}.pdf       (displaying the biome distribution and the records on top  (if palaeo = 1))
#  ${model}_${simid}_${timid}_bio_agreement_${region}.pdf       (displaying the agreement (BNS) between all sites and the calculated biome distribution (if palaeo = 1 and metric = 1))
#  ${model}_${simid}_${timid}_PFT_MAIN_${region}.pdf            (displaying the main PFT distribution (if preproc = 1))
#  ${model}_${simid}_${timid}_fss.pdf                           (dotplot showing all FSS, if data is gridded)
#  ${model}_${simid}_${timid}_kappa.pdf                         (dotplot showing individual kappa, if data is gridded)
#  ${model}_${simid}_${timid}_bns.pdf                           (dotplot showing all BNS, here only if palaeo = 1)
#  ${model}_${simid}_${timid}_zm_PFT.pdf                        (zonal mean PFT fractions)
#  ${model}_${simid}_${timid}_zm_biomes.pdf                     (zonal mean biome fractions)
#  ${model}_${simid}_${timid}_taylorPlot_zm.pdf                 (Taylor plot for the zonal mean biome fractions)
#  ${model}_${simid}_${timid}_stats.txt                         (List with the data used for the Taylor Plot (normalized centered RMSE, normalized  standard deviation,
#                                                                  Pearson correlation coefficient)
#---------------------------------
if [ "$plot" -eq 1 ] ; then
    
    ./../Programs/plot.ksh
else
    echo 'no plotting' 
fi

exit

#################################################################################################
################# end of program ###################################
#################################################################################################
