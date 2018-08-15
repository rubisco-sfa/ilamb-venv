#!/usr/bin/env bash

# from theh stack overflow to parse yaml
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}


ilamb_venv_yml=ilamb-venv.yml

if [ $HOSTNAME ]; then
   host=$HOSTNAME
fi

if [ $HOST ]; then
   host=$HOST
fi


echo $host

groups=`groups`

case $host in
titan*)
   useconda=True
   module load python_anaconda/2.7.14-anaconda2-5.1.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   ;;
rhea*)
   useconda=True
   module load python_anaconda2/5.1.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   ;;
cori*)
   useconda=True
   module load python/2.7-anaconda-4.4
   case $groups in
   *acme*)
      ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv ;;
   *m2467*)
      ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv ;;
   *m1006*)
      ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv ;;
   *)
      echo "your group do not have ilamb venv" ;;
   esac
   fxmpi4py=True
   conda_mpi4py=${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/conda_mpi4py
   cray1_mpi4py=/global/common/edison/software/python/2.7-anaconda-4.4/lib/python2.7/site-packages/mpi4py-2.0.0-py2.7.egg-info
   cray2_mpi4py=/global/common/edison/software/python/2.7-anaconda-4.4/lib/python2.7/site-packages/mpi4py
   ;;

edison*)
   useconda=True
   module load python/2.7-anaconda-4.4
   case $groups in
   *acme*)
      ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv ;;
   *m2467*)
      ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv ;;
   *m1006*)
      ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv ;;
   *)
      echo "your group do not have ilamb venv";;
   esac
   fxmpi4py=True
   conda_mpi4py=${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/conda_mpi4py
   cray1_mpi4py=/global/common/edison/software/python/2.7-anaconda-4.4/lib/python2.7/site-packages/mpi4py-2.0.0-py2.7.egg-info
   cray2_mpi4py=/global/common/edison/software/python/2.7-anaconda-4.4/lib/python2.7/site-packages/mpi4py
   ;;
or-condo*)
   useconda=True
   module load anaconda2/4.4.0
   ilamb_venv_dir=/lustre/or-hydra/cades-ccsi/e4x/ilamb_venv/
   ;;
*)
   usepyenv=True
   echo "Please set up ilamb_venv_dir and ilamb_venv_yml first"
   ;;
esac



if [ -d ${ilamb_venv_dir} ]; then
   echo "Instaling ILAMB venv into the directory: ${ilamb_venv_dir}"
else
   echo "Make the ILAMB venv directory in: ${ilamb_venv_dir}"
   mkdir -p ${ilamb_venv_dir}
fi


if [ -f ${ilamb_venv_yml} ]; then
   eval $(parse_yaml ${ilamb_venv_yml} "CONF_")   
else
   echo "Please provide the env file"
   exit -1
fi


if [ x$useconda = 'xTrue' ]; then
   export CONDA_ENVS_PATH=${ilamb_venv_dir}
   export CONDA_PKGS_DIRS=${ilamb_venv_dir}/.pkgs
   conda env create -f ilamb-venv.yml

   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d
   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d

   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d/env_var.sh
   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d/env_var.sh


   echo "export ILAMB_VENV_DIR=${ilamb_venv_dir}" >> ${ilamb_venv_dir}/$CONF_name/etc/conda/activate.d/env_var.sh
   echo "unset ILAMB_VENV_DIR" >> ${ilamb_venv_dir}/$CONF_name/etc/conda/deactivate.d/env_var.sh

   # fix mpi4py error
   if [ x$fxmpi4py = 'xTrue' ]; then
      mkdir -p ${conda_mpi4py}
      /bin/mv ${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/site-packages/mpi4py-* ${conda_mpi4py}
      /bin/mv ${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/site-packages/mpi4py   ${conda_mpi4py}
      ln -sf ${cray1_mpi4py} ${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/site-packages/
      ln -sf ${cray2_mpi4py} ${ilamb_venv_dir}/ilamb-venv-py27/lib/python2.7/site-packages/
      cp -f ilamb-run-ser-sample ${ilamb_venv_dir}/ilamb-venv-py27/bin
   fi

   # install ilamb
else
   pip install virtualenv --user
   $PYTHONUSERBASE/bin/virtualenv $ilamb_venv_dir/ilamb-venv-py27

fi

#source activate
