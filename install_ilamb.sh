#!/usr/bin/env bash


#ilamb_venv_dir=/lustre/or-hydra/cades-ccsi/e4x/ilamb_venv/
#ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv
ilamb_venv_dir=/lustre/atlas1/cli106/proj-shared/mxu/ilamb_venv/ilamb-venv-py36

umask 022

tag='v9.9'

if [[ $tag == 'v9.9' ]]; then
   git clone --branch master https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-$tag
else
   git clone --branch $tag https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-$tag
fi

cd ILAMB-$tag/bin
rename ilamb ilamb${tag//./} ilamb*
cd ..
if [[ $tag == 'v9.9' ]]; then
   sed -i "s/v2.4/v9.9/g" setup.py
   sed -i "s/bin\/ilamb/bin\/ilamb${tag//./}/g" setup.py

else
   sed -i "s/bin\/ilamb/bin\/ilamb${tag//./}/g" setup.py
fi
pwd
python setup.py install
mkdir -p $ilamb_venv_dir/ilamb-venv-py36/share/ilamb$tag/
/bin/cp -f -r demo $ilamb_venv_dir/ilamb-venv-py36/share/ilamb$tag/

