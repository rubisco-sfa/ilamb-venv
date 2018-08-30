#!/usr/bin/env bash


if [ -z ${ilamb_venv_dir+x} ]; then
  ilamb_venv_src=`pwd`
  source $ilamb_venv_src/activate_ilamb_venv.sh
else
  echo "ilamb_venv_dir set, we guess that you are venv now"
fi


mkdir postinstall

cd postinstall


# install ilamb
tag='v2.3'
git clone --branch $tag https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-$tag
cd ILAMB-$tag/bin
rename ilamb ilamb${tag//./} ilamb*
cd ..
sed -i "s/bin\/ilamb/bin\/ilamb${tag//./}/g" setup.py
python setup install
/bin/cp -f -r demo $ilamb_venv_dir/ilamb-venv-py27/share/ilamb$tag/


# master header
git clone https://minxu@bitbucket.org/ncollier/ilamb.git ILAMB-header
cd ILAMB-header/bin
rename ilamb ilambv00 ilamb*
cd ..
sed -i "s/bin\/ilamb/bin\/ilambv00/g" setup.py
#change the version no
sed -i 's/2.3/0.0/' setup.py
python setup.py install
/bin/cp -f -r demo $ilamb_venv_dir/ilamb-venv-py27/share/ilambv0.0/


# install conv_remap
cd ..; git clone https://github.com/minxu74/conv_remap2
/bin/cp -f ./conv_remap2/conv_remap2.sh $ilamb_venv_dir/ilamb-venv-py27/bin/


# cf
cd ..; git clone https://bitbucket.org/minxu/alm2ilamb_wkflow.git
/bin/cp -f ./alm2ilamb_wkflow/clm_singlevar_ts.csh $ilamb_venv_dir/ilamb-venv-py27/bin/
/bin/cp -f ./alm2ilamb_wkflow/clm_to_mip $ilamb_venv_dir/ilamb-venv-py27/bin/

# esmf

ESMFPATH=`module show ncl |&grep " PATH"|cut --delimiter='H' -f2`
/bin/cp -f $ESMFPATH/ESMF_RegridWeightGen  $ilamb_venv_dir/ilamb-venv-py27/bin/

