#!/bin/bash
# Configuration values for SLURM job submission.
# One leading hash ahead of the word SBATCH is not a comment, but two are.
#SBATCH --time=48:00:00 
##SBATCH -x node[110]
#SBATCH --job-name=means
#SBATCH -n 1 
#SBATCH -N 1   
#SBATCH --gres=gpu:a100:1
#SBATCH --cpus-per-task=1  
#SBATCH --constraint=high-capacity    
#SBATCH --mem=200gb  
#SBATCH --output /orcd/archive/abugoot/001/Projects/Matteo/Github/directed_evolution/extract/esm/out/means-%j.out 

source ~/.bashrc
conda activate embeddings

cd  /orcd/archive/abugoot/001/Projects/Matteo/Github/

study_names=("mlv_2nd_2" "mlv_3rd_2" "mlv_4th_2" "mlv_5th_2" "mlv_6th_2" "mlv_7th_2")

model_names=("/orcd/archive/abugoot/001/Projects/Matteo/Github/directed_evolution/.cache/torch/hub/checkpoints/esm2_t48_15B_UR50D.pt")

fasta_path="directed_evolution/data_processing/output/"
results_path="directed_evolution/extract/esm/results_means/"

repr_layers=48
toks_per_batch=512

for model_name in "${model_names[@]}"; do
  for study in "${study_names[@]}"; do
    model_part=$(basename "${model_name}")
    model_part="${model_part%%.*}"  # Removing extension

    command="python3 directed_evolution/extract/esm/extract.py ${model_name} ${fasta_path}${study}.fasta ${results_path}${study}/${model_part} --toks_per_batch ${toks_per_batch} --include mean"
    echo "Running command: ${command}"
    eval "${command}"
  done
done