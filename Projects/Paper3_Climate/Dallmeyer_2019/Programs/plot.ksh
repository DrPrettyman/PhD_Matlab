#!/bin/ksh
#set -ex
# korn shell script for plotting the calculated biome distributions, the original PFT-distributions and the metrics. 
#--------------------------------------------------------------------------------------------------------------------
# 1.) global plots using GMT (Generic Mapping Tool: Wessel, P., W. H. F. Smith, R. Scharroo, J. Luis, and F. Wobbe, Generic Mapping Tools:
#     Improved Version Released, EOS Trans. AGU, 94(45), p. 409-410, 2013. doi:10.1002/2013EO450001. see: https://www.soest.hawaii.edu/gmt/
#     i.e. mega biome distribution for the PFT-based biomisation, the climate-based biomisation (if biome1=1 in the main program) and the reference. 
#     if palaeo = 0, a gridded map of the Reference (here RF99) is plotted,
#     for palaeo data, the biomes reconstructed at the individual sites are plotted as dots on the calculated biome distribution.
#     The colortables used in the GMT plot scripts are provided in the folder GMTadd
#
#     The PFT-distributions are plotted, if preproc=1 in the main program
#     The modus 'global plot' can also be change to regional plots (North Africa, Asia)
#
#     output: ${model}_${simid}_${timid}_biomePFT_${region}.pdf            (displaying PFT-based and climate-based biomisation (if biome1=1))
#             ${model}_${simid}_${timid}_biome_reference_${region}.pdf     (displaying the reference biome distribution (if palaeo = 0)) 
#             ${model}_${simid}_${timid}_biomePFT_recs_${region}.pdf       (displaying the biome distribution and the records on top  (if palaeo = 1))
#             ${model}_${simid}_${timid}_bio_agreement_${region}.pdf       (displaying the agreement (BNS) between all sites and the calculated biome distribution (if palaeo = 1 and metric = 1))
#             ${model}_${simid}_${timid}_PFT_MAIN_${region}.pdf            (displaying the main PFT distribution (if preproc = 1))
#
# 2.) metric plots, using R (R Core Team (2014). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.
#           URL http://www.R-project.org/ , including the follwing packages:
#           'ncdf4' -> David Pierce (2014). ncdf4: Interface to Unidata netCDF (version 4 or earlier) format data files. R package version 1.13. http://CRAN.R-project.org/package=ncdf4
#           'plotrix' -> Lemon, J. (2006) Plotrix: a package in the red light district of R. R-News, 6(4): 8-12. 
#           'lattice' -> -> Sarkar, Deepayan (2008) Lattice: Multivariate Data Visualization with R. Springer, New York. ISBN 978-0-387-75968-5
#
#     output:
#            ${model}_${simid}_${timid}_fss.pdf                           (dotplot showing all FSS, if data is gridded)
#            ${model}_${simid}_${timid}_kappa.pdf                         (dotplot showing individual kappa, if data is gridded)
#            ${model}_${simid}_${timid}_bns.pdf                           (dotplot showing all BNS, here only if palaeo = 1)
#
#            ${model}_${simid}_${timid}_zm_PFT.pdf                        (zonal mean PFT fractions)
#            ${model}_${simid}_${timid}_zm_biomes.pdf                     (zonal mean biome fractions)
#	     ${model}_${simid}_${timid}_taylorPlot_zm.pdf                 (Taylor plot for the zonal mean biome fractions)
#            ${model}_${simid}_${timid}_stats.txt                         (List with the data used for the Taylor Plot (normalized centered RMSE, normalized  standard deviation,
#                                                                            Pearson correlation coefficient)
###########################################################

#1.)
region=global
     case ${region} in
	  "global")
	      setting='-R-180/180/-61/90 -B60g30/30g15'
	      tset='120 10'
	      ;;
	 "Nafrica")
	     setting='-R-28/68/-5/40 -B30g15/15g5'
	     tset='63 15'
	     ;;
	 "Asia")
	     setting='-R29/180/11/82 -B40g20/15g15'
	     tset='175 40'
	     ;;
     esac
