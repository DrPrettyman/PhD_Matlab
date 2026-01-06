#!/bin/ksh
set -ex

# pre-processing for the model LPJ (9 PFTs)
#####################################
# creates the land sea mask, the glacial mask, calculates the desert fraction and groups the PFTs.
############################
# used PFTs
# 1. tropical broadleaved evergreen tree
# 2. tropical broadleaved raingreen tree
# 3. temperate needleleaved evergreen tree
# 4. temperate broadleaved evergreen tree
# 5. temperate broadleaved summergreen tree
# 6. boreal needleleaved evergreen tree
# 7. boreal broadleaved summergreen tree
# 8. C3 perennial grass
# 9. C4 perennial grass
################################# 
###############################	
# input data: pftfile, passed from the main program pfttobiome.ksh, must contain the PFT cover fraction
# ################################################################
##################################################################
### start programm ###
######################
# create Land Ice Mask (ice -> -2) and Land Sea Mask (land -> 1)	   
# calculates the desert fraction and prepares the PFT-file (both also contain the land ice (set to -4) )
	    
if [ "$icemask" != "no" ] ; then
    cdo -mulc,-2 -gtc,0 -timmean ${icemask} ${model}_${simid}_${timid}_glac_mask.nc
    cdo -chname,var1,lsm -gtc,0.1 -add -timmean ${icemask} -timmean -setmisstoc,0 -sellevel,0 ${pftfile} ${model}_${simid}_${timid}_slm.nc

    cdo -setrtoc,-200,-0.1,-4 -setctomiss,-100 -add ${model}_${simid}_${timid}_glac_mask.nc  -setmisstoc,-100 ${pftfile} ${model}_${simid}_${timid}_PFTfrac_org.nc
    cdo -setrtoc,-50,-0.1,-4 -yearmean -vertsum -sellevel,1,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc  ${model}_${simid}_${timid}_vegmax.nc
    cdo -setrtoc,1.5,30,-4 -chname,cover_fract,desert_fpc -addc,1 -mulc,-1 ${model}_${simid}_${timid}_vegmax.nc ${model}_${simid}_${timid}_DESfrac_org.nc

else
    cdo -chname,cover_fract,lsm -gtc,0 -setmisstoc,0 -addc,1 -timmean -sellevel,0 ${pftfile} ${model}_${simid}_${timid}_slm.nc
fi

#grouping PFTs in Mega-PFTs
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,1,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_FOREST.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_GRASS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,1,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_VEGCOV.nc
cdo -gtc,1000   ${model}_${simid}_${timid}_VEGCOV.nc ${model}_${simid}_${timid}_SHRUBS.nc
cdo -setrtoc,-20,-0.00001,-4 -vertsum -sellevel,1,2,3,4,5,6,7 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_WOODY.nc
cdo -setrtoc,-20,-0.00001,-4 ${model}_${simid}_${timid}_DESfrac_org.nc ${model}_${simid}_${timid}_DESfrac.nc
cdo -setrtoc,-20,-0.00001,-4 -sellevel,1,2,3,4,5,6,7,8,9 ${model}_${simid}_${timid}_PFTfrac_org.nc ${model}_${simid}_${timid}_PFTfrac.nc
################## end of pre-processing ###############################################################################################
###
