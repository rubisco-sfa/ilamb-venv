#!/usr/bin/env bash


#disable local site lib
export  PYTHONNOUSERSITE=1


case $HOST in
titan*)
   usepyenv=True
   module load python_anaconda/2.7.14-anaconda2-5.1.0
   bashrcfn=.bashrc
   ;;
rhea*)
   usepyenv=True
   module load python_anaconda/2.7.14-anaconda2-5.1.0
   bashrcfn=.bashrc
   ;;
cori*)
   useconda=True
   bashrcfn=.bashrc.ext
   module load python/2.7-anaconda-4.4
  #ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
   ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
   ;;
edison*)
   useconda=True
   bashrcfn=.bashrc.ext
   module load python/2.7-anaconda-4.4
   ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
  #ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
   ;;
*)
   usepyenv=True
   bashrcfn=.bashrc
   echo "Please set up ilamb_venv_dir and ilamb_venv_yml first"
   ;;
esac


condafile=`which conda`
condapath=`dirname $condafile`

echo $condafile $condapath

ls $condapath/../etc/profile.d/conda.sh

echo ". $condapath/../etc/profile.d/conda.sh"

rlt=$(grep -F 'conda.sh' ${HOME}/${bashrcfn})

source ${HOME}/${bashrcfn}


if [ ! -z "$rlt" ]; then
    echo "find it in $bashrcfn"
else
    echo $rlt
    echo "Cannot find the conda.sh, add a line into $bashrcfn"
    echo ". $condapath/../etc/profile.d/conda.sh" >> ${HOME}/${bashrcfn}
fi


if [ x$useconda = 'xTrue' ]; then
   export CONDA_ENVS_PATH=${ilamb_venv_dir}
   conda activate ilamb-venv-py27
fi


if [ x$usepyenv = 'xTrue' ]; then
   source $ilamb_venv_dir/ilamb-venv-py27/bin/activate
fi
