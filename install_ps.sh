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

if [ $# == 2 ]
  then
    export MODULES_DIR=$2
    export INSTALL_DIR=$1
fi  

echo $MODULES_DIR 
echo $INSTALL_DIR

if [ ! -d MODULES_DIR ] 
   then
     mkdir -p $MODULES_DIR
     mkdir -p $MODULES_DIR/conda
     mkdir -p $MODULES_DIR/python
fi
 
if [ ! -d INSTALL_DIR ] 
   then
     mkdir -p $INSTALL_DIR
fi 


wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

echo "downloaded script"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${INSTALL_DIR}/conda
echo "ran script"

dir_str=$INSTALL_DIR/conda
sed -s "s|CONDA_PREFIX|${dir_str}|g" $PWD/modulefiles/conda/$VERS.lua > $MODULES_DIR/conda/$VERS.lua
sed -s "s|CONDA_PREFIX|${dir_str}|g" $PWD/modulefiles/python/$PY_VERS1.lua > $MODULES_DIR/python/$PY_VERS1.lua
sed -s "s|CONDA_PREFIX|${dir_str}|g" $PWD/modulefiles/python/$PY_VERS2.lua > $MODULES_DIR/python/$PY_VERS2.lua
echo "installed modules"

