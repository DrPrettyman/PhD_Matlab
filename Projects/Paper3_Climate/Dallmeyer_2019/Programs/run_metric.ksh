#!/bin/ksh
#set -ex
#################################################
# runs the R scripts fss.r (for gridded data) or bns.r (for site-based data)
# requires the R libraries 'ncdf4' and 'irr'
# output: ${model}_${simid}_${timid}_fss.txt
#      or ${model}_${simid}_${timid}_bns.txt
#################################

# for gridded data (here: the PI biomisation vs RF99 reference, palaeo = 0), FSS is calculated, for site-based data (palaeo = 1) the BNS is calculated. If no Biome1 simulation exist (biome1=0), the BNS or FSS values for CRUTS4 T63 climate biomisation by BIOME1 are taken as reference. Please notice, that these values are plotted in the BNS and FSS and Kappa dotplot

if [ "$palaeo" -eq 0 ] ; then

cdo -mul -setmisstoc,0 -sellonlatbox,0,360,-90,90 ${model}_${simid}_${timid}_biomePFT.nc -gtc,0.5 reference_veg_${igrid}_${simid}.nc ${model}_${simid}_${timid}_biomePFT2.nc
cdo setmisstoc,0 reference_veg_${igrid}_${simid}.nc reference_veg_${igrid}_${simid}2.nc

Rscript --vanilla ./../Programs/fss.r ${model}_${simid}_${timid}_biomePFT2.nc  reference_veg_${igrid}_${simid}2.nc
mv score_fss.csv  score_PFT_fss.csv

    if [ "$biome1" -eq 1 ] ; then

	cdo -mul -chname,Mega-Biomes,cover_fract -sellonlatbox,0,360,-90,90 -setmisstoc,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc -gtc,0.5 reference_veg_${igrid}_${simid}.nc ${model}_${simid}_${timid}_biomeClim.nc

	Rscript --vanilla ./../Programs/fss.r ${model}_${simid}_${timid}_biomeClim.nc  reference_veg_${igrid}_${simid}2.nc
	mv score_fss.csv  score_Cli_fss.csv

	echo 'Nr   Biome      Fss_PFT        FSSran_PFT      FSSuni_PFT        rFSS_PFT        Fss_Cli        FSSran_Cli       FSSuni_Cli      rFSS_Cli ' > ${model}_${simid}_${timid}_fss.txt
	paste ./../biome_list.txt score_PFT_fss.csv score_Cli_fss.csv  >> ${model}_${simid}_${timid}_fss.txt

	rm reference_veg_${igrid}_${simid}2.nc ${model}_${simid}_${timid}_biomePFT2.nc ${model}_${simid}_${timid}_biomeClim.nc score_PFT_fss.csv score_Cli_fss.csv 
    else
	echo 'Nr   Biome      Fss_PFT        FSSran_PFT      FSSuni_PFT        rFSS_PFT        Fss_Cli        FSSran_Cli       FSSuni_Cli      rFSS_Cli ' > ${model}_${simid}_${timid}_fss.txt
	paste ./../biome_list.txt score_PFT_fss.csv  ./../score_fss_CruTS4_T63.csv >> ${model}_${simid}_${timid}_fss.txt 

	rm reference_veg_${igrid}_${simid}2.nc ${model}_${simid}_${timid}_biomePFT2.nc score_PFT_fss.csv 
    fi

else 
    cdo -setmisstoc,0 ${model}_${simid}_${timid}_biomePFT.nc ${model}_${simid}_${timid}_biomePFT.nc2
    pwd
    Rscript --vanilla ./../Programs/bns.r ${model}_${simid}_${timid}_biomePFT.nc2 ./../records/biome6000new_${timid}.csv
    mv score.csv score_${model}_${simid}_${timid}_PFT.csv
    mv score_cat.csv score_cat_${model}_${simid}_${timid}_PFT.csv
    rm ${model}_${simid}_${timid}_biomePFT.nc2
    
    if [ "$biome1" -eq 1 ] ; then
	cdo -chname,Mega-Biomes,cover_fract -setmisstoc,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc ${model}_${simid}_${timid}_biomeClim.nc

	Rscript --vanilla ./../Programs/bns.r ${model}_${simid}_${timid}_biomeClim.nc ./../records/biome6000new_${timid}.csv
	mv score.csv score_${model}_${simid}_${timid}_Clim.csv
	mv score_cat.csv score_cat_${model}_${simid}_${timid}_Clim.csv
	rm ${model}_${simid}_${timid}_biomeClim.nc

	echo 'Nr   Biome      Score_PFT                 Score_Cli ' > ${model}_${simid}_${timid}_bns.txt
	paste ./../biome_list.txt  score_cat_${model}_${simid}_${timid}_PFT.csv  score_cat_${model}_${simid}_${timid}_Clim.csv >> ${model}_${simid}_${timid}_bns.txt
    else
	echo 'Nr   Biome      Score_PFT                 Score_Cli ' > ${model}_${simid}_${timid}_bns.txt
	paste ./../biome_list.txt  score_cat_${model}_${simid}_${timid}_PFT.csv ./../BNS_CRU_TS4_PI_clim_T63.csv >> ${model}_${simid}_${timid}_bns.txt
    fi
fi

############################ end metric #######################
