#!/bin/bash
num=0
total=0

while [[ $total -le 100 ]]
do
	num=$(expr $num + 1)
	total=$(expr $num + $total)
	echo $total
done
