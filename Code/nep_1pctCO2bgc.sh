#!/bin/bash
sudo mount -t drvfs F: /mnt/f

## ----- Compute on CMIP6 data ----- ##

# cd "/mnt/d/Data/CMIP6" 					# HDEXT
base="/mnt/f/Data/CMIP6"
out_dir="/mnt/f/Data/analysis"		    # HDEXT

scenario=(1pctCO2-bgc)
model=NorESM2-LM # (ACCESS-ESM1-5 BCC-CSM2-MR CanESM5 CMCC-ESM2 CNRM-ESM2-1 IPSL-CM6A-LR MIROC-ES2L MPI-ESM1-2-LR UKESM1-0-LL) #(ACCESS-ESM1-5 CESM2-WACCM CMCC-ESM2 MPI-ESM1-2-LR IPSL-CM6A-LR TaiESM1 BCC-CSM2-MR NorESM2-MM CanESM5 CNRM-ESM2-1 MIROC-ES2L UKESM1-0-LL) # (ACCESS-ESM1-5 E3SM-1-1-ECA NorESM2-LM CanESM5 CNRM-ESM2-1 MIROC-ES2L UKESM1-0-LL MRI-ESM2-0) 
var=(nep) #(tas mrso nbp pr tna tsa pmm)

for ss in ${scenario[@]}; do		## Loop over all scenarios

    for mm in ${model[@]}; do  		## Loop over all models

        for vv in ${var[@]}; do 
        #realiz=$(ls ${base}/${ss}/${mm})

            #for rr in ${realiz[@]}; do
            # dir="${base}/${ss}/${mm}/${rr}"
            dir="${out_dir}/${ss}"
			
			f=($(ls ${dir}/${vv}_${mm}_${ss}.nc))

			cdo -L -setcalendar,gregorian -remapbil,r360x180 -sellonlatbox,0,360,-90,90 ${f[@]} ${dir}/${vv}_${mm}_${ss}_1x1.nc

			#done #rr

		done # mm

	done # vv

done # ss

exit