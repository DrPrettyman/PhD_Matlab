#!/bin/ksh
#set -ex
######################################
# calculates the zonal and global mean PFT-fractions (if pre-processing = 1)
# and the zonal mean biome fractions (Desert, Forest-Biomes, Grassland-Biomes, Woody Biomes (= Savanna + Forest), Tundra) for the pft-based (and climate-based) biomisation,
# and the reference dataset, if gridded (here RF99, requires palaeo = 0) 
#
#calculation requires zonmn = 1 in the main programm.
#
#output: ascii-files: ${model}_${simid}_${timid}_PFT_zonalmeans.txt
#                     ${model}_${simid}_${timid}_PFT_globmean.txt
#                     ${model}_${simid}_${timid}_bio1_zonalmeans.txt
#                     reference_veg_${igrid}_${simid}_zonalmeans.txt    
##############################################################################################################################

# a.) for PFTs

if [ "$preproc" -eq 1 ] ; then
    cdo -zonsum -mul -gridarea ${model}_${simid}_${timid}_VEGCOV.nc -gtc,-1000  ${model}_${simid}_${timid}_VEGCOV.nc  ${model}_${simid}_zon_area.nc
    cdo zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_PFTfrac.nc ${model}_${simid}_${timid}_PFTfrac_zm.nc

    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc  -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_DESfrac.nc ${model}_${simid}_${timid}_DESfrac_zm.nc 
    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_FOREST.nc ${model}_${simid}_${timid}_FOREST_zm.nc
    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_GRASS.nc  ${model}_${simid}_${timid}_GRASS_zm.nc
    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_SHRUBS.nc ${model}_${simid}_${timid}_SHRUBS_zm.nc
    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_WOODY.nc ${model}_${simid}_${timid}_WOODY_zm.nc
    cdo -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_VEGCOV.nc ${model}_${simid}_${timid}_VEGCOV_zm.nc

    cdo outputf,%10.4E ${model}_${simid}_${timid}_DESfrac_zm.nc > ${model}_${simid}_${timid}_DESfrac_zm.txt
    cdo outputf,%10.4E ${model}_${simid}_${timid}_FOREST_zm.nc > ${model}_${simid}_${timid}_FOREST_zm.txt
    cdo outputf,%10.4E ${model}_${simid}_${timid}_GRASS_zm.nc > ${model}_${simid}_${timid}_GRASS_zm.txt
    cdo outputf,%10.4E ${model}_${simid}_${timid}_SHRUBS_zm.nc > ${model}_${simid}_${timid}_SHRUBS_zm.txt
    cdo outputf,%10.4E ${model}_${simid}_${timid}_WOODY_zm.nc > ${model}_${simid}_${timid}_WOODY_zm.txt
    cdo outputf,%10.4E ${model}_${simid}_${timid}_VEGCOV_zm.nc > ${model}_${simid}_${timid}_VEGCOV_zm.txt

    if [ "$LU" -eq 1 ] ; then
	cdo -setmisstoc,0 -zonmean -setrtoc,-50,0,0 ${model}_${simid}_${timid}_LU.nc ${model}_${simid}_${timid}_LU_zm.nc 
	cdo outputf,%10.3F ${model}_${simid}_${timid}_LU_zm.nc > ${model}_${simid}_${timid}_LU_zm.txt
	
	echo 'Desert   Forest   Grass   Shrubs   Woody   Vegcov   LU' > ${model}_${simid}_${timid}_PFT_zonalmeans.txt
	paste ${model}_${simid}_${timid}_DESfrac_zm.txt ${model}_${simid}_${timid}_FOREST_zm.txt ${model}_${simid}_${timid}_GRASS_zm.txt ${model}_${simid}_${timid}_SHRUBS_zm.txt ${model}_${simid}_${timid}_WOODY_zm.txt ${model}_${simid}_${timid}_VEGCOV_zm.txt ${model}_${simid}_${timid}_LU_zm.txt >> ${model}_${simid}_${timid}_PFT_zonalmeans.txt

    else
	echo '    Desert         Forest            Grass            Shrubs            Woody             Vegcov' > ${model}_${simid}_${timid}_PFT_zonalmeans.txt
	paste ${model}_${simid}_${timid}_DESfrac_zm.txt ${model}_${simid}_${timid}_FOREST_zm.txt ${model}_${simid}_${timid}_GRASS_zm.txt ${model}_${simid}_${timid}_SHRUBS_zm.txt ${model}_${simid}_${timid}_WOODY_zm.txt ${model}_${simid}_${timid}_VEGCOV_zm.txt >> ${model}_${simid}_${timid}_PFT_zonalmeans.txt
    fi
    
    # rm ${model}_${simid}_${timid}_*_zm.txt

    echo 'global land area (total)' > ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_VEGCOV.nc -gtc,-1000  ${model}_${simid}_${timid}_VEGCOV.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'global land area (ice free)' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_VEGCOV.nc -gec,0 ${model}_${simid}_${timid}_VEGCOV.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt

    echo 'PFTs' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo -mul -gridarea ${model}_${simid}_${timid}_PFTfrac.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_PFTfrac.nc PFTglob.nc
    cdo output -fldsum PFTglob.nc >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'Desert' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_DESfrac.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_DESfrac.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'Forest' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_FOREST.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_FOREST.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'Grass' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_GRASS.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_GRASS.nc    >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'Shrubs' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_SHRUBS.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_SHRUBS.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'Woody' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_WOODY.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_WOODY.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    echo 'tot.nat.Veg' >> ${model}_${simid}_${timid}_PFT_globmean.txt
    cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_VEGCOV.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_VEGCOV.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    
    if [ "$LU" -eq 1 ] ; then
	echo 'land Use' >> ${model}_${simid}_${timid}_PFT_globmean.txt
	cdo output -fldsum -mul -gridarea ${model}_${simid}_${timid}_LU.nc -setrtoc,-50,0,0 ${model}_${simid}_${timid}_LU.nc  >> ${model}_${simid}_${timid}_PFT_globmean.txt
    fi
