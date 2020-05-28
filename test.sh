#!/bin/bash
for ((i=1; i<=20; i ++))
do
    echo $i
    sbatch `pwd`/multinode_train.sbatch
    sleep 10     
done


