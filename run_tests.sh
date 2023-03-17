#!/bin/sh

if [ ! -e data/Homo_sapiens_assembly38.fasta.gz ] ; then
    echo "Please download the GATK HG38 reference. For example:"
    echo "wget -P data https://media.githubusercontent.com/media/broadinstitute/gatk/master/src/test/resources/large/Homo_sapiens_assembly38.fasta.gz"
    exit 1
fi

if [ ! -e data/Homo_sapiens_assembly38.fasta.gz.fai ] ; then
    echo "indexing reference..."
    samtools faidx data/Homo_sapiens_assembly38.fasta.gz
fi

set -e # exit run_tests.sh if anything fails

echo -e "\ndistribution plot...\n"
time methylartist scoredist -n 300000 -d data/MCF7_ATCC.sample.megalodon.db,data/MCF7_ECACC.sample.megalodon.db -m m

echo -e "\nsegmeth...\n"
time methylartist segmeth -d MCF7.example.data.txt -i MCF7.example.segments.bed -p 8

echo -e "\nsegmeth from modbam...\n"
time methylartist segmeth -b data/MCF7_ATCC.modification_tags.bam -i MCF7.example.segments.bed -p 8 --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG

echo -e "\nsegplot...\n"
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma 
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma -a
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma
time methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma -a

echo -e "\nwgmeth...\n"
time methylartist wgmeth -b data/MCF7_ATCC.modification_tags.bam -f data/Homo_sapiens_assembly38.fasta.gz.fai -c chr19 --mod m --motif CG --ref data/Homo_sapiens_assembly38.fasta.gz -s 10000 -p 8 --dss

echo -e "\nwgmeth phased..."
time methylartist wgmeth -b data/MCF7_ATCC.sample.haplotag.bam -d data/MCF7_ATCC.sample.megalodon.db -f data/Homo_sapiens_assembly38.fasta.gz.fai -c chr19 --mod m -s 10000 -p 8 --dss --phased

echo -e "\n~15kbp locus from db...\n"
time methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes

echo -e "\n~15kbp locus from db, limit smoothed axis...\n"
time methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ymin 0.2 --ymax 0.8

echo -e "\ntest --primary_only option\n"
time methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --primary_only

echo -e "\n~15kbp locus from mod bam...\n"
time methylartist locus -b data/MCF7_ATCC.modification_tags.bam,data/MCF7_ECACC.modification_tags.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG

echo -e "\n~15kbp locus from mod bam custom colour...\n"
time methylartist locus -b data/MCF7_ATCC.modification_tags.bam:#32a852,data/MCF7_ECACC.modification_tags.bam:#9a32a8 -i chr19:56172382-56187168 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG

echo -e "\n~15kbp locus from mod bam custom colour from file...\n"
time methylartist locus -b test_colours.txt -i chr19:56172382-56187168 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG

echo -e "\n~15kbp locus from mod bam, primary_only...\n"
time methylartist locus -b data/MCF7_ATCC.modification_tags.bam,data/MCF7_ECACC.modification_tags.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG --primary_only

echo -e "\nuse MM/ML instead of Mm/Ml...\n"
methylartist locus -b data/MCF7_ATCC.modification_tags.caps_MM_ML.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG

echo -e "\n~30 kbp phased locus...\n"
time methylartist locus -d MCF7.example.data.txt -i chr19:56810076-56870725 -l 56835376-56840476 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genes PEG3 --samplepalette viridis --phased --maskcutoff 0

echo -e "\n~2 Mbp region...\n"
time methylartist region -d MCF7.example.data.txt -i chr19:55810082-57840726 -n CG -r data/Homo_sapiens_assembly38.fasta.gz -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis --samplepalette magma

echo -e "\n~2 Mbp region from modbam custom colour...\n"
time methylartist region -b data/MCF7_ATCC.modification_tags.bam:#32a852,data/MCF7_ECACC.modification_tags.bam:#9a32a8 -i chr19:55810082-57840726 -n CG -r data/Homo_sapiens_assembly38.fasta.gz -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis 

echo -e "\n~2 Mbp region from modbam custom colour from file...\n"
time methylartist region -b test_colours.txt -i chr19:55810082-57840726 -n CG -r data/Homo_sapiens_assembly38.fasta.gz -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis 

echo -e "\n~2 Mbp region, limit smoothed y-axis...\n"
time methylartist region -d MCF7.example.data.txt -i chr19:55810082-57840726 -n CG -r data/Homo_sapiens_assembly38.fasta.gz -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis --samplepalette magma --ymin 0.2 --ymax 0.8
