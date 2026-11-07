#!/bin/bash

#SBATCH -J mw=nvt # Name of your job
#SBATCH -p shared # Partition name
#SBATCH -N 1 # Total number of nodes allocated
#SBATCH --ntasks-per-node=24 # 8 MPI tasks per node (16 total tasks)
#SBATCH --cpus-per-task=1 # 1 core per task (pure MPI)
#SBATCH -t 72:00:00 # Walltime limit (HH:MM:SS)
#SBATCH --mem-per-cpu=2G

# Load the exact module used during compilation
module load compiler/openmpi/4.1.6

# Path to your executable and input script
exe=/home/rajeshch/softwares/lammps-21Nov2023/src/lmp_mpi
input_script=script-NVT.lmp

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Run LAMMPS across 16 total cores (2 nodes x 8 tasks)
#mpirun -n $SLURM_NTASKS $exe -in $input_script > outsample.lmp
mpirun --mca pml ucx --mca btl ^openib -n $SLURM_NTASKS $exe -in $input_script > outsample.lmp