#!/usr/bin/env bash


#disable local site lib
export  PYTHONNOUSERSITE=1


if [ $HOST ]; then
   host1=$HOST
fi

if [ $HOSTNAME ]; then
   host2=$HOSTNAME
fi

if [ -z "$host2" ]; then
   host=$host1
else
   host=$host2
fi

echo $host

groups=`groups`

if [ -z $1 ]; then
   group=$groups
else
   group=$1
fi

case $host in
titan*)
   useconda=True
   module load python_anaconda/2.7.14-anaconda2-5.1.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   bashrcfn=.bashrc
   ;;
rhea*)
   useconda=True
   module load python_anaconda2/5.1.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   bashrcfn=.bashrc
   ;;
cori*)
   useconda=True
   bashrcfn=.bashrc.ext
   module load python/2.7-anaconda-4.4

   case $group in
   *acme*)
      ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv ;;
   *m2467*)
      ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv ;;
   *m1006*)
      ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv ;;
   *)
      echo "your group do not have ilamb venv" ;;
   esac
   ;;
edison*)
   useconda=True
   bashrcfn=.bashrc.ext
   module load python/2.7-anaconda-4.4

   case $group in
   *acme*)
      ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv ;;
   *m2467*)
      ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv ;;
   *m1006*)
      ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv ;;
   *)
      echo "your group do not have ilamb venv" ;;
   esac
   ;;
or-condo*)
   useconda=True
   module load anaconda2/4.4.0
   ilamb_venv_dir=/lustre/or-hydra/cades-ccsi/e4x/ilamb_venv/
   ;;
*)
   usepyenv=True
   bashrcfn=.bashrc
   echo "Please set up ilamb_venv_dir and ilamb_venv_yml first"
   ;;
esac


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
   source activate ilamb-venv-py27
fi

echo 'xxxxxxxxxxxxxxxxxxxxx'

if [ x$usepyenv = 'xTrue' ]; then
   source $ilamb_venv_dir/ilamb-venv-py27/bin/activate
fi
