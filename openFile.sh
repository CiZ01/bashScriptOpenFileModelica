#!/bin/bash

#Semplice script per aprire automaticamente tutti i file necessari per studiare i progetti di Modelica 
#+messi a disposizione dal prof.

#CONSIGLIO di aggiungerlo alle variabili di ambiente, in modo da richiamare il comando all'interno della cartella interessata
#+senza dover passare sempre come argomento il path.

APP=geany

if [ -z "$1" ]
then
    DIR=$PWD
else
    DIR=$1
    if [ ! -d "$DIR" ] 
    then
        echo "La directory specificata non esiste!"
        exit 1
    fi
fi

if [ $(apt-cache policy geany | grep -c none) == 1 ] 
then
    APP=emacs
    echo "Ricordati di chiudere i buffers con il tasto rosso in alto a sinistra!"
    if [ $(apt-cache policy geany | grep -c none) == 1 ] 
    then
        echo "Ne Geany, ne Emacs sono installati!"
        echo "Per favore installa almeno uno, consiglio Geany."
        exit 1
    fi
fi 

cd $DIR

COUNT=$(find . -maxdepth 1 -type f -name "*.mo" -printf x | wc -c)

if [ "$COUNT" == 0 ]
then
    echo "Nella directory corrente non è presente nessun file .mo!"
    exit 1
fi

$APP . *.mo & 2> dev/null

echo "Ho aperto $COUNT files."

exit 0