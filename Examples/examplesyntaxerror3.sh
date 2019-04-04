#!/bin/sh
x32zz11=1
yttt122xx=$(($x32zz11+10))
if [ $yttt122xx -gt 25 ]
then
        z=$((($x32zz11+10)*$yttt122xx))
        echo $yttt122xx
        echo "x32zz11 = $x32zz11 and z= $z"
elif [ $yttt122xx -ge 22 ]
then
        z=40
        echo $(($x32zz11+$yttt122xx))
        echo "yttt122xx = $yttt122xx and z= $z"
else
        echo 'Prints x32zz11*yttt122xx'
        echo $(($x32zz11*$yttt122xx))
# Syntax error : If clauses should be closed by a fi.
