#!/bin/bash
sudo mount -t drvfs F: /mnt/f

cd "/mnt/f/Data/CMIP6/historical/NorESM2-LM/r1i1p1f1"
dir="/mnt/f/Data/CMIP6/historical/NorESM2-LM/r1i1p1f1"

# Input files
HUS_FILE=($(ls ${dir}/hus_*))    # Input specific humidity file (hus)
PS_FILE=($(ls ${dir}/ps_*))               # Input pressure file (ps)
TEMP_FILE=($(ls ${dir}/tas_*))        # Input temperature file (T)
OUTPUT_FILE=${dir}/hurs_Emon_NorESM2-LM_historical_r1i1p1f1_gn_185001-201412.nc # Output file for relative humidity (hurs)

# Constants
EPSILON=0.622

# 1. Merge specific humidity and pressure into a single file
cdo merge  -sellevel,92500 ${HUS_FILE} ${PS_FILE} ${dir}/hus_ps.nc

# 1. Calculate vapor pressure (e)
cdo expr,'vapor_pressure = hus * ps / (0.622 + hus * (1 - 0.622))' ${dir}/hus_ps.nc ${dir}/vapor_pressure.nc

# 2. Calculate saturation vapor pressure (es)
# es = 6.112 * exp(17.67 * (T - 273.15) / (T - 29.65))
cdo expr,'es = 6.112 * exp(17.67 * (tas - 273.15) / (tas - 29.65))' ${TEMP_FILE} ${dir}/saturation_vapor_pressure.nc

# 3. Calculate relative humidity (RH)
# RH = (vapor_pressure / es) * 100
cdo merge ${dir}/vapor_pressure.nc ${dir}/saturation_vapor_pressure.nc ${dir}/vp_es.nc
cdo expr,'hurs = (vapor_pressure / es) * 100' ${dir}/vp_es.nc ${OUTPUT_FILE}

# Clean up intermediate files
rm ${dir}/vapor_pressure.nc ${dir}/saturation_vapor_pressure.nc ${dir}/hus_ps.nc ${dir}/vp_es.nc

echo "Relative humidity calculation completed. Output saved to ${OUTPUT_FILE}"
