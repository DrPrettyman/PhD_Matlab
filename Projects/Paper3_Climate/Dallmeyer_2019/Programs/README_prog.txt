List of all subprograms used by the Biomisation-Tool:
*****************************************************
run_kappa.ksh
------------------
! korn shell script that compiles and runs the kappa.f90 Program for calculating the kappa metric
! for the pft-based biomisation and climate-based biomisation (if biome1 = 1) compared to the (gridded) reference (here RF99) 
! calculation requires kappa = 1 and palaeo = 0 in the main programm.
! output: ${model}_${simid}_${timid}_kappa_pft.txt (detailed metric, kappa and weighted kappa)
!         ${model}_${simid}_${timid}_kappa.txt  (list of all kappa per mega-biome (1-9) and in total (10),  including pft-based and climate based (if biome=1) kappas
#################
kappa.f90 (is called by run_kappa.sh
------------------
! Fortran90 program that calculates the kappa metric and a weighted kappa metric for gridded biome distributions and the reference 
! can be compiled by gfortran -o kappa.x kappa.f90
! input: text-files containing the reference (BIOME_RF) and the pft-based or climate-based biome distribution (BIOME4) are needed.
! output: ${model}_${simid}_${timid}_kappa_pft.txt (detailed metric, kappa and weighted kappa)
!         ${model}_${simid}_${timid}_kappa_p.txt (list of all kappa per mega-biome (1-9) and in total (10)
##################
run_metric.ksh
------------------
! korn shell script that runs the R script fss.r (for gridded data) or the R script bns.r (for site-based data), for calculating the FSS or BNS metric
! calculation requires metric=1, and palaeo = 0 (for fss.r) or palaeo = 1 (for bns.r)
! output: text files containing the individual FSS or BNS (see scripts fss.r and bns.r
##################
fss.r (called by run_metric.ksh):
--------
- R program for calculating the fractional skill score metric (FSS)
- uses the R libraries ncdf4 and irr
- input: gridded biome distributions for the model (args[1]) and the reference (args[2])
- output: text-file (score_fss.csv) containing table of the FSS metrics including FSS, random FSS, uniform FSS and relative FSS for each of the individual biomes (column 1-9) and in total (column 10)
  	  in addition this table is printed in the console, followed by the unweighted (total) kappa
#################
bns.r (called by run_metric.ksh):
--------------
- R program for calulating the best neighbor score metric (BNS)
- uses the R libraries ncdf4 and irr
- input: gridded biome distribution for the modell (args[1]) and site-based biome reconstructions (args[2]) in form of an ascii-table (with header, and 'lon', 'lat', 'value' as columns)
- output: text-file (score.csv) containing a table of the BNS metrics for each site (lon, lat, total BNS)
          text-file (score_cat.csv) containing a list of the total BNS for each individual biome (10 columns, columns 1-9 individual biomes, column 10 total BNS
	  in addition the main statistic is printed to the console, including the total unweighted kappa
#################
zonmean.ksh
---------------
- korn shell script for calculating the zonal and global mean PFT-fractions (if pre-processing = 1),
  the zonal mean biome fractions (Desert, Forest-Biomes, Grassland-Biomes, Woody Biomes (= Savanna + Forest), Tundra), for the pft-based (and climate-based) biomisation,
  and the reference dataset, if gridded (here RF99, requires palaeo = 0) 
- calculation requires zonmn = 1 in the main programm.
- input: netCDF-files of the main PFT-types and of the biome distributions
- output: ascii-files: ${model}_${simid}_${timid}_PFT_zonalmeans.txt
                      ${model}_${simid}_${timid}_PFT_globmean.txt
                      ${model}_${simid}_${timid}_bio1_zonalmeans.txt
                      reference_veg_${igrid}_${simid}_zonalmeans.txt  
##################
plot.ksh
- korn shell script for creating global plots of the mega biome distribution (PFT-based and the climate-based biomisation (if biome1=1 in the main program) and the reference). 
-     if palaeo = 0, a gridded map of the Reference (here RF99) is plotted,
-     for palaeo data, the biomes reconstructed at the individual sites are plotted as dots on the calculated biome distribution.
-     The colortables used in the GMT plot scripts are provided in the folder GMTadd
-     The PFT-distributions are plotted, if preproc=1 in the main program
- script also runs the R scripts plot_BNS.r (if palaeo=1) or plot_metric (if palaeo=0) and zon_mean_plot.r (if zonmn=1)
     
- requires plot=1 in the main program
- output:     ${model}_${simid}_${timid}_biomePFT_${region}.pdf            (displaying PFT-based and climate-based biomisation (if biome1=1))
              ${model}_${simid}_${timid}_biome_reference_${region}.pdf     (displaying the reference biome distribution (if palaeo = 0)) 
              ${model}_${simid}_${timid}_biomePFT_recs_${region}.pdf       (displaying the biome distribution and the records on top  (if palaeo = 1))
              ${model}_${simid}_${timid}_bio_agreement_${region}.pdf       (displaying the agreement (BNS) between all sites and the calculated biome distribution (if palaeo = 1 and metric = 1))
              ${model}_${simid}_${timid}_PFT_MAIN_${region}.pdf            (displaying the main PFT distribution (if preproc = 1))
	      ${model}_${simid}_${timid}_fss.pdf                           (dotplot showing all FSS, if data is gridded)
              ${model}_${simid}_${timid}_kappa.pdf                         (dotplot showing individual kappa, if data is gridded)
              ${model}_${simid}_${timid}_bns.pdf                           (dotplot showing all BNS, here only if palaeo = 1)
              ${model}_${simid}_${timid}_zm_PFT.pdf                        (zonal mean PFT fractions)
              ${model}_${simid}_${timid}_zm_biomes.pdf                     (zonal mean biome fractions)
	      ${model}_${simid}_${timid}_taylorPlot_zm.pdf                 (Taylor plot for the zonal mean biome fractions)
              ${model}_${simid}_${timid}_stats.txt                         (List with the data used for the Taylor Plot (normalized centered RMSE, normalized  standard deviation,
                                                                             Pearson correlation coefficient)
#################
plot_BNS.r (called by plot.ksh):
---------------
- R program for plotting the BNS metric for single models, based on the BNS values for the individual biomes and in total
- uses the R library lattice
- input: merged table of the BNS fo the individual biomes calculated for the PFT-based biomisation and the climate-based biomisation, (uses: ${model}_${simid}_${timid}_bns.txt from the PFT-biomisation Tool)
- output: pdf-file showing a dot plot summarizing the BNS values fo all individual biomes and in total.
##################
plot_metric.r (called by plot.ksh):
---------------
- R program for plotting the kappa and FSS metric for single models, based on the kappa and FSS values for the individual biomes and in total
- uses the R library lattice
- input: merged tables of kappa or fss for the individual biomes calculated for the PFT-based biomisation and the climate-based biomisation (uses: ${model}_${simid}_${timid}_kappa.txt and ${model}_${simid}_${timid}_fss.txt)
- output: pdf-files showing a dot plot summarizing the kappa and fss values fo all individual biomes and in total. (kappa.pdf and fss.pdf)
##################
zon_mean_plot.r (called by plot.ksh)
---------------
- R programm for plotting: the zonal mean PFT-fractions, requires that PFT-fractions have been pre-processed.
                         and the zonal mean biome fraction, and a Taylor plot summarizing the skill of the biomisation.
			 In addition, a text file is written, includeing all metrics used in the Taylor plot
- uses the R libraries ncdf4 and plotrix
- requires zonmn = 1 and biome1=1 in the main script
- input: ${model}_${simid}_${timid}_zonalmeans.txt
         ${model}_${simid}_${timid}_biome_zonalmeans.txt
	 ${model}_${simid}_${timid}_bio1_zonalmeans.txt
	 reference_veg_${igrid}_${simid}_zonalmeans.txt
	 ${model}_${simid}_${timid}_VEGCOV_zm.nc 
- output: ${model}_${simid}_${timid}_zm_PFT.pdf                       
          ${model}_${simid}_${timid}_zm_biomes.pdf                 
          ${model}_${simid}_${timid}_taylorPlot_zm.pdf             
          ${model}_${simid}_${timid}_stats.txt                     
##################################
