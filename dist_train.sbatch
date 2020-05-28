#!/bin/bash
#SBATCH -p caspra
#SBATCH -N 1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --gres=dcu:4
#SBATCH -J tensorpack
#SBATCH -o ./log/output.%j
#SBATCH -e ./log/output.%j
date
module load apps/TensorFlow/1.14.0/hpcx-2.4.1-gcc-7.3.1
which python3
which mpirun
export PYTHONPATH=`pwd`/../:${PYTHONPATH}

hostfile=./$SLURM_JOB_ID
scontrol show hostnames $SLURM_JOB_NODELIST > ${hostfile}
for i in `cat ./${hostfile}`
do
echo ${i} slots=4 >> ./hostfile-dl-$SLURM_JOB_ID
((num_node=${num_node}+1))
done
((num_DCU=${num_node}*4))

export TF_GPU_THREAD_COUNT=4
export TF_GPU_THREAD_MODE='gpu_private'
export OMP_NUM_THREADS=2

mpirun -np $num_DCU --hostfile `pwd`/hostfile-dl-$SLURM_JOB_ID python3 `pwd`/train.py --logdir train_log/log_$SLURM_JOB_ID
