#!/usr/bin/env Rscript

# program to compare site-based records with simulated biome distributions, model data in netcdf (global field), records as ascii-table (with header, and lon, lat, values as columns)

library(ncdf4)
library(irr)

args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument as input: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {
  # list input files
  args 
}

#reading model data
model <- nc_open(args[1])               # opens model data
lat <- ncvar_get(model, "lat")          # reads  model latitudinal vector
lon <- ncvar_get(model, "lon")          # reads model logitudinal vector
bio <- ncvar_get(model, "cover_fract")  # reads the simulated (model) biome distribution

# choosing grid and extend of the neighborhood (n), here ca. 10° in each direction (=3*3.75°, 6*1.875)
 if (nrow(as.data.frame(lon))==96) { 
     n=3
 }  else if (nrow(as.data.frame(lon))==192) { 
     n=6
 }  else if (nrow(as.data.frame(lon))==720) {
     n=20
 }  else if (nrow(as.data.frame(lon))==36) {
     n=1
 }

# preparation for the neighborhood, the model global region has to be extended by n grid rows/columns in each direction to allow for neighborhoods at the grid margins:

outer <- as.data.frame(matrix(700,nrow=n,ncol=1))  # extends the latitude and longitude 'vector'

# extends the model biome matrix in the longitudinal direction and creates a data frame
outermlo <- matrix(700,ncol=ncol(bio),nrow=n)    
latdf <- data.frame(rbind(as.matrix(outer), as.matrix(lat), as.matrix(outer)))
londf <- data.frame(rbind(as.matrix(outer), as.matrix(lon), as.matrix(outer)))

biodflo <- data.frame(rbind(as.matrix(outermlo-700), as.matrix(bio), as.matrix(outermlo-700)))

# extends the model and reference grid in latitudinal directions and creates a data frame
outermla <- matrix(700,ncol=n,nrow=nrow(biodflo))                        
biodf <- data.frame(cbind(as.matrix(outermla-700), as.matrix(biodflo), as.matrix(outermla-700)))

# fill in the values of the new bordering regions
biodf[(nrow(bio)+n+1):(nrow(bio)+2*n),] <- biodf[((1+n):(2*n)),] 
biodf[(1:n),] <- biodf[((nrow(bio)+1):(nrow(bio)+n)),]

######
# reading the site records (table)
recs <- read.table(args[2], header=FALSE)     # reading records

# creating the score table by using the lon and lat information listed in the record table.
score <- cbind(recs$V1, recs$V2, c(0),c(0),c(0))
londf$V1[londf$V1 >= 181] <- (londf$V1[londf$V1 >= 181] - 360) 


#prepares data.frame for kappa, 2 columns for 2 raters, which will be filled with the modelling data in the next routine
big <- as.data.frame(cbind(as.vector(recs$V3),0))      


# reset values
pure = 0
coun = 0


# loop over all records

