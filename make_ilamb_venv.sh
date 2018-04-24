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

case $HOST in
titan*)
   useconda=True
   module load python_anaconda/4.2.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   ;;
rhea*)
   useconda=True
   module load python_anaconda/4.2.0
   ilamb_venv_dir=/lustre/atlas1/cli106/world-shared/mxu/ilamb_venv
   ;;
cori*)
   useconda=True
   module load python/2.7-anaconda-4.4
  #ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
   ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
   ;;
edison*)
   useconda=True
   module load python/2.7-anaconda-4.4
  #ilamb_venv_dir=/global/project/projectdirs/m2467/prj_minxu/ilamb-venv/
   ilamb_venv_dir=/global/project/projectdirs/m1006/minxu/ilamb-venv/
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
   conda env create -f ilamb-venv.yml

   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d
   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d

   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d/env_var.sh
   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d/env_var.sh


   echo "export ILAMB_VENV_DIR=${ilamb_venv_dir}" >> ${ilamb_venv_dir}/$CONF_name/etc/conda/activate.d/env_var.sh
   echo "unset ILAMB_VENV_DIR" >> ${ilamb_venv_dir}/$CONF_name/etc/conda/deactivate.d/env_var.sh
else
   pip install virtualenv --user
   $PYTHONUSERBASE/bin/virtualenv $ilamb_venv_dir/ilamb-venv-py27

fi

#source activate
