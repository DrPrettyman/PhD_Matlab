#!/bin/ksh
set -ex
# script to perform the sensitivity experiments with BIOME1, by varying the input dataset. In the original Cru TS4.0 dataset, either the precipiation or the temperature field is replaced by the repective data from individual ESM simulations.
# Please notice, that for some files the latitudes may have to be inverted

climfile="climate_MPI_cmip5_pi_ym.nc"
slmfile="JSBACHC_r1i1p1_PI_slm.nc"
biofile="JSBACHC_r1i1p1_PI_bio1out.nc"
climfold="vegetation_JSBACHC_r1i1p1_PI"
res="t63grid"

# preparing the data (remapping, change names of the variables,...)
cp ./${climfold}/${slmfile} .
#cdo remapbil,${res} $climfile ${climfile}_${res}
var="`cdo showvar $climfile`"

for a in ${var}; do
    echo ${a}
    case ${a} in
	pr|precip|prec|p|pre|var4|prc|Rainf)
	    cdo chname,${a},precip  -selvar,${a} ${climfile}_${res} ${climfile}_p
	    	    ;;
	ts|tas|temp|temp2|var167|Tair|tmp)
	    cdo chname,${a},temp2  -selvar,${a} ${climfile}_${res} ${climfile}_t
	    	    ;;
	clt|cloud|aclcov|var164|cld)
	    cdo chname,${a},aclcov  -selvar,${a} ${climfile}_${res} ${climfile}_c
	    ;;
    esac
    
done

cdo -remapbil,${res} Cru_climate.nc Cru_climat_${res}
cdo -setmissval,NaN  -chname,temp2,lsm -mul -setmisstoc,0 -gtc,-0.1 -selvar,temp2 Cru_climat_${res} ${slmfile} slmmask.nc

cdo splitvar Cru_climat_${res} Cru_
cdo merge Cru_temp2.nc Cru_aclcov.nc  ${climfile}_p  ${climfile}_bio_p
cdo merge Cru_aclcov.nc Cru_precip.nc  ${climfile}_t  ${climfile}_bio_t

rm  ${climfile}_?

#  compile and run the model for the different input datasets.
nagfor -o biome1.x biome1_nc_pfttobio.f90 -L/usr/lib -lnetcdff -lnetcdf
    ./biome1.x <<EOF

Cru_climat_${res}
Cru_biomout_${res}
slmmask.nc
EOF

./biome1.x <<EOF

${climfile}_bio_p
${climfile}_bioout_p
slmmask.nc
EOF

    ./biome1.x <<EOF

${climfile}_bio_t
${climfile}_bioout_t
slmmask.nc
EOF

#calculating the effect of temperature and precipitation biases
    
    cdo -setctomiss,0 -sub ${climfile}_bioout_p Cru_biomout_${res} ${climfile}_p_effect.nc
    cdo -setctomiss,0 -sub ${climfile}_bioout_t Cru_biomout_${res} ${climfile}_t_effect.nc

    cdo -setctomiss,0 -sub -mul -gtc,0.5 -selvar,Mega-Biomes Cru_biomout_${res}  -invertlat ./${climfold}/${biofile} Cru_biomout_${res} ${climfile}_bio-CRU

    cdo -setmisstoc,0 -mulc,1 -setrtoc,-10,10,1 -selvar,Mega-Biomes ${climfile}_p_effect.nc p
    cdo -setmisstoc,0 -mulc,2 -setrtoc,-10,10,1 -selvar,Mega-Biomes ${climfile}_t_effect.nc t
    cdo add p t ${climfile}_clim_sens.nc


    cdo sub -setrtoc,-10,10,1 -selvar,Mega-Biomes ${climfile}_bio-CRU  -gtc,0.5 ${climfile}_clim_sens.nc bio-Cru-sens.nc
    cdo -add -mulc,3 -gtc,0.5 bio-Cru-sens.nc ${climfile}_clim_sens.nc ${climfile}_clim_sens_all.nc

   
    rm p t
#   rm ${climfile}_bioout_p ${climfile}_bioout_t bio-Cru-sens.nc