for (i in c(1:nrow(recs))) {                    
    scoreloc = 0
    sconei = 0
    fit = 0

    # finds the grid-cell that locates the site
    londiff <- (londf-recs$V1[i])^2             
    latdiff <- (latdf-recs$V2[i])^2

    lo <- which.min(londiff)                     # longitudinal grid-box number of the site-locating grid-box
    la <- which.min(latdiff)                     # latitudinal grid-box number of the site-locating grid-box

    big$V2[i] <- biodf[lo,la]                    # fill in the respective model values in the data.frame for the kappa statistic
   

    # testing if biome type in record and site-locating model-gridbox agrees, then all scores are set to 1 (perfect agreement)
    if (recs$V3[i] == biodf[lo,la]) {   
                                            
        score[i,5] = 1
        score[i,3] = 1
        pure = pure+1

    # otherwise:     
    } else {

        # calculates longitudinal (lop) and latitudinal(lap) distance
        lop <- abs(londf-londf[lo,])           
        lap <- abs(latdf-latdf[la,])

        bionei <- biodf[(lo-n):(lo+n),(la-n):(la+n)] # prepares neigborhood matrix of each site
        distance <- matrix(nrow=2*n+1,ncol=2*n+1)    # prepares distance matrix
        weight <- matrix(nrow=2*n+1,ncol=2*n+1)      # prepares weights matrix of the grid-cell in the neigborhood
        sconei <- matrix(nrow=2*n+1,ncol=2*n+1)      # individual neighborhood score matrix

        #loop over all cells in the neigborhood
        for (l in c(-n:n)) {                         
            for (k in c(-n:n)) {
            
                distance[(k+n+1),(l+n+1)] =sqrt((lop[(lo+k),])^2+(lap[(la+l),])^2)          # calculates the distances to the center cell (locating the sites)
                #weight[(k+n+1),(l+n+1)]=exp( (log(0.75))*(distance[(k+n+1),(l+n+1)]/2) )   # weights exponential function (0-1)
                #weight[(k+n+1),(l+n+1)]=1-((distance[(k+n+1),(l+n+1)])/n+1)                # weights conical function   (0-1)
                weight[(k+n+1),(l+n+1)]=exp( (-1/2)*(distance[(k+n+1),(l+n+1)]/3)^2)        # weights, gaussian function  (0-1)

                # testing. in each grid-cell of the neighborhood, in which the biome type agrees with the record,
                # the score is set to the value of the weight matrix, otherwise all scores are set to 0
                
                if  (bionei[k+n+1,l+n+1] == recs$V3[i]) {                                   
                    sconei[k+n+1,l+n+1]= weight[(k+n+1),(l+n+1)]                            
                    fit = fit+1                                                             # fit counts the numbers of grid-cell agreeing with the record
                    scomd =  weight[(k+n+1),(l+n+1)]                                        
                } else {
                    sconei[k+n+1,l+n+1] = 0
                    scomd = 0
                }
                
                scoreloc=scoreloc+scomd                                                     # distance weighted fractional agreement with the record, it is the sum of all scores
                
            }
        }
        ocean <- sum(bionei==0)                                                             # sum of oceanic grid-cells

        if (scoreloc == 0 ) {                                                               # if no grid-cell agrees, scoreloc is set to 0
            score[i,5] = 0                                                    
        } else {
            score[i,5]=scoreloc/((ncol(distance)*nrow(distance))-ocean)                     # mean fractional agreement in the neigborhood
        }

        # counting fractional fit
        if (fit == 0 ) { 
            score[i,4] =  0
        } else {
            score[i,4]=fit/((ncol(distance)*nrow(distance))-ocean)                          
        }

        # if in the neighborhood all grid-cells are covered with ocean, the score is set to 0
        if ( (ocean == (ncol(distance)*nrow(distance)))) {
            score[i,3] <- NA
            score[i,4] <- NA
            score[i,5] <- NA
            coun = coun + 1

        } else {
            score[i,3]=max(sconei)                                                           # best neigbor score, i,e the score of the
        }                                                                                    # nearest grid-box agreeing with the records
                    
        scoreloc = 0
        fit = 0
        sconei=0
        scomd = 0
    }

}

# calculates the BNS for all individual biomes
score3 <- (score[,3])
score3[is.na(score3)] <- 0
scat <- matrix(-1,ncol=1,nrow=10)

for (i in c(1:9)) {       
    scat[i,] <- mean(score3[recs$V3 == i])
}
scat[10,] <- mean(score[,3], na.rm=TRUE)


# prints the main statistic
print(c("records located fully in the model ocean:",coun))
pure = pure/((nrow(recs)-coun))                                                
print(c("scoreloc:",mean(score[,5],na.rm=TRUE)))
print(c("grid-cells agreeing directly at the site:", pure))                                                  # 
print(c("fitting neighborhoods:",sum(score[,5]!=0,na.rm=TRUE), nrow(recs)))
print(c("BNS:", mean(score[,3], na.rm=TRUE)))

# writes tables to text-files:
#score.csv -> contains the lon lat and total BNS for each site,
#score_cat.csv -> contains the total BNS for all individual biomes (1-9) and in total (10)
write.table (score[,1:3], file="score.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
write.table (scat, file="score_cat.csv", sep = "\t", row.names=FALSE, col.names=FALSE)

####

#### calculating kappa
big$V1[big$V2==0] <- NA
big$V2[big$V2==0] <- NA

kap <- kappa2(big[,1:2], "unweighted")
print(c("unweighted kappa: ",kap)


##############################
