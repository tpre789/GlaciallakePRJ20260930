 source /datanode02/zhangzh/.apps/metawrap.sh
for i in `cat  sample.name` ; do metawrap binning --metabat2 --maxbin2 --concoct -o 05MAG/binning/${i}_matb2_maxb2_conc  -t 30 -m 100  -a   03Assembly/contig_1k/${i}_contigs1k.fa    02Cleandata/Trimgalore_out/${i}_1.fq.gz     02Cleandata/Trimgalore_out/${i}_2.fq.gz  ;done 
source /datanode02/zhangzh/.apps/vamb.sh
source /apps/source/samtools-1.15.1.sh
for i in `cat  sample.name` ; do concatenate.py 05MAG/binning/${i}.fa.gz  03Assembly/contig_1k/${i}_contigs1k.fa   &>05MAG/binning/${i}_concatenate.log &&  minimap2 -d 05MAG/binning/${i}.fa.mmi 05MAG/binning/${i}.fa.gz &> 05MAG/binning/${i}_index.log &&  minimap2 -t 30 -N 50 -ax sr  05MAG/binning/${i}.fa.mmi   02Cleandata/Trimgalore_out/${i}_1.fq.gz     02Cleandata/Trimgalore_out/${i}_2.fq.gz |    samtools view -F 3584 -b --threads 30 > 05MAG/binning/${i}.bam  &&   time vamb --outdir 05MAG/binning/${i}_vamb --fasta 05MAG/binning/${i}.fa.gz --bamfiles 05MAG/binning/${i}.bam -o C --minfasta 200000 ;done 
for i  in `cat  sample.name` ; do rm 05MAG/binning/${i}.bam ;done 
