#!/usr/bin/env Rscript
# applies the Fractional Skill Score Metric following Roberts and Lean, 2008
# (reference: Roberts, N. M., and Lean, H. W.: Scale-selective verification of rainfall accumulations from high-resolution forecasts of convective events.
# Mon. Wea. Rev., 136, 78–97, doi:https://doi.org/10.1175/2007MWR2123.1, 2008.)
#
# works only for gridded data.
#########################

library(ncdf4)
library(irr)
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {
# list input files
  args 
}

#reading data
model <- nc_open(args[1])  # open model data
ref <- nc_open(args[2])    # open reference data (requires the same grid as the model data)

lat <- ncvar_get(model, "lat")   # reads latitudes
lon <- ncvar_get(model, "lon")   # reads longitudes
bio <- ncvar_get(model, "cover_fract") # reads biomes of the model
veg <- ncvar_get(ref, "var1")          # reads biomes of the reference

# choosing grid and extend of the neighborhood, here ca. 10° in each direction
 if (nrow(as.data.frame(lon))==96) { 
     n=3
 }  else if (nrow(as.data.frame(lon))==192) { 
     n=6
 }  else if (nrow(as.data.frame(lon))==36) { 
     n=1
 }

# preparing and calculating unweighted kappa
big <- data.frame(cbind(as.vector(veg),as.vector(bio)))  # preparing data for kappa statisic,
big[big==0] <- NA                                        # format: data.frame with 2 columns for the 2 raters
                                                         # missing values are ignored
kap <- kappa2(big[,1:2], "unweighted")                    

# preparation for the neighborhood, the global region has to be extended by n grid rows/columns in each direction to allow for neighborhoods at the grid margins
outer <- as.data.frame(matrix(700,nrow=n,ncol=1))  # extends the latitude and longitude 'vector' 


# extends the model biome matrix in the longitudinal direction
outermlo <- matrix(700,ncol=ncol(bio),nrow=n)
latdf <- data.frame(rbind(as.matrix(outer), as.matrix(lat), as.matrix(outer)))
londf <- data.frame(rbind(as.matrix(outer), as.matrix(lon), as.matrix(outer)))

biodflo <- data.frame(rbind(as.matrix(outermlo-700), as.matrix(bio), as.matrix(outermlo-700)))
vegdflo <- data.frame(rbind(as.matrix(outermlo-700), as.matrix(veg), as.matrix(outermlo-700)))    

# extends the model and reference grid in latitudinal directions
outermla <- matrix(700,ncol=n,nrow=nrow(biodflo))  
biodf <- data.frame(cbind(as.matrix(outermla-700), as.matrix(biodflo), as.matrix(outermla-700)))
vegdf <- data.frame(cbind(as.matrix(outermla-700), as.matrix(vegdflo), as.matrix(outermla-700)))

# fill in the values of the new bordering regions
biodf[(nrow(bio)+n+1):(nrow(bio)+2*n),] <- biodf[((1+n):(3+n)),] 
biodf[(1:n),] <- biodf[((nrow(bio)+1):(nrow(bio)+n)),]

#create mask for oceanic grid-boxes
ocean <- matrix(0,nrow=nrow(biodf),ncol=ncol(biodf))
ocean[biodf==0] <- 1.0            


colnames(biodf) <- c(1:(ncol(biodf)))
colnames(ocean) <- c(1:(ncol(biodf)))
colnames(vegdf) <- c(1:(ncol(biodf)))


# prepares the score matrix (10 rows for 9 individual biomes and the total score),
#fss: fractional skill score, fssr: random fss (lower limit), fssu: uniform fss (level to exceed), rffs: relative fss = fss - fssu

score <- matrix(nrow=10,ncol=4)  
colnames(score) <- c("fss","fssr","fssu","rffs")


# preparing the matrices for the FSS calculation, loop for the 9 individual biomes
for (t in c(1:9)) {
    
    mfract <- matrix(0,nrow=nrow(bio),ncol=ncol(bio))     # constructs the matrix for the cover fractions (model) 
    rfract <- matrix(0,nrow=nrow(bio),ncol=ncol(bio))     # constructs the matrix for the cover fractions (reference)
    biotdf <- matrix(0,nrow=nrow(biodf),ncol=ncol(biodf)) # constructs the data frame for the binary biome maps for each individual biome t (model)
    vegtdf <- matrix(0,nrow=nrow(biodf),ncol=ncol(biodf)) # constructs the data frame for the binary biome maps for each individual biome t (reference)
    
    biotdf[biodf==t] <- 1.0   # mask for biome t, set to 1 in each t-covered grid-box in the model
    vegtdf[vegdf==t] <- 1.0   # mask for biome t, set to 1 in each t-covered grid-box in the reference

    # loop over all latitudes and longitudes
    for (i in c((n+1):(nrow(bio)+n))) {

        for (j in c((n+1):(ncol(bio)+n))) {

            #reset values
            mse = 0
            mse_wc = 0
            bionei = 0
            vegnei = 0
            
            bionei <- biotdf[(i-n):(i+n),(j-n):(j+n)]    # neigborhood for the respective grid-cell in the model
            vegnei <- vegtdf[(i-n):(i+n),(j-n):(j+n)]    # neighborhood for the respective grid-cell in the reference 

            ocenei <- sum(ocean[(i-n):(i+n),(j-n):(j+n)])  # sum of all oceanic grid-cell in the neighborhood

            if (ocenei==(ncol(bionei)*nrow(bionei))) {
                mfract[(i-n),(j-n)] = 0                    # if the entire neighborhood is covered by ocean, fraction is set to 0 
                rfract[(i-n),(j-n)] = 0
            }
            else {
                mfract[(i-n),(j-n)]=sum(bionei)/ ((ncol(bionei)*nrow(bionei))-ocenei)  # fraction = mean coverage of biome t in the neighborhood (model)
                rfract[(i-n),(j-n)]=sum(vegnei)/ ((ncol(bionei)*nrow(bionei))-ocenei)  # fraction = mean coverage of biome t in the neighborhood (reference)

            }
        }
    }

       
    slm <- sum(bio==0)   # land-sea-mask
    mse = sum((rfract - mfract) ^ 2) / ((ncol(bio)*nrow(bio))-slm)                  # calculates the MSE
    mse_wc = ( (sum(rfract ^ 2)) + (sum(mfract ^ 2))) / ((ncol(bio)*nrow(bio))-slm) # caluclates the 'worse' MSE
    score[t,1] <- (1- (mse/mse_wc))                                                 # calculates the fss score
    score[t,2] <- ( (sum(bio==t) )/ ( (ncol(bio)*nrow(bio))-slm) )                  # calculates ffsr (random fss)
    score[t,3] <- ( ((score[t,2])/2) + 0.5 )                                        # calculates fssu (uniform fss)

}  

score[10,1] <- mean(score[1:9,1] , na.rm=TRUE)                                      # total fss is the mean score of the scores of the individual biomes (1-9)
score[10,2] <- mean(score[1:9,2] , na.rm=TRUE)                                      # calculated total ffsr as mean of all individual random fss
score[10,3] <- mean(score[1:9,3] , na.rm=TRUE)                                      # calculated total fssu as mean of all individual uniform fss  
score[,4] <- (score[,1]-score[,3])  

print("FSS score:  FSS FSSr FSSu rFSS")
print(score)
print(c("unweighted kappa: ", kap))
            
# output, write table with all FSS
write.table( (format(score, digits=2, scientific=F)), file="score_fss.csv", sep='\t', row.names=FALSE, col.names=FALSE)


      
#
