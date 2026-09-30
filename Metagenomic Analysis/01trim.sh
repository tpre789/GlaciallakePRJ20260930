 source /datanode02/zhangzh/.apps/trimgalore.sh 
for i in  `cat  sample.name` ;do   trim_galore --paired --quality 30 --length 100 --max_n 5 -j 8 --fastqc  -o 02Cleandata/Trimgalore_out  01Rawdata/${i}_1.fq.gz 01Rawdata/${i}_2.fq.gz &> 02Cleandata/Trimgalore_out/${i}.log ;done 
