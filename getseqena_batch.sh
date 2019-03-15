#!/bin/bash
#SBATCH -J aspera_SRA
#SBATCH -t 02:00:00
#SBATCH --mem-per-cpu=10
#SBATCH --array=1-61
#SBATCH -n 1
#SBATCH -p serial
#SBATCH --cpus-per-task=5

#list_of_acclistst contains lists of files with the SRA accessions

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p list_of_acclists)

module load bioconda/3
source activate aspera
module load python-env/2.7.10
module load biokit
#while read name
#do

python2.7 /homeappl/home/parnanen/appl_taito/getSeqENA/getSeqENA.py  -a /wrk/parnanen/DONOTREMOVE/bioconda3_env/aspera/etc/asperaweb_id_dsa.openssh  -l "accession_list_sub"$name -o . -j 5 --SRA
used_slurm_resources.bash
#done < list_of_acclists
