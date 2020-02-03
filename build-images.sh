#!/bin/bash
#To change stroke color https://gordonlesti.com/inkscape-change-the-color-of-markers/
color="#ffffff"
if test [$1 ="dark"];
    then
    color='#ff0000'
else
    color='#ff0000'
fi

options='--export-width=16 --export-height=16 --export-background-opacity=0.0'

wget https://use.fontawesome.com/releases/v5.12.0/fontawesome-free-5.12.0-desktop.zip
unzip fontawesome-free-5.12.0-desktop.zip

for f in $(find "./fontawesome-free-5.12.0-desktop" -name "*.svg");
    do
    echo $f
    cat $f > temp.txt
    out='<path style="fill:none;stroke:'$color';"'
    sed -e "s/<path /$out/" temp.txt > $f
    rm temp.txt
    width=$(inkscape -W $f)
    echo width
    height=$(inkscape -H $f)
    echo height
    width=$(($(echo "($width+0.5)/1" | bc)/32))
    echo width $width
    height=$(($(echo "($height+0.5)/1" | bc)/32))
    echo height $height
    inkscape --without-gui --export-png="${f//.svg}" $options $f
done
# rm -r fontawesome-free-5.12.0-desktop
rm fontawesome-free-5.12.0-desktop.zip