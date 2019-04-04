#!/bin/sh
z=100
a1=$(($z+10))
if [ $a1 -le 200 ]
then
        a=$(((z+10)*a1))
        echo $a1
fi
