#!/bin/sh

# Belirenen surumdeki cd içeriğinin build farm için hazırlanmasini saglayan ufak tefek bir scripttir.
#
# Kendisi get_dep.py ile çalışmaktadadır. bu yüzden tek başına pek az işe yarayacaktır.(bağımlılıklarını bulamama gibi kritik işleri get_dep.py halletmektededir.)
#

usage(){
 echo "usage: list-packages.sh sourceDir OutPutFile"

}

if [ "$#" -lt 2 ]; then { usage;  exit 1; } fi

source="$1"
workquery="$2"

[ -d "$source" ] || { echo -e "Error: $source directory not exist"; exit 1; }

echo "/corporate2/devel-x86_64 için cd icerigi hazirlaniyor."
echo "#" > $workquery
echo "" > olmayanlar.txt
echo "" > liste.txt


svn co http://svn.pardus.org.tr/uludag/trunk/distribution/Corporate2/project-files
cat project-files/corporate2.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
cat project-files/corporate2.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
sed 's/\./\//g' liste2.txt > liste3.txt
exec<"liste.txt"
while read line
do
    a=$( find $source/ -name pspec.xml | grep /$line/pspec.xml)
    echo $a
    if [ "$a" == "" ]; then
        echo $line >> olmayanlar.txt
    else
        echo $a >> $workquery
    fi
done
exec<"liste3.txt"
while read line
do
    find $source/$line -name pspec.xml >> $workquery
done
find $source/system/devel -name pspec.xml >> $workquery
python get_dep.py -f $workquery
exec<"dep.txt"
while read line
do
    a=$( find $source/ -name pspec.xml | grep /$line/pspec.xml)
    echo $a
    if [ "$a" == "" ]; then
        echo $line >> olmayanlar.txt
    else
        echo $a >> $workquery
    fi
done
rm  liste.txt dep.txt liste3.txt liste2.txt
echo "bitti"
