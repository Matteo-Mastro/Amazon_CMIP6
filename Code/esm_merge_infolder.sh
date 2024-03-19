#!/bin/bash

cd "/mnt/d/Data/CMIP6"
base="/mnt/d/Data/CMIP6"

scenario=(historical ssp585)
model=(E3SM-1-1-ECA NorESM2-MM TaiESM1 BCC-CSM2-MR CanESM5 CMCC-ESM2 CNRM-ESM2-1 ACCESS-ESM1-5 IPSL-CM6A-LR MIROC-ES2L UKESM1-0-LL MPI-ESM1-2-LR CESM2-WACCM) 

vars=(hfls rsds hurs lai) 

for mm in ${model[@]}; do  		## Loop over all models
		
		for ss in ${scenario[@]}; do		## Loop over all scenarios
		realiz=$(ls ${base}/${ss}/${mm})		## Take the realizations' folders inside each model

			for rr in ${realiz[@]}; do			## Loop over all the realizations (overcome different forcings prob)
				in_dir="${base}/${ss}/${mm}/${rr}"

				for vv in ${vars[@]}; do
				f=$(ls ${in_dir}/${vv}_*)
				
				if [ ${ss} = historical ]; then

					# if exist multiple files in time domain (with the same name)
					if [ `ls -1 $f | wc -l ` -gt 1 ]; then			
					echo "${mm} has multiple files in ${ss}/${rr}, merging ${vv}..."				
					cdo mergetime ${f[@]} ${in_dir}/${vv}_${mm}_${ss}_${rr}_gn_185001-201412.nc
            		else								# is files are already merged in time
					echo "${mm} already merged in ${ss}/${rr}, skipping..."
					fi

				elif [ ${ss} = ssp585 ]; then

					# if exist multiple files in time domain (with the same name)
					if [ `ls -1 $f | wc -l ` -gt 1 ]; then			
					echo "${mm} has multiple files in ${ss}/${rr}, merging ${vv}..."	
					cdo mergetime ${f[@]} ${in_dir}/${vv}_${mm}_${ss}_${rr}_gn_201501-210012.nc
					else								# is files are already merged in time
					echo "${mm} already merged in ${ss}/${rr}, skipping..."
					fi
				fi 

				done # vv

			done # rr

		done # ss

done # ss

exit


