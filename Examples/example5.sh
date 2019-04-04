#!/bin/sh
opt=2
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
elif [ $opt -le 10 ]
then
	rr1abc1=100
	rr2xy=200
	ss3aaaa=300
	ss34ss=$((($rr1abc1*$rr2xy)*($ss3aaaa-100/($rr2xy-$rr1abc1))))
	if [ $ss34ss -gt $ss3aaaa ]
	then
		y1=$(($rr1abc1+100))
		echo $y1
	elif [ $ss34ss -lt 1000 ]
	then
		echo "$ss34ss is little than 1000"
	fi 
else
	echo 'printing opt'
	echo "opt = $opt"
fi

echo 'end of program'
