#!/bin/sh

# Belirenen surumdeki cd içeriğinin build farm için hazırlanmasini saglayan ufak tefek bir scripttir.
#
# Kendisi get_dep.py ile çalışmaktadadır. bu yüzden tek başına pek az işe yarayacaktır.(bağımlılıklarını bulamama gibi kritik işleri get_dep.py halletmektededir.)
#

#usage(){
# echo "usage: list-packages.sh sourceDir OutPutFile"
#
#}

#if [ "$#" -lt 2 ]; then { usage;  exit 1; } fi

#source="$1"
#workquery="$2"

#[ -d "$source" ] || { echo -e "Error: $source directory not exist"; exit 1; }


svn_corporate2=http://svn.pardus.org.tr/uludag/trunk/distribution/Corporate2
svn_2009=http://svn.pardus.org.tr/uludag/trunk/distribution/2009
svn_2009.1=http://svn.pardus.org.tr/uludag/trunk/distribution/2009.1/project-files

echo "1. Corporate2 - devel "
echo "2. 2009 - stable"
echo "3. 2009 - devel"
echo -n "Please choose a dist of pardus [1,2 or 3]? "
read choice
if [ $choice == 1 ] ; then
    echo "chosed Corporate2 - devel"
    source=/corporate2/devel-x86_64
    svn co $svn_corporate2
    cat Corporate2/project-files/corporate2.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
    cat Corporate2/project-files/corporate2.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
    sed 's/\./\//g' liste2.txt > liste3.txt
elif [ $choice == 2 ] ; then
    echo "chosed 2009 - stable"
    source=/2009/stable-x86_64
    svn co $svn_2009
    cat 2009/project-files/installation.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
    cat 2009/project-files/installation.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
    sed 's/\./\//g' liste2.txt > liste3.txt
elif [ $choice == 3 ] ; then
    echo "chosed 2009 - devel"
    source=/2009/devel-x86_64
    svn co $svn_2009
    cat 2009/project-files/installation.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
    cat 2009/project-files/installation.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
    sed 's/\./\//g' liste2.txt > liste3.txt
fi
echo "where i put output file:"
read workquery

echo "#" > $workquery
echo "" > olmayanlar.txt
echo "" > liste.txt


#cat project-files/corporate2.xml | grep SelectedPackage | cut  -d\> -f2 | cut -d\< -f1 > liste.txt
#cat project-files/corporate2.xml | grep SelectedComponent | cut  -d\> -f2 | cut -d\< -f1 > liste2.txt
#sed 's/\./\//g' liste2.txt > liste3.txt
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
