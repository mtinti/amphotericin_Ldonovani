#!/bin/bash 
#$ -adds l_hard local_free 200G
#$ -mods l_hard m_mem_free 30G
#$ -adds l_hard avx 1 
#$ -cwd
#$ -V
#$ -j y
#$ -pe smp 40
#$ -N Ovarflow_AMB_LdV9
#$ -o Ovarflow_AMB_LdV9_errors_$JOB_ID

set -e

exp_path='/cluster/majf_lab/mtinti/MUT_analysis/experiments/MetaAnalysis/DataSets/AMB/'

echo 'copy files in '$TMPDIR
cp -Lr $exp_path'ovarflow_input_LdV9' $TMPDIR/ovarflow

echo 'run singularity'
export THREADS=40
singularity run --bind $TMPDIR/ovarflow:/input /cluster/majf_lab/mtinti/MUT_analysis/experiments/OVarFlow_May10_2021_BQSR.sif

echo 'run filtering variants'

python /cluster/majf_lab/mtinti/MUT_analysis/experiments/MetaAnalysis/filter_variants.py \
$TMPDIR'/ovarflow/24_annotated_variants_2/variants_annotated.vcf.gz' \
$TMPDIR'/ovarflow/24_annotated_variants_2/ovarflow.different.annotated.vcf'

echo 'copy results'
mkdir -p $exp_path'res_LdV9/ovarflow_res'

cp -r $TMPDIR/ovarflow/24_annotated_variants_2 $exp_path'res_LdV9/ovarflow_res'

cp -r $TMPDIR/ovarflow/03_mark_duplicates $exp_path'res_LdV9/ovarflow_res'

cp -r $TMPDIR/ovarflow/snpEffDB $exp_path'res_LdV9/ovarflow_res'



