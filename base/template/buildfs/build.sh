#!/bin/sh
names=`cat fs.def`
cd armbase
for i in $names
do
mkdir $i
done
cd ..
