cd 05MAG
for i in  binning/*/maxbin2_bins/* ;do  n=${i#*/}; mv  ${i}  ${i%/*}/${n//_matb2_maxb2_conc\/maxbin2_bins\//_ma_} ;done 
for i in  binning/*/metabat2_bins/* ;do  n=${i#*/}; mv  ${i}  ${i%/*}/${n//_matb2_maxb2_conc\/metabat2_bins\//_me_} ;done
for i in  binning/*/concoct_bins/* ;do  n=${i#*/}; mv  ${i}  ${i%/*}/${n//_matb2_maxb2_conc\/concoct_bins\//_co_} ;done
for i in  binning/*vamb/bins/* ;do  n=${i#*/}; mv ${i}  ${i%/*}/${n//_vamb\/bins\//_} ;done 
for i in  binning/*vamb/bins/* ;do  sed 's/>S1C/>/g' ${i} -i ;done 
cd .. 

source /datanode02/zhangzh/.apps/DAS_tool.sh
for i in `cat  sample.name`; do /datanode02/zhangzh/minisoft/DAS_Tool/src/Fasta_to_Contig2Bin.sh -e fa -i 05MAG/binning/${i}_matb2_maxb2_conc/maxbin2_bins/ > 05MAG/DAS/DAS_data/${i}_maxbin.tsv ;done 
for i in `cat  sample.name`; do /datanode02/zhangzh/minisoft/DAS_Tool/src/Fasta_to_Contig2Bin.sh -e fa -i 05MAG/binning/${i}_matb2_maxb2_conc/metabat2_bins/ > 05MAG/DAS/DAS_data/${i}_metabat.tsv ;done 
for i in `cat  sample.name`; do /datanode02/zhangzh/minisoft/DAS_Tool/src/Fasta_to_Contig2Bin.sh -e fa -i 05MAG/binning/${i}_matb2_maxb2_conc/concoct_bins/ > 05MAG/DAS/DAS_data/${i}_concot.tsv ;done 
for i in `cat  sample.name`; do /datanode02/zhangzh/minisoft/DAS_Tool/src/Fasta_to_Contig2Bin.sh -e fna -i 05MAG/binning/${i}_vamb/bins/  >05MAG/DAS/DAS_data/${i}_vamb.tsv ;done 

source /datanode02/zhangzh/.apps/orthofinder.sh
for i in `cat  sample.name`;  do DAS_Tool -i 05MAG/DAS/DAS_data/${i}_maxbin.tsv,05MAG/DAS/DAS_data/${i}_metabat.tsv,05MAG/DAS/DAS_data/${i}_concot.tsv,05MAG/DAS/DAS_data/${i}_vamb.tsv  -l maxbins,metabat2,concoct,vamb --proteins 04ORF/prodigal/${i}_contigs1k_prodigal.faa  -c  03Assembly/contig_1k/${i}_contigs1k.fa  -o 05MAG/DAS/DAS_out/${i}_output/ --search_engine diamond --write_bins   --score_threshold 0  ;done 

mv 05MAG/DAS/DAS_out/*/_DASTool_bins/*  05MAG/MAG_data/DAS_bins/
cd 05MAG/MAG_data
source activate /datanode02/zhangzh/.conda/envs/checkm2
/datanode02/zhangzh/minisoft/checkm2/bin/checkm2 predict -i  05MAG/MAG_data/DAS_bins/*.fa  -x fa -o CheckM2  -t 20 


source  /datanode02/zhangzh/.apps/checkm.sh
export CHECKM_DATA_PATH="/datanode02/zhangzh/database/Checkm_database"
time dRep dereplicate MAG_95  -pa 0.95 -cm larger -p 30  -sa 0.95 -comp 50 -con 10 -g MH_MAG/*.fa
cd  ../../ 
