#!/bin/ksh
#set -ex
######################################
# compiles and runs kappa.f90
# that calculates the kappa metric for the pft-based biomisation and climate-based biomisation (if biome1 = 1) compared to the (gridded) reference (here RF99) via Fortran90  (kappa.f90) 
# calculation requires kappa = 1 and palaeo = 0 in the main programm.
# output: ${model}_${simid}_${timid}_kappa_pft.txt (detailed metric, kappa and weighted kappa)
#         ${model}_${simid}_${timid}_kappa.txt  (list of all kappa per mega-biome (1-9) and in total (10),
#                                                including pft-based and climate based (if biome=1) kappas  
##############################################################################################################################

# prepraring the data -> writing the biome distributions into txt-files
     
case ${igrid} in
    "10deg")
       
	cdo outputf,%5.1f,36 -setmisstoc,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}.txt
	cdo outputf,%5.1f,36 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -sellonlatbox,0,360,-90,90 -setmisstoc,0 ${model}_${simid}_${timid}_biomePFT.nc  > ${model}_${simid}_${timid}_biomePFT.txt
	
	if [ "$biome1" -eq 1 ] ; then
	    cdo outputf,%5.1f,36 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -sellonlatbox,0,360,-90,90 -setmisstoc,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1.txt
	fi

	x=36
	y=18
	;;
    
    "t31")
	cdo outputf,%5.1f,96 -setmisstoc,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}.txt
	cdo outputf,%5.1f,96 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -setmisstoc,0 ${model}_${simid}_${timid}_biomePFT.nc  > ${model}_${simid}_${timid}_biomePFT.txt
	if [ "$biome1" -eq 1 ] ; then
	    cdo outputf,%5.1f,96 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -setmisstoc,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1.txt
	fi

	x=96
	y=48
	;;
    
    "t63")
	cdo outputf,%5.1f,192 -setmisstoc,0 reference_veg_${igrid}_${simid}.nc > reference_veg_${igrid}_${simid}.txt
	cdo outputf,%5.1f,192 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -setmisstoc,0 ${model}_${simid}_${timid}_biomePFT.nc  > ${model}_${simid}_${timid}_biomePFT.txt
	if [ "$biome1" -eq 1 ] ; then
	    cdo outputf,%5.1f,192 -mul -gtc,0.5 reference_veg_${igrid}_${simid}.nc -setmisstoc,0 -selvar,Mega-Biomes ${model}_${simid}_${timid}_bio1out.nc > ${model}_${simid}_${timid}_bio1.txt
	fi

	x=192
	y=96
	;;
esac

# compiling and running the programm

gfortran -o kappa.x ./../Programs/kappa.f90
./kappa.x <<EOF

${model}_${simid}_${timid}_biomePFT.txt
reference_veg_${igrid}_${simid}.txt
${model}_${simid}_${timid}_kappa_pft.txt
${model}_${simid}_${timid}_kappa_p.txt
${model}
${x} ${y}
EOF

if [ "$biome1" -eq 1 ] ; then
    ./kappa.x <<EOF
${model}_${simid}_${timid}_bio1.txt
reference_veg_${igrid}_${simid}.txt
${model}_${simid}_${timid}_kappa_clim.txt
${model}_${simid}_${timid}_kappa_pc.txt
${model}
${x} ${y}

EOF
              
    paste ./../biome_list.txt ${model}_${simid}_${timid}_kappa_p.txt  ${model}_${simid}_${timid}_kappa_pc.txt >> ${model}_${simid}_${timid}_kappa.txt
    rm -f ${model}_${simid}_${timid}_kappa_p.txt ${model}_${simid}_${timid}_kappa_pc.txt

else
    paste ./../biome_list.txt  ${model}_${simid}_${timid}_kappa_p.txt ./../Kappa_CRU_TS4_PI_clim_T63.csv ${model}_${simid}_${timid}_kappa.txt
    rm -f ${model}_${simid}_${timid}_kappa_p.txt
fi       

################# end ##########
