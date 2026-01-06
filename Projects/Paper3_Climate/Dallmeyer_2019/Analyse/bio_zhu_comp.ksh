#!/bin/ksh

#script to regroup the Mega-biome distributions based on IPSL-ESM in T63, provided by D.Zhu (http://www.theses.fr/2016SACLV077), who has been using the biomisation method of Prentice et al. 2011
# and to compare the biome distribution with the distribution derived by the PFT-method introduced in this study.

set -ex

# regroup the biome distributions
cdo -setrtoc,8.5,9.5,7 -setrtoc,6.5,7.5,4 -setrtoc,3.5,4.5,6 -setrtoc,5.5,6.5,3 -setrtoc,2.5,3.5,5 -setrtoc,4.5,5.5,9 -setrtoc,7.5,9.5,8 IPSL_biomes_Prentice_method_PI.nc biome_zhu_method_PI.nc

cdo -setrtoc,8.5,9.5,7 -setrtoc,6.5,7.5,4 -setrtoc,3.5,4.5,6 -setrtoc,5.5,6.5,3 -setrtoc,2.5,3.5,5 -setrtoc,4.5,5.5,9 -setrtoc,7.5,9.5,8 IPSL_biomes_Prentice_method_LGM.nc biome_zhu_method_LGM.nc

# remap the biome distribution
# for PI
cdo outputf,%5.2f,180 -setrtoc,-0.1,0.1,10 -setmisstoc,0 -sellonlatbox,0,360,-90,90 biome_zhu_method_PI.nc > biome_zhu_method_PI.txt

gfortran remap_biomes_zhu_method.f90
./a.out

cdo -f nc input,t63grid  biome_zhu_method_PI_T63grid.nc < biome_zhu_method_PI_T63grid.txt

#### for LGM
cdo outputf,%5.2f,96 -setrtoc,-0.1,0.1,10 -setmisstoc,0 -sellonlatbox,0,360,-90,90 biome_zhu_method_LGM.nc > biome_zhu_method_LGM.txt

gfortran remap_biomes_zhu_method_LGM.f90
./a.out

cdo -f nc input,t63grid  biome_zhu_method_LGM_T63grid.nc < biome_zhu_method_LGM_T63grid.txt


# calculating the PI BNS against reconstructions after  adding the ice mask 
cdo -chname,var1,cover_fract -setrtoc,8.5,20,9 -add -mulc,9 -gtc,8.9 icet63.nc -setmisstoc,0 biome_zhu_method_PI_T63grid.nc  biome_zhu_method_PI_T63.nc

Rscript --vanilla poll_comp.r biome_zhu_method_PI_T63.nc biome6000new_0k.csv
mv score.csv  BNS_zhu_method_biomes_PI.csv
mv score_cat.csv BNS_cat_zhu_method_biomes_PI.csv

#### calculating the LGM BNS against reconstructions (without adding ice mask, not needed for LGM)
cdo -chname,var1,cover_fract -setmisstoc,0 biome_zhu_method_LGM_T63grid.nc biome_zhu_method_LGM_T63.nc
Rscript --vanilla poll_comp.r biome_zhu_method_LGM_T63.nc biome6000new_LGM.csv
mv score.csv  BNS_zhu_method_biomes_LGM.csv
mv score_cat.csv BNS_cat_zhu_method_biomes_LGM.csv

# calculating the PI FSS vs. RF99 potential vegetation
 cdo -setmisstoc,0 -mul potveg_t63_new_sav.nc -gtc,0.5 biome_zhu_method_PI_T63.nc reference_veg_T63_zhu_method_PI.nc

 cdo -chname,Biome,cover_fract -mul -setmisstoc,0  biome_zhu_method_PI_T63.nc -gtc,0.5 reference_veg_T63_zhu_method_PI.nc  biome_zhu_method_PI_T63.nc2

 Rscript --vanilla fss.r biome_zhu_method_PI_T63.nc2 reference_veg_T63_zhu_method_PI.nc

 mv score_fss.csv fss_zhu_method_PI_fss.csv


 #calculating kappa 
 cdo outputf,%5.1f,192 -setmisstoc,0 reference_veg_T63_zhu_method_PI.nc > reference_veg_T63_zhu_method_PI.txt
 cdo outputf,%5.1f,192 -mul -gtc,0.5 reference_veg_T63_zhu_method_PI.nc -setmisstoc,0 biome_zhu_method_PI_T63.nc  > biome_zhu_method_PI_T63.txt

nagfor -o kappa_T63zhu.x kappa_RF_t63.f90 	  
./kappa_T63zhu.x <<EOF

biome_zhu_method_PI_T63.txt 
reference_veg_T63_zhu_method_PI.txt
biome_zhu_method_PI_kappa_pft.txt
biome_zhu_method_PI_kappa_p.txt
zhu_method
EOF


###########################
#comparison with PFT method
#########################
cdo -setrtoc,-8.6,-0.1,1 -setrtoc,0.1,10,1 -sub biome_zhu_method_PI_T63.nc ./vegetation_ORCHIDEE_zhu2_PI/ORCHIDEE_zhu2_PI_biomePFT.nc biome_zhu_method-PFT.nc
cdo -setrtoc,-8.6,-0.1,1 -setrtoc,0.1,10,1 -sub biome_zhu_method_PI_T63.nc2 -setctomiss,0 reference_veg_T63_zhu_method_PI.nc  biome_zhu_method-RF.nc
cdo -setrtoc,-8.6,-0.1,1 -setrtoc,0.1,10,1 -sub ./vegetation_ORCHIDEE_zhu2_PI/ORCHIDEE_zhu2_PI_biomePFT.nc -setctomiss,0 ./vegetation_ORCHIDEE_zhu2_PI/reference_veg_t63_zhu2.nc biome_zhu_PFT-RF.nc

cdo -mulc,9 -gtc,8.5 vegetation_ORCHIDEE_zhu2_LGM/ORCHIDEE_zhu2_LGM_biomePFT.nc zhu_iceLGM.nc
cdo -setrtoc,8.5,30,9 -add biome_zhu_method_LGM_T63.nc zhu_iceLGM.nc biome_zhu_method_LGM_T63_ice.nc
cdo -setrtoc,-8.6,-0.1,1 -setrtoc,0.1,10,1 -sub biome_zhu_method_LGM_T63_ice.nc ./vegetation_ORCHIDEE_zhu2_LGM/ORCHIDEE_zhu2_LGM_biomePFT.nc biome_zhu_method-PFT_LGM.nc
###