#---------------------------------
# a.) mega-biome based on PFT and (optional if biome1=1 based on climate)

ps=${model}_${simid}_${timid}_biomePFT_${region}

GMT gmtset PAGE_ORIENTATION portrait
GMT gmtset ANOT_FONT_SIZE 12
GMT gmtset ANOT_OFFSET 0.4c
GMT gmtset HEADER_FONT_SIZE 15p
GMT gmtset BASEMAP_TYPE plain
GMT gmtset BASEMAP_AXES WeSn
GMT gmtset FRAME_PEN 1.1p/1.1p/1.1p/1.1p
GMT gmtset GRID_PEN_PRIMARY 1.25p/200/200/200
GMT gmtset TICK_LENGTH 0.0c
GMT gmtset PLOT_DEGREE_FORMAT F
GMT gmtset LABEL_OFFSET 0.0c
GMT gmtset GRID_PEN_PRIMARY default,black

GMT psscale  -D2i/1.3i/2i/0.4i -L0.1 -S -C./../Programs/GMTadd/cobiome4_mega.cpt -K  > $ps

GMT gmtset HEADER_OFFSET -0.3c
GMT gmtset GRID_PEN_PRIMARY default,grey
GMT gmtset ANOT_OFFSET_PRIMARY 0.1c
GMT gmtset TICK_LENGTH 0.0c

GMT grdimage "${model}_${simid}_${timid}_biomePFT.nc?cover_fract[0,0]" -JQ10/30/14.5c -Y7i -X1  -Sn ${setting}:."biomes based on PFTs:" -C./../Programs/GMTadd/cobiome4_mega.cpt -O -K >> $ps
GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
	 
if [ "$biome1" -eq 1 ] ; then
GMT grdimage "${model}_${simid}_${timid}_bio1out.nc?Mega-Biomes[0,0]" -J -Y-3.8i -Sn ${setting}:."biomes based on climate:" -C./../Programs/GMTadd/cobiome4_mega.cpt -O -K >> $ps
GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps  
fi

pstext -R -J -Ggrey -O -P -Y-5.2i -X1.2i <<EOF >> $ps  
$tset 14 0 26 BR  ${model} ${simid} ${timid}
EOF

ps2pdf $ps $ps.pdf
rm $ps
 
#----------------------------------------------------------------------------------------------
# b) biome reference
if [ "$palaeo" -eq 0 ] ; then
    
    ps=${model}_${simid}_${timid}_biome_reference_${region}
    
    GMT gmtset PAGE_ORIENTATION portrait
    GMT gmtset ANOT_FONT_SIZE 12
    GMT gmtset ANOT_OFFSET 0.4c
    GMT gmtset HEADER_FONT_SIZE 15p
    GMT gmtset BASEMAP_TYPE plain
    GMT gmtset BASEMAP_AXES WeSn
    GMT gmtset FRAME_PEN 1.1p/1.1p/1.1p/1.1p
    GMT gmtset GRID_PEN_PRIMARY 1.25p/200/200/200
    GMT gmtset TICK_LENGTH 0.0c
    GMT gmtset PLOT_DEGREE_FORMAT F
    GMT gmtset LABEL_OFFSET 0.0c
    GMT gmtset GRID_PEN_PRIMARY default,black
    
    GMT psscale  -D2i/1.3i/2i/0.4i -L0.1 -S -C./../Programs/GMTadd/cobiome4_mega.cpt -K  > $ps
    
    GMT gmtset HEADER_OFFSET -0.3c
    GMT gmtset GRID_PEN_PRIMARY default,grey
    GMT gmtset ANOT_OFFSET_PRIMARY 0.1c
    GMT gmtset TICK_LENGTH 0.0c
    
    GMT grdimage "reference_veg_${igrid}_${simid}.nc?var1[0,0]" -JQ10/30/14.5c -Y7i -X1  -Sn ${setting}:."RF 99 biome distribution:" -C./../Programs/GMTadd/cobiome4_mega.cpt -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    
    pstext -R -J -Ggrey -O -P -Y-5.2i -X1.2i <<EOF >> $ps  
