#!/bin/ksh
set -ex

# pre-processing for the model JSBACH (8 or 11 PFTs)
#####################################
# creates the land sea mask, the glacial mask, calculates the desert fraction  and groups the PFTs.
# This sub-program handles already cmorized output from the JSBACH model, i.e. the PFT cover fraction have already been scaled by the total vegetation fraction. 
#####################################
# used PFTs:
# 1 tropical evergreen trees
# 2 tropical deciduous trees
# 3 extra-tropical evergreen trees
# 4 extra-tropical deciduous trees
# 5 raingreen shrubs
# 6 cold-tolerant shrubs
# 7 C3 grass
# 8 C4 grass
# (9,10,11 land-use types (pasture and crop-lands))
#################################################
# input data: pftfile, passed from the main program pfttobiome.ksh, must contain the PFT cover fraction (code 12) and veg_ratio_max (code 20)
# ################################################################
##################################################################
### start programm ###
######################

# create Land Ice Mask (ice -> -2) and Land Sea Mask (land -> 1)
cdo -mulc,-2 -gec,1 -sellevel,1 -timmean ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc
cdo -chname,cover_fract,lsm  -gtc,0 -setmisstoc,0 -addc,1 -sellevel,1 -timmean  ${pftfile} ${model}_${simid}_${timid}_slm.nc

#sel variables: code 12: PFT cover fraction, code 20 veg ratio max
cdo  -setrtoc,1.5,30,-4 -add ${model}_${simid}_${timid}_glac_mask.nc -timmean  -divc,100 ${pftfile} ${model}_${simid}_${timid}_PFTfrac.nc
cdo -chname,cover_fract,veg_ratio_max -add -vertsum -sellevel,2,3,4,5,6,7,8,9,10,11,12,13 -divc,100 ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc ${model}_${simid}_${timid}_vegmax.nc
	
#calculates the desert fraction (file also contains the land ice (set to -4) )
cdo -setrtoc,1.5,30,-4 -chname,veg_ratio_max,desert_fpc -addc,1 -mulc,-1 ${model}_${simid}_${timid}_vegmax.nc ${model}_${simid}_${timid}_DESfrac.nc

rm ${model}_${simid}_${timid}_vegmax.nc 
	
#grouping PFTs in Mega-PFTs, if Land Use is included (LU = 1), the fraction of the grid-cell covered by land-use is re-distributed to the other PFTs proportionally to their ratio of the total natural vegetation.

if [ "$LU" -eq "1" ] ; then
    cdo -setrtoc,-20,-0.00001,0 -vertsum -sellevel,10,11,12,13 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_LU.nc
    mv  ${model}_${simid}_${timid}_DESfrac.nc  ${model}_${simid}_${timid}_DESfrac_org.nc
    mv  ${model}_${simid}_${timid}_PFTfrac.nc  ${model}_${simid}_${timid}_PFTfrac_org.nc 

    cdo -addc,1 -mulc,-1 ${model}_${simid}_${timid}_LU.nc Total_Veg.nc
    
    cdo -setrtoc,-20,-0.00001,-4 -div ${model}_${simid}_${timid}_DESfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_DESfrac.nc
    cdo -setrtoc,-20,-0.00001,-4 -div -sellevel,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_PFTfrac.nc
fi

cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,2,3,4,5 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_FOREST.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,6,7 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_SHRUBS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,8,9 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_GRASS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_VEGCOV.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_WOODY.nc

################## end of pre-processing ###############################################################################################
###
