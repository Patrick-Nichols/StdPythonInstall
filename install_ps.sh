#!/bin/bash
export PY_VERS1=3.11
export PY_VERS2=3.12
export VERS=25.3.1
export NAME=`uname -n`
#export MODULES_DIR=/apps/modules/modulesfiles/miniforge3
#export INSTALL_DIR=/apps/miniforge3

#if [ NAME == "gaea*" ]
#  then
#    export MODULES_DIR=/sw/apps/gaea-c5/modules/modulesfiles
#    export INSTALL_DIR=/sw/apps/gaea-c5/miniforge3
#fi

echo "number of args = "
echo $# 

export CONDA_DIR=/apps
export MODULES_DIR=/apps/modules/modulefiles
export SYSNAME=`uname -n`
export ERR_MSG="usage is bash install_ps.sh conda_install_prefix modules_install_prefix"
echo "system is "$SYSNAME

if [ $# != 0 ] 
   then
     if [ $1 == "-h" -o $1 == "help" ]
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
	      unset CONDA_DIR
	      unset MODULES_DIR
              export CONDA_DIR=/sw/gaea-c5
              export MODULES_DIR=/sw/gaea-c5/modules/modulefiles
         else
	      unset CONDA_DIR
      	      unset MODULES_DIR
              export CONDA_DIR=$PWD/apps
              export MODULES_DIR=$PWD/modules/modulefiles
              mkdir -p $PWD/apps
              mkdir -p $PWD/modules
              mkdir -p $PWD/modules/modulefiles
              mkdir -p $PWD/modules/modulefiles/conda
              mkdir -p $PWD/modules/modulefiles/python         
         fi 
   fi 
fi

echo "conda will be installed in "$CONDA_DIR"/conda"
echo "modules will be installed in "$MODULES_DIR

if [ -d $CONDA_DIR/conda ]
   then
     rm -fr $CONDA_DIR/conda
fi

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

echo "downloaded script"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR}/conda
echo "ran script"

dir_str=$CONDA_DIR/conda
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/conda/$VERS.lua > $MODULES_DIR/conda/$VERS.lua
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/python/$PY_VERS1.lua > $MODULES_DIR/python/$PY_VERS1.lua
sed -s "s|INSTALL_PREFIX|\"${dir_str}\"|g" $PWD/modulefiles/python/$PY_VERS2.lua > $MODULES_DIR/python/$PY_VERS2.lua
echo "installed modules"

source $CONDA_DIR/conda/etc/profile.d/conda.sh
conda create -y -n $PY_VERS1 python=$PY_VERS1
conda create -y -n $PY_VERS2 python=$PY_VERS2
echo "created python environments"
