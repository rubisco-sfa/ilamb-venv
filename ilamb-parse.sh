
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

if [ $HOST ]; then
   host1=$HOST
fi

if [ $HOSTNAME ]; then
   host2=$HOSTNAME
fi

host3=`uname -n`

if [ -z "$host2" ]; then
   host=$host1
else
   host=$host2
fi

if [ -z "$host" ]; then
   host=$host3
fi

groups=`groups`
if [ -z $1 ]; then
   group=acme
else
   group=$1
fi

if [ -z $2 ]; then
   pythonver=2
   pythondir=python2.7
else
   pythonver=$2
   pythondir=python3.7
fi

if [ "$pythonver" == "2" ]; then
   ilamb_venv_yml=ilamb-venv.yml
else
   ilamb_venv_yml=ilamb-venv-py3.yml
fi

if [ -z $3 ]; then
   echo "Find machine $host"
else
   host=$3
fi


