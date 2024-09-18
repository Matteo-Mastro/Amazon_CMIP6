#!/bin/bash
sudo mount -t drvfs F: /mnt/f

## ----- Compute on CMIP6 data ----- ##
# Preprocessing and unit conversion of the variables to be analysed

# cd "/mnt/d/Data/CMIP6" 
base="/mnt/f/Data/CMIP6"
out_dir="/mnt/f/Data/analysis"		    # HDEXT

scenario=(historical ssp585)

# 1pctCO2-bgc with 10 ESM
model=MRI-ESM2-0 #(ACCESS-ESM1-5 CanESM5 CESM2 CMCC-ESM2 CNRM-ESM2-1 IPSL-CM6A-LR MIROC-ES2L MPI-ESM1-2-LR MRI-ESM2-0 NorESM2-LM UKESM1-0-LL) 

# ssp585-bgc with 7 ESM
# model=(ACCESS-ESM1-5 CanESM5 CNRM-ESM2-1 MIROC-ES2L MRI-ESM2-0 NorESM2-LM UKESM1-0-LL)

# historical and ssp585 with 13 ESM
# model=(ACCESS-ESM1-5 BCC-CSM2-MR CanESM5 CESM2-WACCM CMCC-ESM2 CNRM-ESM2-1 E3SM-1-1-ECA IPSL-CM6A-LR MIROC-ES2L MPI-ESM1-2-LR NorESM2-MM TaiESM1 UKESM1-0-LL) 

var=nbp #(ra rh ggp pr tas mrso hfls rsds)

for ss in ${scenario[@]}; do		## Loop over all scenarios

    for mm in ${model[@]}; do  		## Loop over all models

        for vv in ${var[@]}; do 
        realiz=$(ls ${base}/${ss}/${mm})

            for rr in ${realiz[@]}; do

			dir="${base}/${ss}"
			dir="${base}/${ss}/${mm}/${rr}"

			f=($(ls ${dir}/${vv}_*_${mm}*))

			# Carbon fluxes (nep) - convert kgCm-2s-1 to gCm-2y-1 (multiply by 31536000 [s-1 to y-1] and 1000 [kgC to gC])
			# pr - convert kgm-2s-1 to mm/month
			# tas - convert °K to °C

			if [ ${vv} == nep ]; then
				if [ ! -f ${vv} ]; then				# if the model has not NEP
					## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
					echo "NEP not found for ${mm} in ${rr}, computing NEP as GPP-(ra + rh)"
					gpp=($(ls ${dir}/gpp_*_${mm}*))
					ra=($(ls ${dir}/ra_*_${mm}*))
					rh=($(ls ${dir}/rh_*_${mm}*))
					cdo -L -O -setattribute,nep@units="gC m-2 y-1" -mulc,31563000000 -sellonlatbox,0,360,-35,35 -chname,gpp,nep -sub ${gpp} -enssum ${rh} ${ra} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				else 								# if the model has NEP
					cdo -L -O -setattribute,nep@units="gC m-2 y-1" -mulc,31563000000 -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				fi

			elif [ ${vv} == gpp ]; then
				if [ ! -f ${vv} ]; then ## If GPP is not provided as model output: calculate GPP = NEP + rh	+ ra	# from "kgC m-2 s-1" to "gC m-2 y-1"
					## - # from "kgC m-2 s-1" to "gC m-2 y-1"
					echo "GPP not found for ${mm} in ${rr}, computing GPP as NEP+(ra + rh)"
					nep=($(ls ${dir}/nep_*))
					ra=($(ls ${dir}/ra_*))
					rh=($(ls ${dir}/rh_*))
					cdo -L -O -setcalendar,gregorian -setattribute,gpp@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 -chname,nep,gpp -enssum ${nep} ${rh} ${ra} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				else 
					cdo -L -O -setcalendar,gregorian -setattribute,gpp@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				fi

			elif [ ${vv} == nbp ]; then	
				## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
					cdo -L -O -setcalendar,gregorian -setattribute,nbp@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
			
			elif [ ${vv} == fLuc ]; then	
				## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
				cdo -L -O -setattribute,fLuc@units="gC m-2 y-1" -mulc,31563000000 -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
			
			elif [ ${vv} == ter ]; then	# Calculate TER = Ra + Rh
				## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
				cdo -L -f nc -L -O -setcalendar,gregorian -setattribute,ter@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 -chname,rh,ter -enssum ${dir}/rh_* ${dir}/ra_* ${out_dir}/${scenario}/ter_${mm}_${ss}_${rr}.nc

			elif [ ${vv} == rh ]; then	
				## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
				cdo -L -f nc -L -O -setcalendar,gregorian -setattribute,rh@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc

			elif [ ${vv} == ra ]; then	
				## -- 	# from "kgC m-2 s-1" to "gC m-2 y-1"
				cdo -L -f nc -L -O -setcalendar,gregorian -setattribute,ra@units="gC m-2 y-1" -sellonlatbox,0,360,-35,35 -mulc,31563000000 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc

			elif [ ${vv} == pr ]; then
				## -- 
				cdo -L -O setattribute,pr@units="mm/month" -muldpm -mulc,86400 -sellonlatbox,0,360,-90,90 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				# cdo -seasmean -select,season=ONDJF ${f} ${base}/${vv}_${mm}_${ss}_${rr}_ondjf.nc

			elif [ ${vv} == mrso ]; then
				## -- 
				cdo -L -O -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				# cdo -seasmean -select,season=ONDJF ${f} ${base}/${vv}_${mm}_${ss}_${rr}_ondjf.nc

			elif [ ${vv} == tas ]; then
				## -- 
				cdo -L -O -setattribute,tas@units="degC" -subc,273.15 -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				# cdo -select,season=ONDJF ${f} ${base}/${vv}_${mm}_${ss}_${rr}_ondjf.nc

			elif [ ${vv} == rsds ]; then
				## -- 
				cdo -L -O -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc
				# cdo -select,season=ONDJF ${f} ${base}/${vv}_${mm}_${ss}_${rr}_ondjf.nc

			elif [ ${vv} == hfls ]; then
				## -- 
				cdo -L -O -sellonlatbox,0,360,-35,35 ${f} ${out_dir}/${ss}/${vv}_${mm}_${ss}_${rr}.nc

			fi
			done #rr

		done # mm

	done # vv

done # ss

exit