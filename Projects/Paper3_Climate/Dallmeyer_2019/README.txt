Supplementary information for the paper "Harmonizing plant functional type distributions for evaluating Earth System Models" 
by Anne Dallmeyer, Martin Claussen, and Victor Brovkin, 2019

Primary data (PFT-distribution, total cloud cover, precipitation and 2m-air temperature simulated by the individual Earth System Models)
- CMIP5-simulations (downloaded from Earth System Grid):
  - MPI-ESM-T63: performed in MPI-ESM-P by the Max Planck Institute for Meteorology, Hamburg, Germany
       References: PI: cmip5.output1.MPI-M.MPI-ESM-P.piControl.mon.land.Lmon.r1i1p1.v20120315
       		   6k: cmip5.output1.MPI-M.MPI-ESM-P.midHolocene.mon.land.Lmon.r1i1p2.v20120713
		   LGM: cmip5.output1.MPI-M.MPI-ESM-P.lgm.mon.land.Lmon.r1i1p2.v20120713
  - IPSL-ESM-T31: performed in IPSL-CM5A-LR by the Institut Pierre Simon Laplace (IPSL), Paris, Frankreich
       References: PI: pmip3.output.IPSL.IPSL-CM5ALR.piControl. monClim.land.Lclim.r1i1p1.v20140428
  - HadGEM2-ESM: performed in HadGEM2-ES by the Met Office Hadley Centre, Exeter, United Kingdom
       References: PI: cmip5.output1.MOHC.HadGEM2-ES. piControl.mon.land.Lmon.r1i1p1.v20111007
       		   6k: cmip5.output1.MOHC.HadGEM2-ES.midHolo cene.mon.land.Lmon.r1i1p1.v20120222
  - MIROC-ESM: performed in MIROC-ESM by the Japan Agency for Marine-Earth Science and Technology, Atmophere and Ocean Research Institute (University of Tokyo) and the National Institute for Environmental Studies, Japan
       References: PI: cmip5.output1.MIROC.MIROC-ESM.piControl. mon.land.Lmon.r1i1p1.v20120710
       		   6k: cmip5.output1.MIROC.MIROC-ESM.midHolo cene.mon.land.Lmon.r1i1p1.v20120710
		   LGM: cmip5.output1.MIROC.MIROC-ESM.lgm. mon.land.Lmon.r1i1p1.v20120710
		   
- other simulations:
  - MPI-ESM-T31: performed in MPI-ESM-P by Klockmann et al., 2016, Max Planck Institute for Meteorology, Hamburg, Germany,
    	Simulations: piCTL, LGMref
	Reference:  Klockmann et al., Clim. Past, 12, 1829-1846, https://doi.org/10.5194/cp-12-1829-2016, 2016. 
  - IPSL-ESM-T63: performed with ORCHIDEE-MICT forced with CRUNCEP or IPSL-CM5A-LR, by Zhu et al. 2016 at the Institute Pierre Simon Laplace, Paris, Frankreich
        Reference: Zhu, D.:  Thèse de doctorat Météorologie, océanographie, physique de l'environnement Paris Saclay 2016, 2016SACLV077, http://www.theses.fr/2016SACLV077, 2016.
                   Zhu, D., Ciais, P., Chang, J., Krinner, G., Peng, S., Viovy, N., Peñuelas, J., and Zimov, S.: The large mean body size of mammalian herbivores explains the productivity paradox
		      during the Last Glacial Maximum, Nature Ecology & Evolution, 2, 640-649, 2018
  - CLIM-LPJ: performed with LPJ forced with CRU data or Climber2 by Kleinen, T., 2018, Max Planck Institute for Meteorology, Hamburg, Germany.
        Reference: PI and 6k simulations ran on a new computer, but are performed as in Kleinen et.al: Geophysical Research Letters, 37, doi:10.1029/2009GL041391, 2010.
		   the data used in this study is available in this archive (inputdata)
  - CLIMBER: performed in Climber2 by Kleinen, T., 2018, Max Planck Insitute for Meteorology, Hamburg, Germany.
    	Reference: this simulation has been undertaken for this study, the data used is available in this archive (inputdata)
  
