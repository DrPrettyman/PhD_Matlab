Supplementary information for the paper "The end of the African humid period as seen by a transient comprehensive Earth system model simulation of the last 8000 years"
by Anne Dallmeyer, Martin Claussen, Stephan J. Lorenz and Timothy Shanahan

Primary data:
 - model: MPI-ESM, in the tagged model version: mpiesm-1.2.00p4, revision r8491, 2016-03-09, performed on Mistral computer at DKRZ
 - transient simulation: slo0021, monthly data of years 6000 BCE to 1850 CE
 - full Holocene forcing: greenhouse gases, aerosol, ozone, solar, orbit
 - restart from spinup at 8kyBP (tra0163 year 38991231)
Full List of changes:
 - albedo scheme by Freya Vamborg, tested by Thomas Raddatz, 2016
 - CO2 by Fortunat Joos, 2016
 - CH4, N2O by IPCC AR4, 2006
 - SW flux for volcanic aerosols by Matt Toohey, 2016
 - ozone data by Hauke Schmidt, 2016
 - spectral solar irradiance by Natalie Krivova, prepared by Hauke Schmidt, 2016
 - orbital parameters by Berger, 1978
 - data and experiment prepared by Stephan Lorenz, 2016

-short transient simulations:
- slo0021a: restart of slo0021, model years 1961-1990 (1961 = 7039yBP), 6-hourly data 
- slo0021b: restart of slo0021, model years 6001-6030 (6001 = 2999yBP), 6-hourly data 
- slo0021c: restart of slo0021, model years 8701-8730 (8701 = 1701 AD), 6-hourly data
- slo0021e: restart of slo0021, model years 4001-4030 (4001 = 4999yBP), 6-hourly data

The model MPI-ESM is freely available to the scientific community and can be accessed with a license on the MPI-M Model distribution website, please see https://www.mpimet.mpg.de/en/science/models/mpi-esm/ for further details.
The runs-scripts and excecutables for all simulations are archived in the HPSS tape archive and can be accessed by contacting DKRZ

further datasets used:
- CMIP5-simulations (downloaded from Earth System Grid):
  - MPI-ESM-T63: performed in MPI-ESM-P by the Max Planck Institute for Meteorology, Hamburg, Germany
       References: PI: cmip5.output1.MPI-M.MPI-ESM-P.piControl.mon.land.Lmon.r1i1p1.v20120315
       		   6k: cmip5.output1.MPI-M.MPI-ESM-P.midHolocene.mon.land.Lmon.r1i1p2.v20120713
  - HadGEM2-ESM: performed in HadGEM2-ES by the Met Office Hadley Centre, Exeter, United Kingdom
       References: PI: cmip5.output1.MOHC.HadGEM2-ES. piControl.mon.land.Lmon.r1i1p1.v20111007
       		   6k: cmip5.output1.MOHC.HadGEM2-ES.midHolo cene.mon.land.Lmon.r1i1p1.v20120222
  - MIROC-ESM: performed in MIROC-ESM by the Japan Agency for Marine-Earth Science and Technology, Atmophere and Ocean Research Institute (University of Tokyo) and the National Institute for Environmental Studies, Japan
       References: PI: cmip5.output1.MIROC.MIROC-ESM.piControl. mon.land.Lmon.r1i1p1.v20120710
       		   6k: cmip5.output1.MIROC.MIROC-ESM.midHolo cene.mon.land.Lmon.r1i1p1.v20120710
		   