$tset 14 0 26 BR  ${model} ${simid} ${timid}
EOF

    ps2pdf $ps $ps.pdf
    rm $ps
else
 
    ps=${model}_${simid}_${timid}_biomePFT_recs_${region}
    
    GMT gmtset PAGE_ORIENTATION portrait
    GMT gmtset ANOT_FONT_SIZE 12
    GMT gmtset ANOT_OFFSET 0.4c
    GMT gmtset HEADER_FONT_SIZE 15p
    GMT gmtset BASEMAP_TYPE plain
    GMT gmtset BASEMAP_AXES WeSn
    GMT gmtset FRAME_PEN 1.1p/1.1p/1.1p/1.1p
    GMT gmtset GRID_PEN_PRIMARY 1.25p/200/200/200
    GMT gmtset TICK_LENGTH 0.0c
    GMT gmtset PLOT_DEGREE_FORMAT F
    GMT gmtset LABEL_OFFSET 0.0c
    GMT gmtset GRID_PEN_PRIMARY default,black
    
    GMT psscale  -D3.1i/2i/4.5i/0.2ih -L0.1 -S -C./../Programs/GMTadd/cobiome4_makro12_list.cpt -K  > $ps
    
    GMT gmtset HEADER_OFFSET -0.3c
    GMT gmtset GRID_PEN_PRIMARY default,grey
    GMT gmtset ANOT_OFFSET_PRIMARY 0.1c
    GMT gmtset TICK_LENGTH 0.0c
    
    
    GMT grdimage "${model}_${simid}_${timid}_biomePFT.nc?cover_fract[0,0]" -JQ10/30/14.5c -Y7i -X1  -Sn ${setting}:."biomes based on PFTs:" -C./../Programs/GMTadd/cobiome4_mega.cpt -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    psxy -R -J -O -K ./../records/biome6000new_${timid}.csv -C./../Programs/GMTadd/cobiome4_mega.cpt -Sc0.06i -Wthinnest >> $ps

    
    if [ "$biome1" -eq 1 ] ; then
	
    GMT grdimage "${model}_${simid}_${timid}_bio1out.nc?Mega-Biomes[0,0]" -J -Y-3.8i -Sn ${setting}:."biomes based on climate:" -C./../Programs/GMTadd/cobiome4_mega.cpt -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps  
    psxy -R -J -O -K ./../records/biome6000new_${timid}.csv -C./../Programs/GMTadd/cobiome4_mega.cpt -Sc0.06i -Wthinnest >> $ps
    fi
    
    pstext -R -J -Ggrey -O -P -Y-5.2i -X1.2i <<EOF >> $ps  
$tset 14 0 26 BR  ${model} ${sim} ${timid}
EOF
	 
    ps2pdf $ps $ps.pdf
    rm $ps
