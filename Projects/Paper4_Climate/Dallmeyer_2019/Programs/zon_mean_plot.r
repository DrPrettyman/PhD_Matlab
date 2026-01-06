#!/usr/bin/env Rscript
# program to plot the zonal mean PFT- and biome fractions
#  input: ${model}_${simid}_${timid}_zonalmeans.txt
#         ${model}_${simid}_${timid}_biome_zonalmeans.txt
#  	  ${model}_${simid}_${timid}_bio1_zonalmeans.txt
#	  reference_veg_${igrid}_${simid}_zonalmeans.txt
#	  ${model}_${simid}_${timid}_VEGCOV_zm.nc
#
# output: ${model}_${simid}_${timid}_zm_PFT.pdf                       
#         ${model}_${simid}_${timid}_zm_biomes.pdf                 
#         ${model}_${simid}_${timid}_taylorPlot_zm.pdf             
#         ${model}_${simid}_${timid}_stats.txt 
##########################################################

library(ncdf4)
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==7) {
  # list input files
  args[1:6] 
}

#######
#reading data
pftzm = read.table(args[1], header=TRUE)
biomezm = read.table(args[2], header=TRUE)
bio1zm = read.table(args[3], header=TRUE)
refzm = read.table(args[4], header=TRUE)
zonveg <- nc_open(args[5])
lat <- ncvar_get(zonveg, "lat")
latdf <- data.frame(lat)
nc_close(zonveg)

pftzml <- cbind(latdf,pftzm/1E+12)
biomezml  <- cbind(latdf,biomezm/1E+12)
bio1zml <- cbind(latdf,bio1zm/1E+12)
refzml <- cbind(latdf,refzm/1E+12)

##### plot zonal area of PFTs
pdf("zon_area_PFT.pdf")

par(mfrow = c(2, 3))
par(cex = 0.8)
par(mar = c(0.4, 0.4, 0.4, 0.4), oma = c(4, 4, 0.5, 0.5))
par(tcl = -0.25)
par(mgp = c(2, 0.6, 0))
with(pftzml,plot(lat,Forest, type="l", col="red", axes=FALSE, lwd=2, ylim=c(0,5)))
mtext("Forest", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,1,2,3,4,5))
axis(1,at=45*-90:90, labels=FALSE)
box()

with(pftzml,plot(lat,Shrubs, type="l", col="red", axes=FALSE, ann=T, lwd=2, ylim=c(0,5)))
mtext("Shrubs", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,1,2,3,4,5), labels=FALSE)
axis(1,at=45*-90:90, labels=FALSE)
box()

with(pftzml,plot(lat,Grass, type="l", col="red", axes=FALSE, lwd=2, ylim=c(0,5)))
mtext("Grass", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,1,2,3,4,5), labels=FALSE)
axis(1,at=45*-90:90, labels=FALSE)
box()