fi
######################################################################################################################

# b.) for biomes, PFT-based biomisation and climate-based biomisation (if biome1=1)

# PFT-based
cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,0.5,9.5,1 -setrtoc,0,6.5,0 -setrtoc,7.5,8.5,0 -setctomiss,0 ${model}_${simid}_${timid}_biomePFT.nc > ${model}_${simid}_${timid}_biome_desert_zm.txt
cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,4.5 -setctomiss,0  ${model}_${simid}_${timid}_biomePFT.nc > ${model}_${simid}_${timid}_biome_forest_zm.txt
cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,5.5 -setrtoc,6.5,20,0 -setctomiss,0  ${model}_${simid}_${timid}_biomePFT.nc > ${model}_${simid}_${timid}_biome_grass_zm.txt
cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,5.5 -setctomiss,0  ${model}_${simid}_${timid}_biomePFT.nc > ${model}_${simid}_${timid}_biome_wood_zm.txt
cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,7.5 -setrtoc,8.5,20,0 -setctomiss,0  ${model}_${simid}_${timid}_biomePFT.nc > ${model}_${simid}_${timid}_biome_tundra_zm.txt

echo 'Desert   Forest   Grass   Woody   Tundra ' > ${model}_${simid}_${timid}_biome_zonalmeans.txt
paste ${model}_${simid}_${timid}_biome_desert_zm.txt ${model}_${simid}_${timid}_biome_forest_zm.txt ${model}_${simid}_${timid}_biome_grass_zm.txt ${model}_${simid}_${timid}_biome_wood_zm.txt ${model}_${simid}_${timid}_biome_tundra_zm.txt >> ${model}_${simid}_${timid}_biome_zonalmeans.txt

### climate-based
if [ "$biome1" -eq 1 ] ; then
    
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,0.5,9.5,1 -setrtoc,0,6.5,0 -setrtoc,7.5,8.5,0 -setctomiss,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1_desert_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,4.5 -setctomiss,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1_forest_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,5.5 -setrtoc,6.5,20,0 -setctomiss,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1_grass_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,5.5 -setctomiss,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1_wood_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,7.5 -setrtoc,8.5,20,0 -setctomiss,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1_tundra_zm.txt
    
    echo 'Desert   Forest   Grass   Woody   Tundra ' > ${model}_${simid}_${timid}_bio1_zonalmeans.txt
	
    paste ${model}_${simid}_${timid}_bio1_desert_zm.txt ${model}_${simid}_${timid}_bio1_forest_zm.txt ${model}_${simid}_${timid}_bio1_grass_zm.txt ${model}_${simid}_${timid}_bio1_wood_zm.txt ${model}_${simid}_${timid}_bio1_tundra_zm.txt >> ${model}_${simid}_${timid}_bio1_zonalmeans.txt

fi


#### reference
if [ "$palaeo" -eq 0 ] ; then
   
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -setrtoc,0.5,9.5,1 -setrtoc,0,6.5,0 -setrtoc,7.5,8.5,0 -setctomiss,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}_desert_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,4.5 -setctomiss,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}_forest_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,5.5 -setrtoc,6.5,20,0 -setctomiss,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}_grass_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -ltc,5.5 -setctomiss,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}_wood_zm.txt
    cdo -outputf,%10.4E -setmisstoc,0 -mul ${model}_${simid}_zon_area.nc -zonmean -gtc,7.5 -setrtoc,8.5,20,0 -setctomiss,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}_tundra_zm.txt
    
    echo 'Desert   Forest   Grass   Woody   Tundra ' > reference_veg_${igrid}_${simid}_zonalmeans.txt
	
    paste reference_veg_${igrid}_${simid}_desert_zm.txt reference_veg_${igrid}_${simid}_forest_zm.txt reference_veg_${igrid}_${simid}_grass_zm.txt reference_veg_${igrid}_${simid}_wood_zm.txt reference_veg_${igrid}_${simid}_tundra_zm.txt >> reference_veg_${igrid}_${simid}_zonalmeans.txt


fi
    
#clean up
#
rm -f *_zm.txt
rm PFTglob.nc
######
