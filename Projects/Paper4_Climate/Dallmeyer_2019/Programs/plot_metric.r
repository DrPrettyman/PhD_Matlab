#!/usr/bin/env Rscript
library(lattice)
#program to plot the kappa and FSS metric, for all individual biomes and in total
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==7) {
  # list input files
  args[1:2] 
}

#

# reading tables with kappa (kap) and the fractional skill score (fss) for all individual biomes 
# PFT-based and climate-based biomisation
kap = read.table(args[1], header=FALSE)
fss = read.table(args[2], header=TRUE)

###########################
############################ # kappa - plot
###########################
pdf("kappa.pdf")
val = c(0.4,0.75)

labels=c("poor", "fair-to-good", "very.good-to-excellent")
key.list <- list(corner=c(1,1.05), border=TRUE, background="white",
                 points=list(pch=c(4,19), col=c("blue","red"), cex=1),
                 text=list(c("climate-based","PFT-based"))
                 )
grafik <- dotplot(reorder(kap$V2,-kap$V1) ~ kap$V4 + kap$V3, data=kap,
                  col=c("blue","red"), pch=c(4,19),cex=1.0, xlim=c(-0.1,1.1), 
                  xlab="kappa", key = key.list, scales=list(cex=1, alternating=1))
                          
update(grafik, panel = function(...){panel.grid(h=-1,v=-20)
                                     panel.dotplot(...)
                                     panel.abline(v=val, col.line="black", lty=2)
                                     ltext(c(0.18,0.58,0.9,0.9,0.9),c(5.5,5.5,6,5.5,5), labels=c("poor", "fair-to-good", "very good", "to", "excellent"), col="grey", cex=1)} )


###############

   ###########################
############################ # fss - plot
###########################

pdf("fss.pdf")
val = c(-0.45,0,0.55)

labels=c("poor", "fair", "(very)good", "excellent")
key.list <- list(corner=c(1,1.05), border=TRUE, background="white",
                 points=list(pch=c(4,19), col=c("blue","red"), cex=1),
                 text=list(c("climate-based","PFT-based"))
                 )
grafik <- dotplot(reorder(fss$Biome,-fss$Nr) ~ fss$rFSS_Cli + fss$rFSS_PFT, data=fss,
                  col=c("blue","red"), pch=c(4,19),cex=1.0,  xlim=c(-0.6,0.6),
                  xlab="fss", key = key.list, scales=list(cex=1, alternating=1))
                          
update(grafik, panel = function(...){panel.grid(h=-1,v=-20)
                                     panel.dotplot(...)
                                     panel.abline(v=val, col.line="black", lty=2)
                                     ltext(c(-0.52,-0.22,0.25,0.542),c(5.5,5.5,5.5,5.5), labels=c("bad", "fair to good", "(very)good", "best"), col="grey", cex=1) } )                                 
               
###
