# StdPythonInstall

##  author: Patrick Nichols patrick.nichols@noaa.gov
##  This script will install miniforge3, create and place modules and create 2 python version
##  environments.
##  usage is "bash install_ps.sh" absolute_path_to_conda_install absolute_path_to_modules_install"
##  or
##  "base install_ps.sh" will install in the /apps directory
##  This script requires wget.
##
##  Recommended installation directories
##  Hera, Oso, Ursa   /apps /apps/modules
##  Geae  /sw/gaea-c5 /sw/gaea-c5/modulefiles/
## 
##  Role accounts should bne used for installs 
##    role.apps
##    role-apps
