#!/usr/bin/env bash


#disable local site lib
export  PYTHONNOUSERSITE=1



source ilamb-parse.sh
source ilamb-mach-settings.sh

echo $ilamb_venv_dir
if [ -f ${ilamb_venv_yml} ]; then
   eval $(parse_yaml ${ilamb_venv_yml} "CONF_")
else
   echo "Please provide the env file"
   exit -1
fi

if [ x$useconda = 'xTrue' ]; then
   condafile=`which conda`
   condapath=`dirname $condafile`
   echo $condafile $condapath
   
   if [ -f $condapath/../etc/profile.d/conda.sh ]; then
      rlt=$(grep -F 'conda.sh' ${HOME}/${bashrcfn})
   
      if [ ! -z "$rlt" ]; then
          echo "find it in $bashrcfn"
      else
          echo $rlt
          echo "Cannot find the conda.sh, add a line into $bashrcfn"
          echo ". $condapath/../etc/profile.d/conda.sh" >> ${HOME}/${bashrcfn}
          source ${HOME}/${bashrcfn}
      fi
   else
      echo "Cannot find conda.sh, the enviroment may not be activated"
   fi

   export CONDA_ENVS_PATH=${ilamb_venv_dir}
   source activate $CONF_name
fi

echo 'xxxxxxxxxxxxxxxxxxxxx'

if [ x$usepyenv = 'xTrue' ]; then
   source $ilamb_venv_dir/ilamb-venv-py27/bin/activate
fi
