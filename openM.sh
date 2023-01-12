#!/bin/bash

DIR=""
Exam_number=0

while getopts ":e:s:h" option; do
   case $option in
        e)  DIR="/home/ciz/Scrivania/Modelica/Esami/";
            Exam_number=$OPTARG;;
        s)  DIR="/home/ciz/Scrivania/Modelica/Esami/";
            Exam_number=$OPTARG;;
        h)  help
            exit;;
        \?) echo "Opzione non valida!"
            exit;;
   esac
done


if [ -z "$DIR" ]
then
    echo "Devi specificare un esame!"
    exit 1
fi

if [ ! -d "$DIR" ] 
then
    echo "La directory specificata non esiste!"
    exit 1
fi

n_dirs=`find $DIR -maxdepth 1 -type d | wc -l`
dirs=()

mapfile -d $'\0' dirs < <(find $DIR -maxdepth 1 -type d -printf '%P \0')

echo "Scegli un esame tra i seguenti, specificando il numero:"
for (( i=1; i<$n_dirs; i++ ))
do
    echo $i. ${dirs[$i]}
done

read exam_date 

date=`echo -n ${dirs[exam_date]//[[:space:]]/}`

DIR=$DIR$date/

check_dir=`find $DIR -maxdepth 1 -type d -printf '%P'`

if [ -z "$check_dir" ]
then
    zip=`find $DIR -maxdepth 1 -type f -name "*.zip" -printf '%P'`
    unzip $DIR$zip -d $DIR
    check_dir=`find $DIR -maxdepth 1 -type d -printf '%P'`
fi

DIR=$DIR$check_dir/$Exam_number/

cd $DIR

/usr/bin/opMoFiles.sh -c

exit 0;