Further datasets used:
- University of East Anglia Climatic Research Unit Time Series 3.10 (CRU TS3.10, University of 	East Anglia, 2008, Harris et al., 2014),
  for getting data, please contact: BADC badc@rl.ac.uk, see: http://catalogue.ceda.ac.uk/uuid/3f8944800cc48e1cbc29a5ee12d8542d
-  University of East Anglia Climatic Research Unit Time Series 4.00 (CRU TS4.0, http://doi.org/10/gbr3nj,  University of East Anglia, 2017),
  for getting data, please contact: BADC badc@rl.ac.uk, see: http://catalogue.ceda.ac.uk/uuid/3f8944800cc48e1cbc29a5ee12d8542d
- BIOME6000 pollen-based biome reconstructions: http://dx.doi.org/10.17864/1947.99, Harrison, 2017, available here: http://researchdata.reading.ac.uk/99/
- Ramankutty and Foley, 1999 (RF99): estimates of modern potential biome distributions, Ramankutty and Foley, original data can be downloaded on this webpage:  https://nelson.wisc.edu/sage/data-and-models/global-potential-vegetation/index.php
- calculated biome distributions based on IPSL-ESM in T63, provided by D.Zhu (http://www.theses.fr/2016SACLV077 and Zhu et al., Nature Ecology & Evolution, 2, 640-649, 2018), who has been using the biomisation method of Prentice et al. 2011, the biome data is provided in the folder 'analyse'


Data preparation:
a) climate data: if available, we used climatological (mean of 100 years) monthly mean values for precipitation (code 4, in kg/m²/s), 2m-air-temperature (code 167, in K) and total cloudiness (code 164, in cover fraction going from 0-1) and merged these files for each simulation to a single forcing file for the BIOME1 model (Prentice et al. 1992) using the Climate Data Operators (cdos, developed by the Max-Planck-Institute for Meteorology, available at: https://code.mpimet.mpg.de/projects/cdo). We provide a modified BIOME1 model in this archive. The PFT-biomisation requires monthly mean 2m-air-temperature and growing degree days (GDD) on the basis of 0°C and 5°C. We also provide a reduced BIOME1 model "GDDcalc.f90" which only needs the 2m-air-temperature (monthly climatological means in K) to calculate the GDD distributions. We calculated the GDD distributions with the  BIOME1 model for nearly all simulations, only for IPSL-ESM-T63_LGM we used the GDDcalc.
The inputdata of all simulations is provided in the folder 'inputdata'
b) PFT distributions: the provided PFT-distributions have been averaged over 100 years to get a multi-year mean vegetation distribution using the Climate Data Operators (cdos). For some simulations PFT cover fractions were given in %, this was taken into account in the biomisation tool.
c) potential vegetation map (RF99): the original biome distribution of RF99 has been regrouped into the mega-biomes used in this study by the shell programm: prepare_RF_map.ksh This program also calls a fortran program used for the remapping of the data, please see the documentation of the programms for further details. All used programms, the input and output data fo the preparation of the RF99 reference map are provided in the folder 'potveg'.
d) biome reconstructions: the biome reconstructions have been regrouped into the mega-biomes used in this study following the guidelines of the BIOME6000 project (cf. the README file of the dataset available here: http://researchdata.reading.ac.uk/99/). For copyright reasons we cannot provide the pollen data here in this archive, the user has to download the data and regroup it into the mega-biomes according to the cited readme file of the BIOME6000 project. The data has to be saved in the folder 'records'. We apologize for this inconvenience.   

##########################
The biomisation tool:
-The biomisation tool calculates the biome distribution which is saved in a netCDFfile. Flowcharts are provided for each model, showing the individual steps of the biomisation.
-The first part of the code of the tool provides a user setup that has to be modified before each simulation (please look into the code for further details). It contains switchs for additional analysis and plots: The tool can calculate the biome distribution based on the background climate using BIOME11 (optional, requires biome1=1). It furthermore performs a pre-processing of the vegetation data (optional), in which the PFT is also grouped into main PFT groups (requires preproc = 1), it calculates (optional) the kappa (kappa=1), FSS and/or BNS metric (metric=1), the zonal mean PFT or biome distribution (zonmn=1) and also provides a switch for plotting the metrics and biome distributions using R and GMT (optional, requires plot=1)
-The outputdata for the biomisation is saved in a folder named  vegetation_${model}_${simid}_${timid} (the variables can be specified by the user in the user setup).
-The inputdata has to be provided in the same folder as the main program pfttobiome.ksh
- the different sub-programs are provided in the folder 'programs', together with a README file explaining the individual programs, input and output data.

output data
- we provide the basic output files in the folder 'output'
- It contains the netCDF files for the simulated PFT-based biome distributions (---biomePFT.nc) and the output of the BIOME1 model (---bio1out.nc) for the individual models
  and summarising files for the BNS, Kappa and FSS metric listing the respective metric for all individual biomes and all models.
  
further analysis:
- the 6k and PI desert margin in North Africa was calculated by using the cdos (cdo -zonmean -setmisstoc,0 -sellonlatbox,-15,30,0,40 ifile ofile), applied on a file just containing a binary map with 1 in the grid-cell representing the desert biome and 0 for other biomes, the desert margin is here defined as latitude at which the zonal mean desert fraction exceeds 50%
- the mean forest biome fraction in the high northern latitudes was calculated by using the cdos  (cdo -fldmean -sellonlatbox,0,150,60,80 -ltc,4.5 ifile ofile)
- Modern (PI) fraction of the biome 'tropical forest' in South America (given in % of the land area) is calculated by using the cdos (cdo -gridarea -sellonlatbox,279,327,-57,13 -gtc,0 -setctomiss,0 ifile SAgridarea; cdo -fldsum -mul -sellonlatbox,279,327,-57,13 -gtc,0 -setctomiss,0 ifile SAgridarea SAarea, cdo -fldsum -mul SAgridarea -sellonlatbox,279,327,-57,13 -ltc,1.5 -setctomiss,0 ifile tropical_forest; cdo info -div tropical_forest SAarea)
- A sensitivity study is performed to assess the impact on climate biases in the ESMs on the PI biome simulation using the script: run_sentest.ksh, which is provided in the folder 'analyse'
- The PFT-method introduced in this study is compared with the biomisation method of Prentice et al. 2011, using the IPSL-ESM-T63 simulation. The biome distributions (using the Prentice method) were inferred by D. Zhu (http://www.theses.fr/2016SACLV077 and Zhu et al., Nature Ecology & Evolution, 2, 640-649, 2018). The pre-processing of the data and the comparison between the two method was performed using the script: bio_zhu_comp.ksh, this script is provided in the folder 'analyse'. The original biome distributions by D.Zhu is provided in the folder 'analyse'.....


Plotting:
- all maps have been created with the Global Mapping Tool (GMT)
- all plots dealing with the metrics and the zonal mean plot have been created with R
- example plot scripts for the biome maps and the metrics and zonal mean plots are provided in the folder 'programs' and are further explained in the plot.ksh script.
- biome maps and the metrics can be directly calculated within the biomisation tool (requires plot=1 in the user setup) 

Paper history:
- Internal review by Thomas Kleinen (March 23rd, 2018)
- Manuscript registration and initial upload at CPD (March 28th, 2018)
- published in CPD (April 6th, 2018), Editor: Denis-Didier Rousseau  
- interactive public discussion closed (August 22nd, 2018)
- Reply to referee comments and upload of revised version for CP (November 7th, and December 4th, 2018)
- Accepted for publication (January, 24th) and upload of final version on February, 1st

Signed:  Anne Dallmeyer, January, 2019
