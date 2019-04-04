#!/bin/sh
opt=1
if [ $opt -eq 1 ]
then
	x1=1
	x2=4
	x3=$((($x1*$x2)-($x1+$x2)))
	if [ $x3 -lt 10 ]
	then
		echo 'printing x3'
		echo $x3
	fi
        echo $x1
        echo "printing x2 x2=$x2"
else
	echo 'printing opt'
	echo "opt = $opt"
fi
