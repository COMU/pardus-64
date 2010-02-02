#!/bin/bash
#Pardus Corporate 2 sürümünün 32 bit devel deposunu 64 bite çevirmek için gerekli işlemlerin yapılmasını sağlamak için yazılmış bir betiktir.
#Yakın zamanda fezaya bayrak dikmesi planlanmaktadır.

usage(){
 echo "usage "
 echo "ikiuzeri [source] [destination] [component]"

}

if [ "$#" -lt 2 ]; then { usage;  exit 1; } fi
[[ -d "$1" ]] || { echo -e "Error:  directory not exist"; exit 1; }

sourcecopy="$1"
destcopy="$2"

component=""
if [ "$3" != "all" ]; then
  component=`echo "$3" | sed -e 's/\./\//g' `;
  [ -d "$1/$component"  ]  || { echo -e " $component not found component "; exit 1; }
  sourcecopy="$1/$component"
  destcopy="$2/$component"
else
  component="/";
fi


echo "hedef klasor olusturuluo--  >$component -----  $sourcecopy   -----     $destcopy"
test -z $destcopy || mkdir -p $destcopy

echo "kopyalamaya baslaniyor."
cp -R  $sourcecopy/* $destcopy/ &&  

echo "secili bilesen souurce ve destination==   $component source ${1//\//\\/}  destination ${2//\//\\/}  "
sed -e 's/\$source/'${1//\//\\/}'/' -e 's/\$destination/'${2//\//\\/}'/' ikiuzerialti.sh  |  grep $component |  awk -F"\n" '{  system($1); } '