with(pftzml,plot(lat,Desert, type="l", col="red", axes=FALSE, lwd=2, ylim=c(0,5)))
mtext("Desert", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(1,at=45*-90:90)
axis(2, las=1, at=c(0,1,2,3,4,5))
box()

with(pftzml,plot(lat,Woody, type="l", col="red", axes=FALSE, lwd=2, ylim=c(0,5)))
mtext("Woody", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(1,at=45*-90:90)
axis(2, las=1, at=c(0,1,2,3,4,5), labels=FALSE)
box()

with(pftzml,plot(lat,Vegcov, type="l", col="red", axes=FALSE, lwd=2, ylim=c(0,5)))
mtext("Total Veg.", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(1,at=45*-90:90)
axis(2, las=1, at=c(0,1,2,3,4,5), labels=FALSE)
box()

mtext("latitude", side = 1, outer = TRUE, cex = 1.0, line = 2.2, col="black")
mtext("zonal area [Mio. km²]", side = 2, outer = TRUE, cex = 1.0, line = 2.2, col="black")

dev.off()

########################################################
# zonal area Biomes in ref., climate based and calculated from PFTs
###
pdf("zon_area_biomes.pdf")

par(mfrow = c(2, 3))
par(cex = 0.8)
par(mar = c(0.4, 0.4, 0.4, 0.4), oma = c(4, 4, 0.5, 0.5))
par(tcl = -0.25)
par(mgp = c(2, 0.6, 0))
plot(refzml$lat, refzml$Forest, type="l", col="black", axes=FALSE, lwd=2,  ylim=c(0,7) )
lines(refzml$lat, bio1zml$Forest, type="l", col="blue", lwd=2, lty=2)
lines(refzml$lat, biomezml$Forest, type="l", col="red", lwd=2, lty=2)
mtext("Forest", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,2,4,6,8))
axis(1,at=45*-90:90, labels=FALSE)
box()

plot(refzml$lat, refzml$Woody, type="l", col="black", axes=FALSE, lwd=2,  ylim=c(0,7) )
lines(refzml$lat, bio1zml$Woody, type="l", col="blue", lwd=2, lty=2)
lines(refzml$lat, biomezml$Woody, type="l", col="red", lwd=2, lty=2)
mtext("Woody", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,2,4,6,8), labels=FALSE)
axis(1,at=45*-90:90, labels=FALSE)
box()

plot(refzml$lat, refzml$Grass, type="l", col="black", axes=FALSE, lwd=2,  ylim=c(0,7) )
lines(refzml$lat, bio1zml$Grass, type="l", col="blue", lwd=2, lty=2)
lines(refzml$lat, biomezml$Grass, type="l", col="red", lwd=2, lty=2)
mtext("Grass", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(2, las=1, at=c(0,2,4,6,8), labels=FALSE)
axis(1,at=45*-90:90)
box()

plot(refzml$lat, refzml$Desert, type="l", col="black", axes=FALSE, lwd=2,  ylim=c(0,7) )
lines(refzml$lat, bio1zml$Desert, type="l", col="blue", lwd=2, lty=2)
lines(refzml$lat, biomezml$Desert, type="l", col="red", lwd=2, lty=2)
mtext("Desert", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(1,at=45*-90:90)
axis(2, las=1, at=c(0,2,4,6,8))
box()

plot(refzml$lat, refzml$Tundra, type="l", col="black", axes=FALSE, lwd=2,  ylim=c(0,7) )
lines(refzml$lat, bio1zml$Tundra, type="l", col="blue", lwd=2, lty=2)
lines(refzml$lat, biomezml$Tundra, type="l", col="red", lwd=2, lty=2)
mtext("Tundra", side=3, line=-1.7, adj=0.1,cex =0.8, col="black")
axis(1,at=45*-90:90)
axis(2, las=1, at=c(0,2,4,6,8), labels=FALSE)
box()


mtext("latitude", side = 1, outer = TRUE, cex = 1.0, line = 2.2, col="black")
mtext("zonal area of biomes [Mio. km²]", side = 2, outer = TRUE, cex = 1.0, line = 2.2, col="black")
plot(1, type = "n", axes=FALSE, xlab="", ylab="")

legend(x="center", inset = 0, legend=c("reference","climate-based","PFT-based"),pch=13,col=c("black","blue","red"), xpd=NA)
##########################################
############################################
#taylor diagramm
###################
library(plotrix)
pdf("taylor_biome_zm.pdf")
taplot <- taylor.diagram(refzml$Tundra,biomezml$Tundra,add=FALSE,col="mediumpurple3",pch=19,xlab="standard deviation",ylab="standard deviation",main="Taylor Diagram zonal biome area",show.gamma=TRUE, ngamma=5, sd.arcs=5, ref.sd=TRUE, grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Grass,biomezml$Grass,add=TRUE,col="green",pch=19,show.gamma=TRUE, ngamma=5, pos.cor = TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Woody,biomezml$Woody,add=TRUE,col="tan4",pch=19,show.gamma=TRUE, ngamma=5, pos.cor = TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Forest,biomezml$Forest,add=TRUE,col="darkgreen",pch=19, ngamma=5, pos.cor = TRUE, show.gamma=TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Desert,biomezml$Desert,add=TRUE,col="yellow",pch=19, ngamma=5, pos.cor = TRUE, show.gamma=TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)



taylor.diagram(refzml$Tundra,bio1zml$Tundra,add=TRUE,col="mediumpurple3",pch=4,show.gamma=TRUE, ngamma=5, pos.cor = TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Grass,bio1zml$Grass,add=TRUE,col="green",pch=4,show.gamma=TRUE, ngamma=5, pos.cor = TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Woody,bio1zml$Woody,add=TRUE,col="tan4",pch=4,show.gamma=TRUE, ngamma=5, pos.cor = TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Forest,bio1zml$Forest,add=TRUE,col="darkgreen",pch=4, ngamma=5, pos.cor = TRUE, show.gamma=TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

taylor.diagram(refzml$Desert,bio1zml$Desert,add=TRUE,col="gold",pch=4, ngamma=5, pos.cor = TRUE, show.gamma=TRUE,sd.args=1,ref.sd=TRUE,grad.corr.lines=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99),normalize=TRUE)

legend(2.5,2.5,legend=c("Forest","Grassland","Tundra","Woody","Desert"),pch=13,col=c("darkgreen","green","mediumpurple3","tan4","gold"))


#############################################
#Function that returns Root Mean Squared Error
rmse <- function(error)
{
    sqrt(mean(error^2))
}
 
outname <-as.character(args[6])
ofile <- paste(outname,"stats.txt", sep="_") 

#######################
reference <- as.vector(refzml$Forest)
pftmod <- as.vector(biomezml$Forest)
climod <- as.vector(bio1zml$Forest)

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- err
errmc <- errc

sink(ofile)
cat("================\n")
cat("RMSE\n")
cat("================\n")
cat("FOREST\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
   
sink()

reference <- as.vector(refzml$Grass)
pftmod <- as.vector(biomezml$Grass)
climod <- as.vector(bio1zml$Grass)

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err
errmc <- errmc + err

sink(ofile, append=TRUE)

cat("================\n")
cat("GRASS\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
   
sink()

reference <- as.vector(refzml$Desert)
pftmod <- as.vector(biomezml$Desert)
climod <- as.vector(bio1zml$Desert)

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err
errmc <- errmc + err

sink(ofile, append=TRUE)

cat("================\n")
cat("DESERT\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")


reference <- as.vector(refzml$Woody)
pftmod <- as.vector(biomezml$Woody)
climod <- as.vector(bio1zml$Woody)

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err
errmc <- errmc + err

sink(ofile, append=TRUE)

cat("================\n")
cat("WOODY\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
#
reference <- as.vector(refzml$Tundra)
pftmod <- as.vector(biomezml$Tundra)
climod <- as.vector(bio1zml$Tundra)

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)
errm <- (errm + err)/5
errmc <- (errmc + err)/5

sink(ofile, append=TRUE)

cat("================\n")
cat("TUNDRA\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
cat("================\n")
cat("mean RMSE (all)\n")    
cat("PFT-based RMSE: ", errm, " Clim.-based RMSE: ", errmc, "\n")
cat("================\n")
cat("############################################################\n")
cat("================\n")

sink()

###############################
####### Correlation#####
################################

corPFT <- diag(cor(refzm, biomezm, method="pearson"))
corCLI <- diag(cor(refzm, bio1zm, method="pearson"))

sink(ofile, append=TRUE)

cat("Pearsons Correlation Coefficient\n")
cat("================\n")
cat("ref vs. PFT-based\n")    
capture.output(print(corPFT), ofile, append = TRUE)
cat("================\n")
cat("ref vs. climate-based\n")    
capture.output(print(corCLI), ofile, append = TRUE)
cat("================\n")
cat("##################################################\n")
cat("================\n")
sink()

################################
### standard deviation###

set.seed(nrow(biomezml))
sdPFT <- apply(biomezml[2:ncol(biomezml)], 2, sd)
sdCLI <- apply(bio1zml[2:ncol(biomezml)], 2, sd)
sdREF <- apply(refzml[2:ncol(biomezml)], 2, sd)
namesP <- colnames(biomezml[2:ncol(biomezml)])
namesC <- colnames(bio1zml[2:ncol(bio1zml)])
namesR <- colnames(refzml[2:ncol(refzml)])
sink(ofile, append=TRUE)

cat("Standard deviation\n")
cat("================\n")
cat("PFT-based biomes\n")
cat(namesP,"\n")
cat(sdPFT,"\n")
cat("================\n")
cat("climate-based biomes\n")
cat(namesC,"\n")
cat(sdCLI,"\n")
cat("================\n")
cat("reference biomes\n")
cat(namesR,"\n")
cat(sdREF,"\n")
cat("================\n")
cat("##################################################\n")
cat("================\n")

sink()

            
#########################################
# normalized sd (by reference sd, used in Taylor-Plot)
#######################
                                        #
nosdPFT <- (as.vector(sdPFT)/as.vector(sdREF))
nosdCLI <- (as.vector(sdCLI)/as.vector(sdREF))
nosdREF <- (as.vector(sdREF)/as.vector(sdREF))

sink(ofile, append=TRUE)

cat("normalized Standard deviation\n")
cat("================\n")
cat("PFT-based biomes\n")
cat(namesP,"\n")
cat(nosdPFT,"\n")
cat("================\n")
cat("climate-based biomes\n")
cat(namesC,"\n")
cat(nosdCLI,"\n")
cat("================\n")
cat("##################################################\n")
cat("================\n")

sink()


#########################################
# normalized centered rmse (as used in Taylor-Plot)
#########################################

reference <- (as.vector(refzml$Forest) / sdREF[2]) - nosdREF[2]
pftmod <- (as.vector(biomezml$Forest) / sdREF[2]) - nosdPFT[2]
climod <- (as.vector(bio1zml$Forest) / sdREF[2]) - nosdCLI[2]

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- err
errmc <- errc

sink(ofile, append=TRUE)

cat("normalized centered RMSE\n")
cat("================\n")
cat("FOREST\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
   
sink()

reference <- (as.vector(refzml$Grass) / sdREF[3]) - nosdREF[3]
pftmod <- (as.vector(biomezml$Grass) / sdREF[3]) - nosdPFT[3]
climod <- (as.vector(bio1zml$Grass) / sdREF[3]) - nosdCLI[3]

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err 
errmc <- errmc + errc

sink(ofile, append=TRUE)

cat("================\n")
cat("GRASS\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
   
sink()

reference <- (as.vector(refzml$Desert) / sdREF[1]) - nosdREF[1]
pftmod <- (as.vector(biomezml$Desert) / sdREF[1]) - nosdPFT[1]
climod <- (as.vector(bio1zml$Desert) / sdREF[1]) - nosdCLI[1]

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err 
errmc <- errmc + errc

sink(ofile, append=TRUE)

cat("================\n")
cat("Desert\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
   
sink()
#
reference <- (as.vector(refzml$Woody) / sdREF[4]) - nosdREF[4]
pftmod <- (as.vector(biomezml$Woody) / sdREF[4]) - nosdPFT[4]
climod <- (as.vector(bio1zml$Woody) / sdREF[4])  - nosdCLI[4]

error <- pftmod - reference
errorc <- climod -reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- errm + err 
errmc <- errmc + errc

sink(ofile, append=TRUE)

cat("================\n")
cat("Woody\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")

sink()
#
reference <-( as.vector(refzml$Tundra) / sdREF[5]) - nosdREF[5]
pftmod <- (as.vector(biomezml$Tundra) / sdREF[5]) - nosdPFT[5]
climod <- (as.vector(bio1zml$Tundra) / sdREF[5]) - nosdCLI[5]

error <- pftmod - reference
errorc <- climod - reference
err <- rmse(error)
errc <- rmse(errorc)

errm <- (errm + err ) / 5
errmc <- (errmc + errc) / 5

sink(ofile, append=TRUE)

cat("================\n")
cat("TUNDRA\n")    
cat("PFT-based RMSE: ", err, " Clim.-based RMSE: ", errc, "\n")
cat("================\n")
cat("mean norm. centered RMSE (all)\n")    
cat("PFT-based RMSE: ", errm, " Clim.-based RMSE: ", errmc, "\n")
cat("================\n")
cat("############################################################\n")
cat("================\n")