fi
#-----------------------------------------
# c) biome agreement (BNS) in comparison with the pollen records 
if [ "$palaeo" -eq 1 -a "$metric" -eq 1 ] ; then

    ps=${model}_${simid}_${timid}_bio_agreement_${region}
     
    GMT gmtset PAGE_ORIENTATION portrait
    GMT gmtset ANOT_FONT_SIZE 12
    GMT gmtset ANOT_OFFSET 0.4c
    GMT gmtset HEADER_FONT_SIZE 15p
    GMT gmtset BASEMAP_TYPE plain
    GMT gmtset BASEMAP_AXES WeSn
    GMT gmtset FRAME_PEN 1.1p/1.1p/1.1p/1.1p
    GMT gmtset GRID_PEN_PRIMARY 1.25p/200/200/200
    GMT gmtset TICK_LENGTH 0.0c
    GMT gmtset PLOT_DEGREE_FORMAT F
    GMT gmtset LABEL_OFFSET 0.0c
    GMT gmtset GRID_PEN_PRIMARY default,black
    
    GMT psscale  -D3.1i/2i/4.5i/0.2ih -C./../Programs/GMTadd/bio_agree.cpt -K  > $ps
    
    GMT gmtset HEADER_OFFSET -0.3c
    GMT gmtset GRID_PEN_PRIMARY default,grey
    GMT gmtset ANOT_OFFSET_PRIMARY 0.1c
    GMT gmtset TICK_LENGTH 0.0c
    
    
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -JQ10/30/14.5c -Y7i -X1 -Sn ${setting}:."biome (PFT) agreement:" -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -K -O >> $ps
    psxy -R -J -O -K ./score_${model}_${simid}_${timid}_PFT.csv -C./../Programs/GMTadd/bio_agree.cpt -Sc0.06i -Wthinnest >> $ps

    if [ "$biome1" -eq 1 ] ; then
    
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J -Y-3.8i -Sn ${setting}:."biome (Cli) agreement:" -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -O -K >> $ps  
    psxy -R -J -O -K ./score_${model}_${simid}_${timid}_Clim.csv -C./../Programs/GMTadd/bio_agree.cpt -Sc0.06i -Wthinnest >> $ps

    fi
    
    case ${region} in
	"global")
	    tset='120 10'
	    ;;
	"Nafrica")
	    tset='63 15'
	    ;;
	"Asia")
	    tset='175 40'
	    ;;
    esac
    pstext -R -J -Ggrey -O -P -Y-5.2i -X1.2i <<EOF >> $ps  
$tset 14 0 26 BR  ${model} ${sim} ${timid}
EOF
     
    ps2pdf $ps $ps.pdf
    rm $ps
fi
#-----------------------------------------
# d) Main PFTs
#############
if [ "$preproc" -eq 1 ] ; then

    ps=${model}_${simid}_${timid}_PFT_MAIN_${region}

    GMT gmtset PAGE_ORIENTATION portrait
    GMT gmtset ANOT_FONT_SIZE 10
    GMT gmtset ANOT_OFFSET 0.4c
    GMT gmtset HEADER_FONT_SIZE 13p
    GMT gmtset BASEMAP_TYPE plain
    GMT gmtset BASEMAP_AXES Wesn
    GMT gmtset FRAME_PEN 1.1p/1.1p/1.1p/1.1p
    GMT gmtset GRID_PEN_PRIMARY 1.25p/200/200/200
    GMT gmtset TICK_LENGTH 0.0c
    GMT gmtset PLOT_DEGREE_FORMAT F
    GMT gmtset LABEL_OFFSET 0.0c
    GMT gmtset GRID_PEN_PRIMARY default,black
    
    GMT psscale  -D3.1i/1.2i/4.5i/0.2ih -C./../Programs/GMTadd/coveg4_o.cpt -K  -L > $ps
    GMT psscale  -D3.1i/0.5i/4.5i/0.2ih -C./../Programs/GMTadd/codesert_o.cpt -K -O -L >> $ps
    GMT gmtset HEADER_OFFSET -0.3c
    GMT gmtset GRID_PEN_PRIMARY default,grey
    GMT gmtset ANOT_OFFSET_PRIMARY 0.1c
    GMT gmtset TICK_LENGTH 0.0c
    
    GMT grdimage "${model}_${simid}_${timid}_FOREST.nc?cover_fract[0,0]" ${setting}:."forest:" -JQ0/30/8c -Y8i -Sn -C./../Programs/GMTadd/coveg4.cpt -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthin,black -B -O -K >> $ps
    #
    GMT gmtset BASEMAP_AXES wesn
    GMT grdimage "${model}_${simid}_${timid}_SHRUBS.nc?cover_fract[0,0]" -J -X3.5i -Sn ${setting}:."shrubs :" -C./../Programs/GMTadd/coveg4.cpt -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthin,black -B -O -K >> $ps
    #
    GMT gmtset BASEMAP_AXES Wesn
    GMT grdimage "${model}_${simid}_${timid}_GRASS.nc?cover_fract[0,0]" -J -Y-5 -X-3.5i -Sn ${setting}:."grass:" -C./../Programs/GMTadd/coveg4.cpt  -O -K >> $ps
    GMT grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    #
    gmtset BASEMAP_AXES wesn
    grdimage "${model}_${simid}_${timid}_DESfrac.nc?desert_fpc[0,0]" -J -X3.5i -Sn ${setting}:."desert :" -C./../Programs/GMTadd/codesert.cpt  -O -K >> $ps
    grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    #
    gmtset BASEMAP_AXES WeSn
    grdimage "${model}_${simid}_${timid}_WOODY.nc?cover_fract[0,0]"  -J -Y-5 -X-3.5i -Sn ${setting}:."woody:" -C./../Programs/GMTadd/coveg4.cpt  -O -K >> $ps
    grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    #
    gmtset BASEMAP_AXES weSn
    grdimage "${model}_${simid}_${timid}_VEGCOV.nc?cover_fract[0,0]" -J -X3.5i -Sn ${setting}:."total natural veg. :" -C./../Programs/GMTadd/coveg4.cpt  -O -K >> $ps
    grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    #
    if [ "$LU" -eq 1 ] ; then
	gmtset BASEMAP_AXES WeSn
	grdimage "${model}_${simid}_${timid}_LU.nc?cover_fract[0,0]" -J -Y-5.5 -X-3.5i -Sn ${setting}:."land use:" -C./../Programs/GMTadd/coveg4.cpt  -O -K >> $ps
	grdcontour "${model}_${simid}_${timid}_slm.nc?lsm[0,0]" -R -J  -C./../Programs/GMTadd/lsm.d -A1000 -Wthick,black -B -O -K >> $ps
    fi
    
    case ${region} in
	"global")
	    tset='160 10'
	    tset2='160 -60'
	    tset3='180 -60'
	    ;;
	"Nafrica")
	    tset='63 15'
	    tset2='63 -4'
	    tset3='66 -4'
	    ;;
	"Asia")
	    tset='175 40'
	    tset2='175 12'
	    tset3='180 15'
	    ;;
    esac
    pstext -R -J -Gblack -O -K -P -Y-4 -X8.7 <<EOF >> $ps  
