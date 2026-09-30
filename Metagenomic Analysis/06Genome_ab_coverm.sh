 source /datanode02/zhangzh/.apps/coverm.sh
mkdir  coverm_tmp
export TMPDIR="coverm_tmp" 
for i in `cat  sample.name`; do coverm genome --coupled 02Cleandata/Trimgalore_out/${i}_1.fq.gz  02Cleandata/Trimgalore_out/${i}_2.fq.gz -t 30 --methods tpm --genome-fasta-files 05MAG/MAG_data/MAG_95/dereplicated_genomes/* -x fa -o 05MAG/MAG_data/Coverm/Raw_result/${i}_coverm.tsv ;done 
rm coverm_tmp -r 
cd 05MAG/MAG_data/Coverm/

for i in Raw_result/* ;do  awk -F"\t" '{print $2}' ${i} >process/${i#*/} ;done
\ls Raw_result/*tsv |head -n 1 |xargs awk -F"\t" '{print $1}' OFS="\t" >NAME
paste NAME process/* >Abundance_merge.tsv
