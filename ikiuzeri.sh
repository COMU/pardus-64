#!/bin/bash
#Pardus Corporate 2 sürümünün 32 bit devel deposunu 64 bite çevirmek için gerekli işlemlerin yapılmasını sağlamak için yazılmış bir betiktir.
#Yakın zamanda fezaya bayrak dikmesi planlanmaktadır.

usage(){
 echo "usage "
 echo "ikiuzeri [source] [destination] [component]"

}

if [ "$#" -lt 2 ]; then { usage;  exit 1; } fi
[[ -d "$1" || -d "$2" ]] || { echo -e "Error: $source directory not exist"; exit 1; }

component=""

if [ "$3" != "all" ]; then { component=`echo "$3" | sed -e 's/\./\//' `; } fi
[ -d "$1/devel/$component"  ]  || { echo -e " $component not found component "; exit 1; }

source="$1"
destination="$2"
cp -R  $source/* $destination/ && 

# devel eklenmeli ikiuzerialti.sh 'a
echo "bilesen   $component source ${source//\//\\/}  destination ${destination//\//\\/}  "
sed -e 's/\$source/'${source//\//\\/}'/' -e 's/\$destination/'${destination//\//\\/}'/' ikiuzerialti.sh  |  grep $component |  awk -F"\n" '{  system($1); } '





