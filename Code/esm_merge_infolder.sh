#!/bin/bash
sudo mount -t drvfs F: /mnt/f

cd "/mnt/f/Data/CMIP6"
base="/mnt/f/Data/CMIP6"

scenario=(historical)

# Baseline with 13 ESM
model=(ACCESS-ESM1-5 BCC-CSM2-MR CanESM5 CESM2-WACCM CMCC-ESM2 CNRM-ESM2-1 E3SM-1-1-ECA IPSL-CM6A-LR MIROC-ES2L MPI-ESM1-2-LR NorESM2-MM TaiESM1 UKESM1-0-LL) 

# Remember to write variables with derivation (e.g. nep_Lmon)
vars=(nbp_Lmon) 

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

				elif [ ${ss} = ssp585-bgc ]; then

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


