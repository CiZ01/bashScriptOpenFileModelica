#!/bin/bash

#Semplice script per aprire automaticamente tutti i file necessari per studiare i progetti di Modelica 
#+messi a disposizione dal prof.

#CONSIGLIO di aggiungerlo alle variabili di ambiente, in modo da richiamare il comando all'interno della cartella interessata
#+senza dover passare sempre come argomento il path.

help(){
    printf "Questo script apre in un editor di testo tutti i file .mo presenti nella directory specificata.\n"
    printf "L'editor di testo predefinito è geany. In caso non sia installato geany userà emacs.\n"

    printf "\n\nOPTIONS\n\n" 

    printf " -c: questa opzione permette di aprire tutti i file in vscode nel caso sia installato. Funziona anche su vscode WSL su Windows.\n Questa opzione potrebbe rallentare l'avvio rispetto editor più semplici\n"
}

APP=geany

while getopts ":ch" option; do
   case $option in
        c)  APP=code;;
        h)  help
            exit;;
        \?) echo "Opzione non valida!"
            exit;;
   esac
done

if [ -z "$1" ] || [ "$1" == -c ]
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

if [ $(apt-cache policy geany | grep -c none) == 1 ] && [ ! "$APP" == code ]
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

COUNT=$(find . -maxdepth 1 -type f \( -iname \*.mo -o -iname \*.mos \) -printf x | wc -c)

if [ "$COUNT" == 0 ]
then
    echo "Nella directory corrente non è presente nessun file .mo!"
    exit 1
fi

#Su WSL dal momento che non è installato GTK vengono printate dei warning, redirizzo
#+ questi warning a null per non intasare il terminale. E apro il programma in bg.
$APP . *.mo *.mos 2> /dev/null &

echo "Ho aperto $COUNT files."

exit 0
