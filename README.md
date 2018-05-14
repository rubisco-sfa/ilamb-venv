# ILAMB virtual environment

The major purpose of the toolkit is to set up and activate a Python environment for running [ILAMB](https://www.ilamb.org/).  The virtual environment is implemented by either Conda or Python itself depending on their availability in HPCs and it includes:

- All Python packages are needed by ILAMB and independent from the packages loaded by system
- ILAMB [V2](https://bitbucket.org/ncollier/ilamb)

### Usage

In OLCF (Titan/Rhea) and NERSC (Cori and Edison), the environments have been deployed and can be activated by
the following command directly. *Please use bash shell and unload any Python packages before running the commands.*
 
- Activate the environment
```
>source activate_ilamb_venv.sh
```
-  Deactivate the environment
```
>source deactivate
```

If you want to set up a new environment in your directory,  please try the following command
- Create a new environment
```
>./make_ilamb_venv.sh
```
