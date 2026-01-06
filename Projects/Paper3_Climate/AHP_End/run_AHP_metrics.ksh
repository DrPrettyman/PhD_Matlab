#!/bin/ksh
set -ex
#  shell script for the evaluation of the simulated end of the African humid period vs the reconstructions of Shanahan et al. (here provided as csv-file, rounded up in 500year intervalls)
# the model results (slo0021_AHP_NAF_end_loess70.nc) are first rounded up in 500 year intervals, similar to the reconstructions
######
# uses the R scripts patt_comp.r (needs the libraries 'ncdf4' and 'irr', which can be installed in R directly)
#####
# the output files are (all comma separated lists):
# a) reltime_recs.csv -> table listing the longitude, latitude and the difference bewteen the number of sites showing a later AHP end and the number of sites showing an earlier AHP end (late - early) for the records 
# b) reltime_mod.csv -> same as a) but for the grid-cells in the model output
# c) reltime_all.csv -> combining a) and b) and the difference between a) and b)
# d) patt_count_all.csv -> table listing the longitude, latitude, and the percentages of sites showing an earlier, later or similar timing of the AHP end for the records and for the model, respectively
# e) semi_all.csv -> table listing the longitude, latitude, and the relative time of the AHP end for each site and according grid-cell (i.e. if the AHP end at the site is rather earlier than at all other sites (1) or later than at all other sites (-1), or similar to all other sites (0)
# f) semi_time_mod.csv -> same as e) but fot the model only
# g) semi_time_rec.csv -> same as e) but for the records only
# h) semi_time_diff.csv -> difference between f) and g)
# i) total_diff_mod_recs.csv -> table listing the longitude, latitude and total difference between the simulated and reconstructed AHP end in years

# preparing the data (rounding up the data)
cdo  -setrtoc,-450,5,0 -setrtoc,-950,-450,-501 -setrtoc,-1450,-950,-1001 -setrtoc,-1950,-1450,-1501 -setrtoc,-2450,-1950,-2001 -setrtoc,-2950,-2450,-2501  -setrtoc,-3450,-2950,-3001 -setrtoc,-3950,-3450,-3501 -setrtoc,-4450,-3950,-4001 -setrtoc,-4950,-4450,-4501 -setrtoc,-5450,-4950,-5001 -setrtoc,-5950,-5450,-5501 -setrtoc,-6450,-5950,-6001 -setrtoc,-6950,-6450,-6501 -setrtoc,-7450,-6950,-7001 -setrtoc,-7950,-7450,-7501 -setrtoc,-8010,-7950,-8001 -selvar,AHP_END slo0021_AHP_NAF_end_loess70.nc slo0021_AHP_NAF_end_loess70_int.nc

## starting the R script
Rscript --vanilla lonlat_comp.r slo0021_AHP_NAF_end_loess70_int.nc AHP_end_proxies.csv


