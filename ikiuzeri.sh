#!/bin/bash
#Pardus Corporate 2 sürümünün 32 bit devel deposunu 64 bite çevirmek için gerekli işlemlerin yapılmasını sağlamak için yazılmış bir betiktir.
#Yakın zamanda fezaya bayrak dikmesi planlanmaktadır.

usage(){
 echo "usage "

}

if [ "$#" -lt 2 ]; then { usage;  exit 1; } fi

source="$1"
destination="$2"

[ -d "$source" ] || { echo -e "Error: $source directory not exist"; exit 1; }
[ -d "$destination" ] || { echo -e "Error: $destination directory not exist"; exit 1; }

component= echo "$3" | sed -e 's/\./\//'

cp -R  $source/* $destination/ && 

if [ -d "$source/$component"  ]  || { echo -e " $component bilesen bulunamad "; exit 1; }

cat meltem.sh | grep $component | sed -e 's/$source/'$source'/' -e 's/$destination/'$destination'/' | awk -F"\n" '{  system($1); } '



