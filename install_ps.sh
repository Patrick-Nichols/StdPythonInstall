#!/bin/bash --norc
######################
##  author: Patrick Nichols patrick.nichols@noaa.gov
##  This script will install miniforge3, create and place modules and create 2 python version
##  environments.
##  usage is "bash install_ps.sh" absolute_path_to_conda_install absolute_path_to_modules_install"
##  or
##  "base install_ps.sh" will install in the usual /apps directory
##  >> This script requires wget. <<
##
##  Recommended installation directories
##  Hera, Oso, Ursa   /apps /apps/modules
##  Geae  /sw/gaea-c5 /sw/gaea-c5/modulefiles/
## 
##  Role accounts should bne used for installs 
##    role.apps
##    role-apps
######################
set -xe
#### these two variables denote the python version to be installed
export PY_VERS1=3.11
export PY_VERS2=3.12
#### this is the version of miniforge
export VERS=25.3.1
export NAME=`uname -n`

echo "number of args = "
echo $# 

if hash wget 2>/dev/null; then
	echo "wget found"
else
	echo "wget is not found exiting"
	exit 1
fi

export SYSNAME=`uname -n`
export ERR_MSG="usage is bash install_ps.sh absolute_conda_install_prefix absolute_modules_install_prefix"
echo "system is "$SYSNAME

if [ $# != 0 ] 
   then
     if [ $1 == "-h" -o $1 == "help" -o $1 == "--help" ]
        then
          echo $ERR_MSG
          exit 1
     fi
     if [ $# != 2 ]
        then
           echo "wrong number of arguments"
           echo $ERR_MSG
           exit 2
     fi  
fi

export CONDA_DIR=/apps
export MODULES_DIR=/apps/modules

if [ $# == 2 ]
   then
      unset CONDA_DIR
      unset MODULES_DIR
      export CONDA_DIR=$1
      export MODULES_DIR=$2
else
# try to find out what system this is and set variables
   if [ ! -d /apps  ]
      then
         if [ SYSNAME == "gaea" ]
            then
# this will be filled in if and when we get the go ahead to install on gaea
	      unset CONDA_DIR
	      unset MODULES_DIR
              export CONDA_DIR=/sw/gaea-c5
              export MODULES_DIR=/sw/gaea-c5/modules
         else
	      unset CONDA_DIR
      	      unset MODULES_DIR
         fi 
   fi 
fi


if [[ "$CONDA_DIR" == /* ]]; then
	echo "conda will be installed in "$CONDA_DIR"/conda"
else
	echo "conda directory needs to be an absolute path!\n"
	echo $ERR_MSG
	exit 1
fi

if [[ "$MODULES_DIR" == /* ]]; then
	echo "modules will be installed in "$MODULES_DIR"/modulefiles"
else
	echo "modules directory needs to be an absolute path!\n"
	echo $ERR_MSG
	exit 1
fi
 
mkdir -p $CONDA_DIR
mkdir -p $MODULES_DIR
mkdir -p $MODULES_DIR/modulefiles
mkdir -p $MODULES_DIR/modulefiles/conda
mkdir -p $MODULES_DIR/modulefiles/python
echo "created ${CONDA_DIR}"
echo "created ${MODULES_DIR}"
echo "created "$MODULES_DIR/modulefiles
echo "created "$MODULES_DIR/modulefiles/conda
echo "created "$MODULES_DIR/modulefiles/python


if [ -d $CONDA_DIR/conda ]
   then
     rm -fr $CONDA_DIR/conda
fi

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

echo "downloaded script"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR}/conda
echo "ran script"

dir_str=$CONDA_DIR/conda
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/conda/$VERS.lua.temp > $MODULES_DIR/modulefiles/conda/$VERS.lua
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/python/$PY_VERS1.lua.temp > $MODULES_DIR/modulefiles/python/$PY_VERS1.lua
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/python/$PY_VERS2.lua.temp > $MODULES_DIR/modulefiles/python/$PY_VERS2.lua
echo "installed modules"


echo "confirming installation and creating environments"
############################################
## if conda has been installed in the correct place
## we create the environments for our python versions
##
############################################
if [ -e $CONDA_DIR/conda/etc/profile.d/conda.sh ]
    then
        source $CONDA_DIR/conda/etc/profile.d/conda.sh
        conda create -y -n $PY_VERS1 python=$PY_VERS1
        conda create -y -n $PY_VERS2 python=$PY_VERS2
        echo "created python environments"
else
    echo "installation failed no conda directory"
    if [ -d $CONDA_DIR/conda ]
       then
         rm -fr $CONDA_DIR/conda  
    fi
    exit 1
fi

####
## check to see if modules loaded everything right
####
source $MODULESHOME/init/bash
module use $MODULES_DIR/modulefiles
module load conda
exp_ans="$CONDA_DIR/conda/bin/conda"
ans=$(which conda)
if [ "$ans" == "$exp_ans" ]
    then
        echo "conda is installed correctly"
else
    echo "conda not found"
    exit 1
fi

module load python/$PY_VERS1
unset exp_ans
unset ans
exp_ans="$CONDA_DIR/conda/envs/$PY_VERS1/bin/python3"
ans=$(which python3)
if [ "$ans" = "$exp_ans" ]
    then
        echo "python is installed correctly"
else
    echo "python not found"
    exit 1
fi

module unload python
module load python/$PY_VERS2
unset exp_ans
unset ans
exp_ans="$CONDA_DIR/conda/envs/$PY_VERS2/bin/python3"
ans=$(which python3)
if [ "$ans" == "$exp_ans" ]
    then
        echo "python is installed correctly"
else
    echo "python not found"
    exit 1
fi
echo "all done"
exit 0