# calculates the number of tropical plume events per month and the associated rainfall 
library(ncdf4)
AHP <- nc_open("slo0021_echam_dm_7k_precip_land_NAFlarge_m10.nc")  # example of an input file in netcdf
lat <- ncvar_get(AHP, "lat")
lon <- ncvar_get(AHP, "lon")
precip <- ncvar_get(AHP, "var4")
t <- ncvar_get(AHP, "time")

precip.vec <- as.vector(precip)
precip.matrix <- matrix(precip.vec,nrow=dim(lon)*dim(lat),ncol=dim(t))
precip.df <- as.data.frame(precip.matrix)

tplumes <- matrix(0,nrow=dim(lon)*dim(lat))
tp_precip <- matrix(0,nrow=dim(lon)*dim(lat))

for (i in 1:1406) {                               # loop for all 1406 grid-cells
    pre_ind <- as.data.frame(t(precip.df[i,]))
    pre_ind[is.na(pre_ind)] <- 0
    tplumes[i,] <- (sum(pre_ind >= 4.0 ))/30      # we use the 4mm/day precipitation limit suggested by Skinner and Poulsen (2016) for tropical plume events
    tp_prec <- na.omit(pre_ind[pre_ind >= 4 ])
    tp_precip[i,] <- sum(tp_prec)/(30*tplumes[i,])
}

tplumes_array <- array(tplumes, dim=c(dim(lon),dim(lat)))
tprain_array <- array(tp_precip, dim=c(dim(lon),dim(lat)))

# output files
# define dimensions
londim <- ncdim_def("lon","degrees_east",as.double(lon)) 
latdim <- ncdim_def("lat","degrees_north",as.double(lat)) 

# define variables
fillvalue <- -9999
dlname <- "tropical_plumes"
m_def <- ncvar_def("plumes","",list(londim,latdim),fillvalue,dlname,prec="single")

# create netCDF file and put arrays
ncfname <- "tropical_plumes_7k_10.nc"
ncout <- nc_create(ncfname,list(m_def),force_v4=T)

# put variables
ncvar_put(ncout,m_def,tplumes_array)


# put additional attributes into dimension and data variables
ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
ncatt_put(ncout,"lat","axis","Y")


# close the file, writing data to disk
nc_close(ncout)
#####################
dlname <- "TP_mean_precip"
m_def <- ncvar_def("TP_mean_precip","",list(londim,latdim),fillvalue,dlname,prec="single")

# create netCDF file and put arrays
ncfname <- "tropical_plumes_precip_7k_10.nc"
ncout <- nc_create(ncfname,list(m_def),force_v4=T)

# put variables
ncvar_put(ncout,m_def,tprain_array)


# put additional attributes into dimension and data variables
ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
ncatt_put(ncout,"lat","axis","Y")


# close the file, writing data to disk
nc_close(ncout)
