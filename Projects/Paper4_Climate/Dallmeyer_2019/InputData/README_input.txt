Experimental setups used in the different simulations
******************************************************
MPI-ESM (JSBACH) T63 PI:
------------------------
model="JSBACHC"
climfile="MPI-ESM_r1i1p1_PI_climate.nc"
gddfile="no"
pftfile="MPI-ESM_r1i1p1_PI_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=1
inpol=0
igrid=t63
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++
MPI-ESM (JSBACH) T63 6k:
------------------------
model="JSBACHC"
climfile="MPI-ESM_r1i1p2_6k_climate.nc"
gddfile="no"
pftfile="MPI-ESM_r1i1p2_6k_PFTfract.nc"
icemask="no"

simid="r1i1p2"    
LU=0
inpol=0
igrid=t63
preproc=1

timid="6k"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++
MPI-ESM (JSBACH) T63 LGM:
------------------------
model="JSBACHC"
climfile="MPI-ESM_r1i1p2_LGM_climate.nc"
gddfile="no"
pftfile="MPI-ESM_r1i1p2_LGM_PFTfract.nc"
icemask="no"

simid="r1i1p2"    
LU=0
inpol=0
igrid=t63
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
MPI-ESM (JSBACH) T31 PI:
-------------------------------------------
model="JSBACH"
climfile="MPI-ESM_T31_PI_climate.nc"
gddfile="no"
pftfile="MPI-ESM_T31_PI_PFTfract.nc"
icemask="no"

simid="pmip3"    
LU=0
inpol=0
igrid=t31
preproc=1

timid="0k"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++
MPI-ESM (JSBACH) T31 LGM:
-------------------------------------------
model="JSBACHC"
climfile="MPI-ESM_T31_LGM_climate.nc"
gddfile="no"
pftfile="MPI-ESM_T31_LGM_PFTfract.nc"
icemask="no"

simid="pmip3"    
LU=0
inpol=0
igrid=t31
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
IPSL-ESM (ORCHIDEE) T31 PI:
-------------------------------------------
model="ORCHIDEE"
climfile="IPSL-ESM_T31_PI_climate.nc"
gddfile="no"
pftfile="IPSL-ESM_T31_PI_PFTfract.nc"
icemask="IPSL_PI_GLAC.nc"

simid="r1i1p1"    
LU=1
inpol=1
igrid=t31
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
IPSL-ESM (ORCHIDEE) T63 PI:
-------------------------------------------
model="ORCHIDEE"
climfile="cruts3.2_1901-1910_clim.nc"
gddfile="no"
pftfile="IPSL-ESM_T63_PI_PFTfract.nc"
icemask="IPSL_PI_GLAC.nc"

simid="zhu"    
LU=0
inpol=1
igrid=t63
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
IPSL-ESM (ORCHIDEE) T63 LGM:
-------------------------------------------
model="ORCHIDEE"
climfile="IPSL-ESM_T63_LGM_climate.nc"
gddfile="no"
pftfile="IPSL-ESM_T63_LGM_PFTfract.nc"
icemask="IPSL-ESM_T63_LGM_GLAC.nc"

simid="zhu"    
LU=0
inpol=1
igrid=t63
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=0       
gddcalc=1      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
HadGEM2-ESM (TRIFFID) T63 PI:
-------------------------------------------
model="TRIFFID"
climfile="HadGEM2-ESM_PI_climate.nc"
gddfile="no"
pftfile="HadGEM2-ESM_PI_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=1
inpol=1
igrid=t63
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
HadGEM2-ESM (TRIFFID) T63 LGM:
-------------------------------------------
model="TRIFFID"
climfile="HadGEM2-ESM_6k_climate.nc"
gddfile="no"
pftfile="HadGEM2-ESM_6k_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=0
inpol=1
igrid=t63
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
CLIM-LPJ (LPJ) T63 PI:
-------------------------------------------
model="LPJ"
climfile="cruts3.21_1901-1930_clim.nc"
gddfile="no"
pftfile="CLIM-LPJ_PI_PFTfract.nc"
icemask="ice_5deg.nc"

simid="tkl"    
LU=0
inpol=1
igrid=t63
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
CLIM-LPJ (LPJ) T63 6k:
-------------------------------------------
model="LPJ"
climfile="CLIM-LPJ_6k_climate.nc"
gddfile="no"
pftfile="CLIM-LPJ_6k_PFTfract.nc"
icemask="ice_5deg.nc"

simid="tkl"    
LU=0
inpol=1
igrid=t63
preproc=1

timid="6k"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
MIROC-ESM (SEIB) T63 PI:
-------------------------------------------
model="SEIB"
climfile="MIROC-ESM_PI_climate.nc"
gddfile="no"
pftfile="MIROC-ESM_PI_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=1
inpol=1
igrid=t31
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
MIROC-ESM (SEIB) T63 6k:
-------------------------------------------
model="SEIB"
climfile="MIROC-ESM_6k_climate.nc"
gddfile="no"
pftfile="MIROC-ESM_6k_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=0
inpol=1
igrid=t31
preproc=1

timid="6k"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
MIROC-ESM (SEIB) T63 6k:
-------------------------------------------
model="SEIB"
climfile="MIROC-ESM_LGM_climate.nc"
gddfile="no"
pftfile="MIROC-ESM_LGM_PFTfract.nc"
icemask="no"

simid="r1i1p1"    
LU=0
inpol=1
igrid=t31
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
CLIMBER (VECODE) 10degree PI:
-------------------------------------------
model="VECODE"
climfile="CLIMBER_PI_climate.nc"
gddfile="no"
pftfile="CLIMBER_PI_PFTfract.nc"
icemask="CLIMBER_PI_glac.nc"

simid="tkl"    
LU=0
inpol=0
igrid=10deg
preproc=1

timid="PI"
palaeo=0
bioref="RF"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++
CLIMBER (VECODE) 10degree LGM:
-------------------------------------------
model="VECODE"
climfile="CLIMBER_LGM_climate.nc"
gddfile="no"
pftfile="CLIMBER_LGM_PFTfract.nc"
icemask="CLIMBER_LGM_glac.nc"

simid="tkl"    
LU=0
inpol=0
igrid=10deg
preproc=1

timid="LGM"
palaeo=1
bioref="biome6000"

biome1=1       
gddcalc=0      
plot=1  
zonmn=1 
kappa=1 
metric=1
+++++++++++++++++++++++++++++++++++++++++++