- BIOME6000 pollen-based biome reconstructions: http://dx.doi.org/10.17864/1947.99, Harrison, 2017, available here: http://researchdata.reading.ac.uk/99/
- precipitation reconstruction by Bartlein et al., 2011 (Bartlein, P.J., Harrison, S.P., Brewer, S., Connor, S., Davis, B.S.A., Gajewski, K., Guiot, J., Harrison-Prentice, T.I., Henderson, A., Peyron, O., Prentice, J.C., Scholze, M., Seppä, H., Shuman, B., Sugita, S., Thompson, R.S., Viau, A.E., Williams, J., and Wu, H.: Pollen-based continental climate reconstructions at 6 and 21 ka: A global synthesis. Clim. Dyn. 37, 775 – 802, https://doi.org/10.1007/s00382-010-0904-1, 2011), can be downloaded from the supplement of their manuscript.

- synthesis of reconstructions on Holocene moisture levels in North Africa, prepared by Tim Shanahan (Shanahan, T. M., Mckay, N. P., Hughen, K. A., Overpeck, J. T., Otto-Bliesner, B., Heil, C. W., King, J., Scholz, C. A., and Peck, J.: The time-transgressive termination of the African humid period, Nat. Geosci., 8, 140–144, https://doi.org/10.1038/ngeo2329, 2015.). This synthesis has been revised and updated by Tim Shanahan, 2019. A list with all records and their references, the AHP end, and differences to the previous synthesis are provided in the supplement of the manuscript (in Climate of the Past) and in this archive (AHPproxies.xls, AHPproxies_README.txt) 


Data preparation and analysis:
- The model has been evaluated by comparing the simulated vegetation with reconstructions (BIOME6000 dataset). For this purpose, the simulated PFT cover fractions has been translated into mega-biomes using the biomisation tool of Dallmeyer et al. 2019 (can be downloaded here: http://hdl.handle.net/21.11116/0000-0001-B800-F).
- For the evaluation of the simulated precipitation, pollen-based reconstructions have been used (Bartlein et al., 2011).

calculation of the AHP end:
- The simulated bare soil fraction (1 minus code20 (jsbach veg stream)) has been smoothed by a local regression with a smoothing span of 70% using the LOESS routine in R (R core team, 2014). Afterwards, the first timestep has been subtracted from the time-series, so that all BSF time-series start at a value of 0. The  smoothed bare soil fraction (file='slo0021_bsf_loess_smoothed70min8k.nc) has then been used to calculate the timing of the end of the AHP using the Fortran90 script "AHP_calculation.f90". The output of this routine is saved in the file: slo0021_AHP_NAF_end_loess70.nc (folder output).

- The simulated AHP end has been evaluated using the R script "patt_comp.r" which can be started by the shell script "run_AHP_metrics.ksh". Both files are provided in this archive. Please see the comments in the shell script regarding the content of the output files. The evaluation includes the kappa metric and the pattern comparison based on the relative timing of the AHP. The output that is used for plotting is provided in this archive in the folder 'output': i.e. semi_time_diff.csv (Fig.4e), semi_time_mod.csv (Fig.4c), semi_time_recs.csv (Fig.4d) and total_diff_mod_recs.csv (Fig.4b).

- To identify the regions of different rainfall regimes in North Africa, a c-means clustering was performed on the pre-industrial (i.e. last 100 years of the simulation) monthly to annual rainfall rate, using the R command "cmeans" that is part of the library "e1070", Here we use 10 cluster center that afterwards have been grouped to 5 rainfall regimes according to the annual precipitation cycle (R command: cmeans(matrix,10,100,verbose=FALSE,dist="euclidean",method="cmeans"))

- the number of tropical plume events has been calculated for each time-slice and each month via the R script: tropPlum_nc.r which is provided in this archive.

Plotting:
- all maps have been created with the Global Mapping Tool (GMT) or the Grid Analysis and Display System (GrADS), if vectors were plotted.
- The transient vegetation change (Fig.3c and B1) and the precipitation isolines has been plotted with GrADS
- Fig.1 and Fig.7b have been created within libreoffice 
- Fig 2b and Fig.8e have been created with R


Paper history:
- Internal review by Thomas Kleinen (June 11th, 2019)
- Manuscript registration and initial upload at CPD (July 11th and 12th, 2019)
- published in CPD (July 30th, 2019), Editor: Ran Feng  
- interactive public discussion closed (September 24th, 2019)
- Reply to referee comments and upload of revised version for CP (October 10th, and October 30th, 2019)
- Accepted for publication (November 15th, 2019) and upload of final version on January 10th, 2020)


Signed: Anne Dallmeyer, January, 2020
