#!/usr/bin/env Rscript
# program to plot the BNS for all individual biomes

library(lattice)


args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==7) {
  # list input files
  args[1] 
}

# reading a table with the BNS for all individual biomes, PFT-based and climate-based biomisation
score = read.table(args[1], header=TRUE)

###########################
############################ # BNS - plot
###########################

pdf("BNS.pdf")
val = c(0.2,0.5,0.8)

labels=c("poor", "fair", "(very)good", "excellent")
key.list <- list(corner=c(1,1.05), border=TRUE, background="white",
                 points=list(pch=c(4,19), col=c("blue","red"), cex=1),
                 text=list(c("climate-based","PFT-based"))
                 )
grafik <- dotplot(reorder(score$Biome,-score$Nr) ~ score$Score_Cli + score$Score_PFT, data=score,
                  col=c("blue","red"), pch=c(4,19),cex=1.0,  xlim=c(0.0,1),
                  xlab="BNS", key = key.list, scales=list(cex=1, alternating=1))
                          
update(grafik, panel = function(...){panel.grid(h=-1,v=-20)
                                     panel.dotplot(...)
                                     panel.abline(v=val, col.line="black", lty=2)
                                     ltext(c(0.1,0.36,0.65,0.9),c(5.5,5.5,5.5,5.5), labels=c("bad", "fair to good", "(very)good", "best"), col="grey", cex=1) } )                                 
               
###
