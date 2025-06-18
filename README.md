This repository contains the codes for the replication of the results presented in the following manuscript under review in EGU Biogeosciences Journal:
"Drivers and uncertainty of Amazon carbon sink long-term and interannual variability in CMIP6 models", by Mastropierro et al., (2025).

The repository is organized as follows.

```bash
/AMAZON_CMIP6
│   README.md
│   environment.yml
└───Code
    ├───preprocessing
    │       bash_variables_calc.sh
    │       bash_merge_infolder.sh
    │       bash_rad_calc.sh
    │
    └───analysis
            Figure 2,3,S6-S9.ipynb
            Figure 6,7,S19.ipynb
            Figure 4,5,S10-S16.ipynb
            Figure S1,S17,S18.ipynb
            Figure 1,S2-S5.ipynb
```bash

**environment.yml** is the conda environment containing the libraries used to perform the analysis.

In **preprocessing** are stored bash script used for preprocessing the original .nc data downloaded from the ESGF repository.

The folder **analysis** contains the .ipynb files, each one referring to the figures that they generate.