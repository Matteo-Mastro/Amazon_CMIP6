#!/bin/bash

## ----- Compute ensemble means on CMIP6 data ----- ##

cd "/mnt/d/Data/CMIP6" 					# HDEXT
# cd "/mnt/c/Users/mastr/Documents/Amazon/CMIP6"                  # PC

base="/mnt/d/Data/CMIP6"		                        # HDEXT
# base= "/mnt/c/Users/mastr/Documents/Amazon/CMIP6"		# PC

out_dir="/mnt/c/Users/mastr/Documents/Amazon/ENSO"                  # for tos
# out_dir="/mnt/c/Users/mastr/Documents/Amazon/analysis"            # for other variables

scenario=(ssp585) #(ssp585 historical) #ssp370 ssp534-over) 

model=(CanESM5 CMCC-ESM2 CNRM-ESM2-1 ACCESS-ESM1-5 IPSL-CM6A-LR MIROC-ES2L UKESM1-0-LL MPI-ESM1-2-LR CESM2-WACCM) 

vars=(tos) #(tas mrso nbp pr tna tsa pmm)

for ss in ${scenario[@]}; do		## Loop over all scenarios

    	for mm in ${model[@]}; do  		## Loop over all models
                realiz=$(ls ${base}/${ss}/${mm})

                for vv in ${vars[@]}; do 			## Loop over variables of interest

                        for rr in ${realiz[@]}; do			## Loop over all the realizations (overcome different forcings prob)
			dir="${base}/${ss}/${mm}/${rr}"
			f=($(ls ${dir}/${vv}_*))

                        if [ ${vv} == tos ]; then
                		if [ ${mm} == CMCC-ESM2 ] || [ ${mm} == CNRM-ESM2-1 ] || [ ${mm} == IPSL-CM6A-LR ] || [ ${mm} == MPI-ESM1-2-LR ]|| [ ${mm} == CanESM5 ]; then
				##  curvilinear grid need nearest neighbour remapping
				cdo -L -remapdis,r360x180 -sellonlatbox,0,360,-90,90 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_1x1_old.nc  	#-remapnn,global_1
				else
				cdo -L -remapbil,r360x180 -sellonlatbox,0,360,-90,90 ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_1x1_old.nc
				fi
                        fi
                        done # rr

                        # ENSEMBLE MEANS
                        cdo -L -O -ensmean -setcalendar,gregorian -sellonlatbox,0,360,-90,90 ${out_dir}/${vv}_${mm}_${ss}_${rr}_1x1_old.nc ${out_dir}/${vv}_${mm}_${ss}_ensmean_1x1.nc
                        # rm ${out_dir}/${vv}_${mm}_${ss}_r*_1x1_old.nc
                done # mm

	done # vv

done # ss

exit
