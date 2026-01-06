#!/bin/ksh
set -ex

# pre-processing for the model VECODE (2 PFTs)
############################
# used PFTs
# ft = trees
# fg = grass
###############################	
# input data: pftfile, containig the forest and grass fraction
# ################################################################
##################################################################
### start programm ###
######################

# create Land Ice Mask (ice -> -2) and Land Sea Mask (land -> 1)
cdo -chname,ft,lsm -setmisstoc,0 -gec,0 -selvar,ft -timmean  ${pftfile} ${model}_${simid}_${timid}_slm.nc
cdo -mulc,-2 -chname,glfrac,lsm -gtc,0 -mul -gtc,0.5 ${icemask} ${model}_${simid}_${timid}_slm.nc ${model}_${simid}_${timid}_glac_mask.nc
cdo setctomiss,0 ${model}_${simid}_${timid}_slm.nc slm_miss.nc

# groups the PFT in Mega-PFTs, calculates the desert fraction and prepares the PFT-file (both also contain the land ice (set to -4) )
cdo -mul -setrtoc,-20,-0.00001,-4 -chname,ft,cover_fract -add -timmean -selvar,ft  ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc slm_miss.nc ${model}_${simid}_${timid}_FOREST.nc
cdo -mul -setrtoc,-20,-0.00001,-4 -chname,fg,cover_fract -add -timmean -selvar,fg  ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc slm_miss.nc ${model}_${simid}_${timid}_GRASS.nc

cdo -mul -setrtoc,-20,-0.00001,-4 -add ${model}_${simid}_${timid}_glac_mask.nc -timmean -selvar,ft,fg  ${pftfile} slm_miss.nc ${model}_${simid}_${timid}_PFTfrac.nc
cp ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_WOODY.nc
cdo -setrtoc,-20,-0.00001,-4 -add ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_GRASS.nc  ${model}_${simid}_${timid}_VEGCOV.nc
cdo -gtc,1000   ${model}_${simid}_${timid}_VEGCOV.nc ${model}_${simid}_${timid}_SHRUBS.nc
cdo setrtoc,2,10,-4 -chname,cover_fract,desert_fpc -setrtoc,-0.00001,0.00001,0 -addc,1 -mulc,-1  ${model}_${simid}_${timid}_VEGCOV.nc  ${model}_${simid}_${timid}_DESfrac.nc

rm slm_miss.nc

################## end of pre-processing ###############################################################################################
###
