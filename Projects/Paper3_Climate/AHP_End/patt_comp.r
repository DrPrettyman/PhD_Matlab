#!/usr/bin/env Rscript

# programm to compare the simulated AHP end with the reconstructions, based on relative times

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
model <- nc_open(args[1])               #model data
lat <- ncvar_get(model, "lat")          #model latitudinal vector
lon <- ncvar_get(model, "lon")          #model logitudinal vector
AHP <- ncvar_get(model, "AHP_END")      #reads the simulated AHPend distribution

latdf <- data.frame(as.matrix(lat))
londf <- data.frame(as.matrix(lon))
AHPdf <- data.frame(as.matrix(AHP))

######
recs <- read.table(args[2], header=FALSE)     # reading records

londf$V1[londf$V1 >= 181] <- (londf$V1[londf$V1 >= 181] - 360) 

all <- as.data.frame(cbind(as.vector(recs$V1),as.vector(recs$V2),as.vector(recs$V3),0,0))      #prepares data.frame lon, lat, data, model, and difference, at all sites

for (i in c(1:nrow(recs))) {                      # loop over all records
    
    londiff <- as.matrix((londf-recs$V1[i])^2)    # finds the grid-cell that locates the site
    latdiff <- as.matrix((latdf-recs$V2[i])^2)

    lo <- which.min(londiff)                      # longitudinal grid-box number of the site-locating grid-box
    la <- which.min(latdiff)                      # latitudinal grid-box number of the site-locating grid-box

    all$V4[i] <- AHPdf[lo,la]                     # fill in the respective simulated values in the data.frame  at all sites

}

all$V4[all$V4 <=-9000] <- NA                     # set oceanic grid-cells to NA and deletes these records and grid-cells from the data.frame all
all <- na.omit(all)

patt <- data.frame(cbind(all$V1, all$V2, c(0),c(0),c(0), c(0), c(0), c(0), c(0)))    # prepares data.frames for comparison
score <- data.frame(cbind(all$V1, all$V2, c(0),c(0),c(0)))
semi <- data.frame(cbind(all$V1, all$V2, c(0),c(0),c(0)))

######################################### check lon lat pattern 

for (i in c (1:nrow(all))) {
    recearl = 0
    reclate = 0
    recequal = 0

    modearl = 0
    modlate = 0
    modequal = 0
    
    lapl = all$V2[i] + 50                          # limiting the region for comparison, here the entire NAF region is used
    lami = all$V2[i] - 50

    for (j in c(1:nrow(all))) {                                # calculating for each site and grid-cell that includes a site, if the AHP end at all other sites or grid-cell including sites occurs earlier or later as or equal to the AHP end at the respective site. 
        
        if ( (lami <= all$V2[j]) & (all$V2[j]  <= lapl)) {  

            if (all$V3[j] > all$V3[i]) {
                reclate = reclate + 1
            } else if (all$V3[j] == all$V3[i]) {
                recequal = recequal + 1
            } else {
                recearl = recearl + 1
            
            }
            if (all$V4[j] > all$V4[i]) {
                modlate = modlate + 1
            } else if (all$V4[j] == all$V4[i]) {
                modequal = modequal + 1
            } else {
                modearl = modearl + 1
            }
        }
    }

    patt$X3[i] <- (recearl/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100           # patt includes the percentages for each case, i.e. percentage of sites
    patt$X4[i] <- (reclate/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100           # at which the AHP occurs earlier or later or equal with respect to the site i 
    patt$X5[i] <- ((recequal-1)/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100

    patt$X6[i] <- (modearl/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100
    patt$X7[i] <- (modlate/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100
    patt$X8[i] <- ((modequal-1)/(abs(recearl)+abs(reclate)+abs(recequal-1)))*100
    patt$X9[i] <- abs(recearl)+abs(reclate)+abs(recequal-1)
        
    score$X3[i] = patt$X4[i] - patt$X3[i]                                             # data.frame score is calculated by the differences between sites
    score$X4[i] = patt$X7[i] - patt$X6[i]                                             #  with later AHP end and sites with earlier AHP end
    score$X5[i] = (score$X4[i] - score$X3[i])

    all$V4[all$V4 <=-9000] <- NA

    
}


all$V5 <- (all$V4 -all$V3)

semi$X3[score$X3 <= -20] <- 1                                                        # semi categorize the AHP end at the respective site and the according grid-cell 
semi$X3[score$X3 >= 20] <- -1                                                        # if 20% more sites show an earlier end than a later end, semi is set to 1,
semi$X3[(score$X3 < 20) & (score$X3 > -20)] <- 0                                     # if 20% more sites show a later end than an earlier end, semi is set to -1,  
                                                                                     # in between, semi is set to 0
semi$X4[score$X4 <= -20] <- 1
semi$X4[score$X4 >= 20] <- -1
semi$X4[(score$X4 < 20) & (score$X4 > -20)] <- 0

semi$X5 <- semi$X4 - semi$X3

##
colnames(patt) <- c("lon", "lat", "rec_e", "rec_l", "rec_s", "mod_e", "mod_l", "mod_s", "sites")
colnames(score) <- c("lon", "lat", "rec_score", "mod_score", "mod-rec")
colnames(semi) <- c("lon", "lat", "rel_rec", "rel_mod", "rel_diff")

#######
#print(patt, digits = 2)
#

#### calculating kappa
kap <- kappa2(all[,3:4], "unweighted")
print(c("kappa_all: ", kap$value))

kapse <- kappa2(semi[,3:4], "unweighted")
print(c("kappa_semi: ", kapse$value))

##############################
# prints the main statistic
print(c("number of records:",nrow(all)))
print(c("agreement(semi):",(sum(semi$rel_diff== 0)/(nrow(all))) ))
as.data.frame(table(as.vector(semi$rel_diff)))


###### write output files
write.table (score[,1:3], file="reltime_recs.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
write.table (score[,c(1,2,4)], file="reltime_mod.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
write.table (score[,], file="reltime_all.csv", sep = "\t", row.names=FALSE, col.names=FALSE)

write.table (patt[,], file="patt_count_all.csv", sep = "\t", row.names=FALSE, col.names=TRUE)
write.table (semi[,], file="semi_all.csv", sep = "\t", row.names=FALSE, col.names=TRUE)

write.table (semi[,1:3], file="semi_time_recs.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
write.table (semi[,c(1,2,4)], file="semi_time_mod.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
write.table (semi[,c(1,2,5)], file="semi_time_diff.csv", sep = "\t", row.names=FALSE, col.names=FALSE)

write.table (all[,c(1,2,5)], file="total_diff_mod_recs.csv", sep = "\t", row.names=FALSE, col.names=FALSE)
####

