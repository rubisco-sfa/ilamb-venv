#!/usr/bin/env bash

module load python

#disable local site lib
export  PYTHONNOUSERSITE=1


case $HOST in
titan*)
   usepyenv=True
   ;;
rhea*)
   usepyenv=True
   ;;
cori*)
   useconda=True
  #ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
   ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
   ;;
edison*)
   useconda=True
   ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
  #ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
   ;;
*)
   usepyenv=True
   echo "Please set up ilamb_venv_dir and ilamb_venv_yml first"
   ;;
esac


if [ x$useconda = 'xTrue' ]; then
   export CONDA_ENVS_PATH=${ilamb_venv_dir}
   conda activate ilamb-venv-py27
fi


if [ x$usepyenv = 'xTrue' ]; then
   source $ilamb_venv_dir/ilamb-venv-py27/bin/activate

