#!/usr/bin/env bash


#ilamb_venv_dir=/lustre/or-hydra/cades-ccsi/e4x/ilamb_venv/
#ilamb_venv_dir=/global/project/projectdirs/acme/minxu/ilamb-venv
#ilamb_venv_dir=/lustre/atlas1/cli106/proj-shared/mxu/ilamb_venv/ilamb-venv-py36
ilamb_venv_dir=/gpfs/alpine/cli137/proj-shared/mxu/ilamb_venv/ilamb-venv-py37

umask 022

tag='v2.5'

if [[ $tag == 'v9.9' ]]; then
   #git clone --branch master https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-$tag
   git clone --branch master https://github.com/rubisco-sfa/ILAMB.git ILAMB-$tag
   
else
   #git clone --branch $tag https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-$tag
   git clone --branch $tag https://github.com/rubisco-sfa/ILAMB.git ILAMB-$tag
fi

cd ILAMB-$tag/bin
rename ilamb ilamb${tag//./} ilamb*
cd ..
if [[ $tag == 'v9.9' ]]; then
   sed -i "s/2.4/9.9/g" setup.py
   sed -i "s/bin\/ilamb/bin\/ilamb${tag//./}/g" setup.py

else
   sed -i "s/bin\/ilamb/bin\/ilamb${tag//./}/g" setup.py
fi
pwd
python setup.py install

mkdir -p $ilamb_venv_dir/share/ilamb$tag/
/bin/cp -f -r demo $ilamb_venv_dir/share/ilamb$tag/

