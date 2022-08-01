#!/bin/sh

set -e # exit run_tests.sh if anything fails

echo "distribution plot..."
time methylartist scoredist -n 300000 -d data/MCF7_ATCC.sample.megalodon.db,data/MCF7_ECACC.sample.megalodon.db -m m

echo "segmeth..."
time methylartist segmeth -d MCF7.example.data.txt -i MCF7.example.segments.bed -p 8

echo "segplot..."
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma 
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma -a
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma -a

echo "~15kbp locus from db..."
time methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes

echo "test --primary_only option"
time methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --primary_only

echo "~15kbp locus from mod bam..."
time methylartist locus -b data/MCF7_ATCC.modification_tags.bam,data/MCF7_ECACC.modification_tags.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref /home/data/ref/hg38/Homo_sapiens_assembly38.fasta --motif CG

echo "use MM/ML instead of Mm/Ml..."
methylartist locus -b data/MCF7_ATCC.modification_tags.caps_MM_ML.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref /home/data/ref/hg38/Homo_sapiens_assembly38.fasta --motif CG

echo "~30 kbp phased locus..."
time methylartist locus -d MCF7.example.data.txt -i chr19:56810076-56870725 -l 56835376-56840476 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genes PEG3 --samplepalette viridis --phased --maskcutoff 0

echo "~2 Mbp region..."
time methylartist region -d MCF7.example.data.txt -i chr19:55810082-57840726 -n CG -r /home/data/ref/hg38/Homo_sapiens_assembly38.fasta -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis --samplepalette magma
