#!/bin/bash
sudo mount -t drvfs F: /mnt/f

## ----- Compute on CMIP6 data ----- ##

# cd "/mnt/d/Data/CMIP6" 					# HDEXT
base="/mnt/f/Data/CMIP6"
out_dir="/mnt/f/Data/analysis"		    # HD
mkdir "/mnt/f/Data/analysis/ssp585-rad"

model=(ACCESS-ESM1-5 CanESM5 CNRM-ESM2-1 MIROC-ES2L MRI-ESM2-0 NorESM2-LM UKESM1-0-LL) #(ACCESS-ESM1-5 CESM2-WACCM CMCC-ESM2 MPI-ESM1-2-LR IPSL-CM6A-LR TaiESM1 BCC-CSM2-MR NorESM2-MM CanESM5 CNRM-ESM2-1 MIROC-ES2L UKESM1-0-LL) # (ACCESS-ESM1-5 E3SM-1-1-ECA NorESM2-LM CanESM5 CNRM-ESM2-1 MIROC-ES2L UKESM1-0-LL MRI-ESM2-0) 
var=nep #(gpp nep ra rh pr tas mrso hfls rsds)

for mm in ${model[@]}; do  		## Loop over all models

        for vv in ${var[@]}; do 
        realiz=$(ls ${base}/ssp585-bgc/${mm})

            for rr in ${realiz[@]}; do
            dir="${out_dir}/ssp585"
			
            if [ ${vv} == tos ]; then

                f_cou=($(ls ${out_dir}/${vv}_${mm}_ssp585_*_remap.nc))
                f_bgc=($(ls ${out_dir}/${vv}_${mm}_ssp585-bgc_${rr}_remap.nc))

                cdo -sub ${f_cou} ${f_bgc} ${out_dir}/ssp585-rad/${vv}_${mm}_ssp585-rad_${rr}_remap.nc
            else
                f_cou=($(ls ${out_dir}/${vv}_${mm}_ssp585_*.nc))
                f_bgc=($(ls ${out_dir}/${vv}_${mm}_ssp585-bgc_${rr}.nc))

                cdo -sub ${f_cou} ${f_bgc} ${out_dir}/ssp585-rad/${vv}_${mm}_ssp585-rad_${rr}.nc
            fi
            
			done #rr

		done # vv

done # mm

exit