#!/bin/sh
opt=2
if [ $opt -eq 1 ]
then
	max=6
	s=1
	f=1
	start=1
	while [ $start -le $max ]
	do
		s=$(($s+$start))
		f=$(($f*$start))
		start=$(($start+1))
	done
	echo 'printing sum'
	s=$(($s-1))
	echo $s
	echo "Mult is $f"
elif [ $opt -eq 2 ]
then
	num1=100
	r=1
	while [ $r -lt $num1 ]
	do
		r=$(($r*2))
		if [ $r -lt 80 ]
		then
		echo $r
		fi
	done
else
	echo 'printing opt'
	echo "opt = $opt"
fi

echo 'end of program'
