\ls 02Cleandata/Trimgalore_out/*gz  |  awk -F"/" '$4=$3{sub("_1_val","",$3); print "mv "$1,$2,$4"\t"$1,$2,$3 }' OFS="/"|sh

\ls 02Cleandata/Trimgalore_out/*gz  |  awk -F"/" '$4=$3{sub("_2_val","",$3); print "mv "$1,$2,$4"\t"$1,$2,$3 }' OFS="/"|sh

 source /apps/source/megahit-1.2.9.sh
for i in `cat  sample.name`; do  megahit  -t 30  --min-contig-len 500 -o 03Assembly/megahit/${i}   --out-prefix  ${i} -1 02Cleandata/Trimgalore_out/${i}_1.fq.gz    -2 02Cleandata/Trimgalore_out/${i}_2.fq.gz ;done 
for i in `cat  sample.name`; do rm  03Assembly/megahit/${i}/intermediate_contigs -r ;done 

for i in 03Assembly/megahit/*/*fa; do 
    n=$(basename $i .contigs.fa)
    # 检查第一行是否已包含样本名（如果已包含则跳过）
    if ! grep -q "^>${n}_" "$i"; then
        sed "s:>:>${n}_:g" "$i" -i
    fi
done

source /apps/source/seqkit-2.2.0.sh 
for i  in 03Assembly/megahit/*/*fa ;do n=$(basename $i .contigs.fa); seqkit seq -m 1000  $i >03Assembly/contig_1k/${n}_contigs1k.fa  ;done
