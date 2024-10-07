#!/bin/bash
sudo mount -t drvfs F: /mnt/f

## ----- Compute ensemble means on CMIP6 data ----- ##
cd "/mnt/f/Data/CMIP6" 					# HDEXT
base="/mnt/f/Data/CMIP6"
out_dir="/mnt/f/Data/analysis"		                        # HDEXT
# base= "/mnt/c/Users/mastr/Documents/Amazon/CMIP6"		# PC

# out_dir="/mnt/c/Users/mastr/Documents/Amazon/ENSO"                  # for tos
# out_dir="/mnt/c/Users/mastr/Documents/Amazon/analysis"            # for other variables

scenario=(historical)
model=(CESM2) # (ACCESS-ESM1-5 E3SM-1-1-ECA NorESM2-MM TaiESM1 BCC-CSM2-MR CanESM5 CMCC-ESM2 CNRM-ESM2-1 IPSL-CM6A-LR MIROC-ES2L UKESM1-0-LL MPI-ESM1-2-LR CESM2-WACCM) 
var=(tos) #(tas mrso nbp pr tna tsa pmm)

for ss in ${scenario[@]}; do		## Loop over all scenarios

    	for mm in ${model[@]}; do  		## Loop over all models

                for vv in ${var[@]}; do 
                realiz=$(ls ${base}/${ss}/${mm})

                        for rr in ${realiz[@]}; do
                        dir="${base}/${ss}/${mm}/${rr}"
                        f=($(ls ${dir}/${vv}_*))                                  # take filename with path
			# f=($(ls ${dir}/${vv}_* | xargs -n 1 basename))          # take only filename without path

                        if [ ${mm} == CMCC-ESM2 ]; then
                        
                        cdo -L -remapdis,r362x292 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == CNRM-ESM2-1 ]; then
                        cdo -L -remapdis,r362x294 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == IPSL-CM6A-LR ]; then
                        cdo -L -remapdis,r362x332 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == MPI-ESM1-2-LR ]; then
                        cdo -L -remapdis,r256x220 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == CanESM5 ]; then
                        cdo -L -remapdis,r360x291 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == ACCESS-ESM1-5 ]; then
                        cdo -L -remapdis,r360x300 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == UKESM1-0-LL ]; then
                        cdo -L -remapdis,r360x330 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == CESM2-WACCM ]; then
                        cdo -L -remapbil,r320x384 ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == MIROC-ES2L ]; then
                        cdo -L -remapdis,r362x294 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc
                        
                        elif [ ${mm} == NorESM2-MM ]; then
                        cdo -L -remapdis,r360x385 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc
                        
                        elif [ ${mm} == E3SM-1-1-ECA ]; then
                        cdo -L -remapdis,r360x180 ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == TaiESM1 ]; then
                        cdo -L -remapdis,r320x284 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == BCC-CSM2-MR ]; then
                        cdo -L -remapdis,r360x232 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == NorESM2-LM ]; then
                        cdo -L -remapdis,r360x385 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == MRI-ESM2-0 ]; then
                        cdo -L -remapdis,r360x363 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        elif [ ${mm} == CESM2 ]; then
                        cdo -L -remapdis,r320x384 -selgrid,curvilinear ${f[@]} ${out_dir}/${vv}_${mm}_${ss}_${rr}_remap.nc

                        fi
                        
                        done #rr

                done # vv

	done # mm

done # ss

exit
