#!/usr/bin/env bash


echo "$0 group_name host_name python_version"


source ilamb-parse.sh
source ilamb-mach-settings.sh

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
   conda env create -f $ilamb_venv_yml

   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d
   mkdir -p ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d

   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/activate.d/env_var.sh
   touch ${ilamb_venv_dir}/${CONF_name}/etc/conda/deactivate.d/env_var.sh


   cat <<EOF > ${ilamb_venv_dir}/$CONF_name/etc/conda/activate.d/env_var.sh

#!/usr/bin/env bash

if [[ ! -n $ILAMB_VENV_DIR ]]; then
   export ILAMB_VENV_DIR=${ilamb_venv_dir}
fi
export PYTHONNOUSERSITE=1

if [[ ! -n $ILAMB_VENV_HOST ]]; then
    export ILAMB_VENV_HOST=$host
fi

if [[ ! -n $ILAMB_VENV_GROUP ]]; then
    export ILAMB_VENV_HOST=$group
fi

if [[ $host == *"edison"* || $host == *"cori"*  ]]; then
    export HDF5_USE_FILE_LOCKING=FALSE
fi

EOF

   cat <<EOF > ${ilamb_venv_dir}/$CONF_name/etc/conda/deactivate.d/env_var.sh
#!/usr/bin/env bash

if [[ -n $ILAMB_VENV_DIR ]]; then
   unset ILAMB_VENV_DIR
fi
unset PYTHONNOUSERSITE

if [[ -n $ILAMB_VENV_HOST ]]; then
  unset ILAMB_VENV_HOST
fi

if [[ -n $ILAMB_VENV_GROUP ]]; then
  unset ILAMB_VENV_GROUP
fi

if [[ $host == *"edison"* || $host == *"cori"*  ]]; then
    unset HDF5_USE_FILE_LOCKING=FALSE
fi
EOF

   # fix mpi4py error
   #-if [ x$fxmpi4py = 'xTrue' ]; then
   #-   mkdir -p ${conda_mpi4py}
   #-   /bin/mv ${ilamb_venv_dir}/${CONF_name}/lib/${pythondir}/site-packages/mpi4py-* ${conda_mpi4py}
   #-   /bin/mv ${ilamb_venv_dir}/${CONF_name}/lib/${pythondir}/site-packages/mpi4py   ${conda_mpi4py}
   #-   ln -sf ${cray1_mpi4py} ${ilamb_venv_dir}/${CONF_name}/lib/${pythondir}/site-packages/
   #-   ln -sf ${cray2_mpi4py} ${ilamb_venv_dir}/${CONF_name}/lib/${pythondir}/site-packages/
   #-   cp -f ilamb-run-ser-sample ${ilamb_venv_dir}/ilamb-venv-py27/bin
   #-fi

   # install ilamb
else
   pip install virtualenv --user
   $PYTHONUSERBASE/bin/virtualenv $ilamb_venv_dir/ilamb-venv-py27

fi

#source activate
