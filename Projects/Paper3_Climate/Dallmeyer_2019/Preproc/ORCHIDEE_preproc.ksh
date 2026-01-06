#!/bin/ksh
set -ex

# pre-processing for the model ORCHIDEE (PMIP3 version, 11 or 13 PFTs)
#####################################
# creates the land sea mask, the glacial mask, calculates the desert fraction and groups the PFTs.
# This sub-program handles output from the PMIP3 ORCHIDEE model
#####################################
# used PFTs:
# 1 bare soil
# 2 tropical broadleaved evergreen trees
# 3 tropical deciduous trees
# 4 temperate needleleaved trees
# 5 temperate broadleaved evergreen trees
# 6 temperate deciduous trees
# 7 boreal evergreen trees
# 8 boreal deciduous trees
# 10 C3 grass
# 11 C4 grass
# (12,13 land-use types (pasture and crop-lands))
#################################################
# input data: pftfile, passed from the main program pfttobiome.ksh, must contain the PFT cover fraction 
# ################################################################
##################################################################
### start programm ###
##########################

# create Land Ice Mask (ice -> -2) and Land Sea Mask (land -> 1)
if [ "$icemask" != "no" ] ; then
    cdo -chname,cover_fract,lsm -gtc,0 -add ${icemask} -setmisstoc,0 -addc,1 -timmean -sellevel,1 ${pftfile} ${model}_${simid}_${timid}_slm.nc
    cdo -mulc,-2 -gtc,0 -timmean ${icemask} ${model}_${simid}_${timid}_glac_mask.nc

    #calculates the desert fraction (file also contains the land ice (set to -4) ) and prepares the PFT-file
    cdo -setrtomiss,-20,-3 -add -mulc,-10 -ltc,0.5 ${model}_${simid}_${timid}_slm.nc -add ${model}_${simid}_${timid}_glac_mask.nc -timmean -setmisstoc,0 ${pftfile} ${model}_${simid}_${timid}_PFTfrac_org.nc

    cdo -setrtoc,1.5,30,-4 -chname,lsm,desert_fpc -setrtomiss,-20,-3 -add -mulc,-10 -ltc,0.5 ${model}_${simid}_${timid}_slm.nc -add ${model}_${simid}_${timid}_glac_mask.nc -timmean -setmisstoc,0 -setrtoc,-10,0,0 -sellevel,1 ${pftfile} ${model}_${simid}_${timid}_DESfrac_org.nc

else
	    
    cdo -chname,cover_fract,lsm -gtc,0 -setmisstoc,0 -addc,1 -timmean -sellevel,1 ${pftfile} ${model}_${simid}_${timid}_slm.nc
	    
fi

#grouping PFTs in Mega-PFTs, if Land Use is included (LU = 1), the fraction of the grid-cell covered by land-use is re-distributed to the other PFTs proportionally to their ratio of the total natural vegetation.
####
if [ "$LU" -eq "1" ] ; then
    cdo -setrtoc,-20,-0.00001,0 -vertsum -sellevel,12,13 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_LU.nc
    cdo -addc,1 -mulc,-1 ${model}_${simid}_${timid}_LU.nc Total_Veg.nc
    
    cdo -setrtoc,-20,-0.00001,-4 -div ${model}_${simid}_${timid}_DESfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_DESfrac.nc
    cdo -setrtoc,-20,-0.00001,-4 -div -sellevel,2,3,4,5,6,7,8,9,10,11 ${model}_${simid}_${timid}_PFTfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_PFTfrac.nc
else
    cdo -setrtoc,-20,-0.00001,-4 ${model}_${simid}_${timid}_DESfrac_org.nc ${model}_${simid}_${timid}_DESfrac.nc
    cdo -setrtoc,-20,-0.00001,-4 -sellevel,2,3,4,5,6,7,8,9,10,11 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_PFTfrac.nc
fi
	    
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_FOREST.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,10,11 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_GRASS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,2,3,4,5,6,7,8,9,10,11 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_VEGCOV.nc
cdo -gtc,1000   ${model}_${simid}_${timid}_VEGCOV.nc ${model}_${simid}_${timid}_SHRUBS.nc
cdo -setrtoc,-20,-0.00001,-4 -add ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_SHRUBS.nc ${model}_${simid}_${timid}_WOODY.nc

################## end of pre-processing ###############################################################################################
###

