
echo $host 'host'
echo $group 'group'

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
   if [ "$python" == "2" ]; then
       module load python/2.7-anaconda-4.4
   else
       module load python/3.6-anaconda-5.2
   fi

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

