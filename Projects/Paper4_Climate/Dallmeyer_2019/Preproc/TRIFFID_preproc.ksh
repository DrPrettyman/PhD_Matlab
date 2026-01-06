#!/bin/ksh
set -ex

# pre-processing for the model TRIFFID (PMIP3 version, 9 PFTs)
#####################################
# creates the land sea mask, the glacial mask, calculates the desert fraction and groups the PFTs.
# This sub-program handles output from the PMIP3 model version of TRIFFID.
# The fraction of inland water and urban area is treated like land use in other models and is therefore proportionally redistributed to the other PFTs) 
#####################################
# used PFTs:
# 1 = "broadleaf trees"
# 2 = "needleleaf trees"
# 3 = "C3 (temperate) grass"
# 4 = "C4 (tropical) grass"
# 5 = "shrubs"
# 6 = "urban"
# 7 =  "inland water"
# 8 = "bare soil"
# 9 =  "ice" 
###############################	
# input data: pftfile, passed from the main program pfttobiome.ksh, must contain the PFT cover_fract
#################################################################
##################################################################
### start programm ###
######################

# create Land Ice Mask (ice -> -2) and Land Sea Mask (land -> 1)
cdo -mulc,-2 -gec,1 -timmean -sellevel,9 ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc
cdo -chname,cover_fract,lsm -gtc,0 -setmisstoc,0 -addc,1 -timmean -sellevel,1 ${pftfile} ${model}_${simid}_${timid}_slm.nc

#calculates the PFT-fractions and the desert fraction, both also contain the land ice (set to -4)
cdo -setrtoc,1.5,30,-4 -add ${model}_${simid}_${timid}_glac_mask.nc -timmean -divc,100 ${pftfile} ${model}_${simid}_${timid}_PFTfrac_org.nc
cdo -setrtoc,1.5,30,-4 -chname,cover_fract,desert_fpc -add -sellevel,8 -divc,100 -timmean ${pftfile} ${model}_${simid}_${timid}_glac_mask.nc ${model}_${simid}_${timid}_DESfrac_org.nc
	
#grouping PFTs in Mega-PFTs, if Land Use is included (LU = 1), the fraction of the grid-cell covered by land-use is re-distributed to the other PFTs proportionally to their ratio of the total natural vegetation.

if [ "$LU" -eq "1" ] ; then
    cdo -setrtoc,-20,-0.00001,0 -vertsum -sellevel,6,7 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_LU.nc
    
    cdo -addc,1 -mulc,-1 ${model}_${simid}_${timid}_LU.nc Total_Veg.nc

    cdo -setrtoc,-20,-0.00001,-4 -div ${model}_${simid}_${timid}_DESfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_DESfrac.nc
    cdo -setrtoc,-20,-0.00001,-4 -div -sellevel,1,2,3,4,5 ${model}_${simid}_${timid}_PFTfrac_org.nc Total_Veg.nc ${model}_${simid}_${timid}_PFTfrac.nc
else	    
    cdo -setrtoc,-20,-0.00001,-4 ${model}_${simid}_${timid}_DESfrac_org.nc ${model}_${simid}_${timid}_DESfrac.nc  
    cdo -setrtoc,-20,-0.00001,-4 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_PFTfrac.nc
fi
	
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,1,2  ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_FOREST.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,5 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_SHRUBS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,3,4 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_GRASS.nc	
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,1,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_VEGCOV.nc
cdo -setrtoc,-20,-0.00001,-4 -add ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_SHRUBS.nc ${model}_${simid}_${timid}_WOODY.nc

################## end of pre-processing ###############################################################################################
###

    
