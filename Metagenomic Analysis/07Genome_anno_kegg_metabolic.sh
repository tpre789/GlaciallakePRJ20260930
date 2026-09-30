 
source /datanode02/zhangzh/.apps/kofam.sh
source /datanode02/zhangzh/.apps/DAS_tool.sh
if ls "05MAG/MAG_data/prodigal"* &> /dev/null; then
    echo "prodigal file exist"
else
    echo "mv prodigal flie to 05MAG/MAG_data"
    mv 05MAG/MAG_data/MAG_95/data/prodigal/  05MAG/MAG_data
fi
for i in 05MAG/MAG_data/MAG_95/dereplicated_genomes/* ;  do /datanode02/zhangzh/minisoft/kofamscan -E 1e-5 --cpu 30  -f detail-tsv -o 05MAG/MAG_data/Annotation/KEGG/Raw_result/${i##*/}_kegg_raw.txt   05MAG/MAG_data/prodigal/${i##*/}.faa ;done 
 
for i in 05MAG/MAG_data/Annotation/KEGG/Raw_result/* ; do n=$(basename $i _kegg_raw.txt) ; awk -F"\t" -v n="$n"   'NR>2 && $6<1e-5{print $2,$3,$5,$6,$7,n}' OFS="\t" ${i} |sort -t$'\t' -s -k1,1 -k4g,4 |awk -F"\t" '!a[$1]++'  OFS="\t"  >>05MAG/MAG_data/Annotation/KEGG/MAG_kegg_uniq.txt ;done
source /datanode02/zhangzh/.apps/palmid.sh
cd 05MAG/MAG_data/Annotation/KEGG/
Rscript /datanode02/zhangzh/Rfile/dcast-kegg-mag.R MAG_kegg_uniq.txt 

source activate /datanode02/zhangzh/.conda/envs/metabolic4.sh

# Run METABOLIC-G for metabolic pathway prediction
# -in: Input directory with MAG protein sequences (Prodigal faa)
# -o: Output directory for metabolic analysis results
perl /datanode02/yut/Software/Metabolic/METABOLIC-G.pl \
    -in 05MAG/MAG_data/prodigal/ \
    -o 05MAG/MAG_data/Metabolic_re
