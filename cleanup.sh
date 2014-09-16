#! /bin/bash
FUZZ=.1
find . -type f -iname "*.png" -not -path "./master/*" -print0 | while IFS= read -r -d $'\0' line; do

echo "Doing stuff on $line. this shouldn't hurt much"
#Eliminar borde blanco
convert "$line" -bordercolor white -border 1x1 -alpha set -channel RGBA -fuzz $FUZZ% -fill black -floodfill +0+0 white -shave 1x1 "$line"

#Eliminar borde negro
convert "$line" -bordercolor black -border 1x1 -alpha set -channel RGBA -fuzz $FUZZ% -fill none -floodfill +0+0 black -shave 1x1 "$line"
echo "Looks like we're done with $line, let's check if it should be exterminated"
#Verificar si un tile está en blanco

if [[ $(compare -metric PSNR $line master/transparent.png master/diff.png 2>&1) == "inf" ]]
  then
    echo "$line is blank! Terminating subject. DIE DIE DIE"
    rm -f "$line"
  else
    echo "Looks like $line is good to go. Moving on"
fi

done
