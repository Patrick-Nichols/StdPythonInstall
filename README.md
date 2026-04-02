# StdPythonInstall

##  author: Patrick Nichols patrick.nichols@noaa.gov
##  This script will install miniforge3, create and place modules and create 2 python version
##  environments.
##  usage is "bash install_ps.sh" absolute_path_to_conda_install absolute_path_to_modules_install"
##
##  Recommended installation directories
## system            bin_prefix                                modules_prefix
------------------------------------------------------------------------------------- 
## hera/juno      |  /apps                                  | /apps/modules
## ursa/oso       |  /apps                                  | /apps/modules            
## gaea           |  /autofs/ncrc-svm1_usw/rdhpcs/software  | /auto/ncrc-svm1_usw/rdhpcs
## ppan           |  /apps                                  | /apps/Modules                 
## orion/hercules |  /app/contrib                           | /apps/contrib 
##
## Role Accounts to use:
## system               account
## -----------------------------
## hera/juno      |   role.apps
## ursa/oso       |   role.apps
## gaea           |   role.apps
## ppan           |   oar.gfdl.sw
## orion/hercules |   role-noaatest
##
## on ppan use the an103 node
## on orion/hercules use one of the development nodes
##