$tset 12 0 0 BR  veg. fraction
$tset2 12 0 0 BR  des. fraction
EOF
    pstext -R -J -Ggrey -O -P -Y-2.8 -X1.1 <<EOF >> $ps  
$tset3 14 0 26 BR  ${model} ${sim} ${timid}
EOF
    ps2pdf $ps $ps.pdf
    rm $ps
fi
###########
####################################################################
# 2.) metric plots, using R
if [ "$metric" -eq 1 ] ; then
    
    if [ "$palaeo" -eq 0 ] ; then
    Rscript --vanilla ./../Programs/plot_metric.r ${model}_${simid}_${timid}_kappa.txt ${model}_${simid}_${timid}_fss.txt

    mv fss.pdf ${model}_${simid}_${timid}_fss.pdf
    mv kappa.pdf ${model}_${simid}_${timid}_kappa.pdf

    else
	Rscript --vanilla ./../Programs/plot_BNS.r ${model}_${simid}_${timid}_bns.txt
	 mv BNS.pdf ${model}_${simid}_${timid}_BNS.pdf
    fi
#-------------------------------------------------------------------------------------------
#
    if [ "$zonmn" -eq 1 -a  "$biome1" -eq 1 -a "$palaeo" -eq 0 ] ; then
	
	Rscript --vanilla ./../Programs/zon_mean_plot.r ${model}_${simid}_${timid}_PFT_zonalmeans.txt ${model}_${simid}_${timid}_biome_zonalmeans.txt ${model}_${simid}_${timid}_bio1_zonalmeans.txt reference_veg_${igrid}_${simid}_zonalmeans.txt ${model}_${simid}_${timid}_VEGCOV_zm.nc ${model}_${simid}_${timid}

	mv zon_area_PFT.pdf ${model}_${simid}_${timid}_zm_PFT.pdf
	mv zon_area_biomes.pdf ${model}_${simid}_${timid}_zm_biomes.pdf
	mv taylor_biome_zm.pdf ${model}_${simid}_${timid}_taylorPlot_zm.pdf
    fi
fi
##########################################################
######################## end
######
 
