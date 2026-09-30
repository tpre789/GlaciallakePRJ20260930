 
source /apps/source/prodigal-2.6.3.sh 
for i in `cat  sample.name` ; do  prodigal -p meta -q -m -i  03Assembly/contig_1k/${i}_contigs1k.fa   -a 04ORF/prodigal/${i}_contigs1k_prodigal.faa -d 04ORF/prodigal/${i}_contigs1k_prodigal.fna -o 04ORF/prodigal/${i}_contigs1k_prodigal.gff -f gff  ;done 
