## methylartist-tests
Test data and examples for methylartist (https://github.com/adamewing/methylartist).

Run all examples using `run_tests.sh` and compare to output below.

### Example using `scoredist`:
```
methylartist scoredist -n 300000 -d data/MCF7_ATCC.sample.megalodon.db,data/MCF7_ECACC.sample.megalodon.db -m m
```
![scoredist](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7_ATCC.sample.megalodon.db_MCF7_ECACC.sample.megalodon.db.scoredist.png?raw=true)

### Example using `segmeth`:
```
methylartist segmeth -d MCF7.example.data.txt -i MCF7.example.segments.bed -p 8
```
Yields a file: `MCF7.example.segments.MCF7.example.data.segmeth.tsv`

### Various `segplot` examples:
```
methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma 
methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -v --palette magma -a
methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma
methylartist segplot -s MCF7.example.segments.MCF7.example.data.segmeth.tsv -c LOW,MED1,MED2,HIGH -g --palette magma -a
```
![segplot1](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.segments.MCF7.example.data.segmeth.mc10.mr1.violin.segplot.png?raw=true)
![segplot2](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.segments.MCF7.example.data.segmeth.mc10.mr1.violin.group_by_annotation.segplot.png?raw=true)
![segplot3](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.segments.MCF7.example.data.segmeth.mc10.mr1.ridge.segplot.png?raw=true)
![segplot4](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.segments.MCF7.example.data.segmeth.mc10.mr1.ridge.group_by_annotation.segplot.png?raw=true)

### Example using `locus`:
```
methylartist locus -d MCF7.example.data.txt -i chr19:56172382-56187168 --samplepalette crest -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes
```
![locus](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.data.chr19_56172382_56187168.m.ms1.smw24.locus.meth.png?raw=true)

### Example using `locus` with methylation calls stored in a .bam file using `MM` and `ML` tags, plus some other features:
```
methylartist with command: /home/taewing/miniconda3/bin/methylartist locus -b data/MCF7_ATCC.modification_tags.bam,data/MCF7_ECACC.modification_tags.bam -i chr19:56172382-56187168 --samplepalette cubehelix -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG --show_transcripts --smoothed_csv test.csv --exonheight 0.6 --panelratios 2,5,1,3,3
```
![locus_bam](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7_ATCC.modification_tags.chr19_56172382_56187168.m.cohort.ms1.smw24.locus.meth.png?raw=true)

### Example using `locus` with phased sample (`HP` and `PS` tags):
```
methylartist locus -d MCF7.example.data.txt -i chr19:56810076-56870725 -l 56835376-56840476 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genes PEG3 --samplepalette viridis --phased --maskcutoff 0
```
![locus_phased](https://github.com/adamewing/methylartist-tests/blob/main/png/PEG3.MCF7.example.data.chr19_56810076_56870725.m.phased.ms1.smw32.locus.meth.png?raw=true)

### Example using `region` to plot a 2 Mbp segment:
```
methylartist region -d MCF7.example.data.txt -i chr19:55810082-57840726 -n CG -r /home/data/ref/hg38/Homo_sapiens_assembly38.fasta -p 8 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --genepalette viridis --samplepalette magma
```
![region](https://github.com/adamewing/methylartist-tests/blob/main/png/MCF7.example.data.chr19_55810082-57840726.m.s26.w2013.m3.region.meth.png?raw=true)

### Visualising methylation from C/T substitution data via .bam file (BS-seq, EM-seq):

![ctbam](https://github.com/adamewing/methylartist-tests/blob/main/png/NA12878.EMSEQ.GAPDH.chr12_6517169_6555718.m.ms1.smw34.mt0.8.ct0.8.locus.meth.png?raw=true)

```
methylartist locus -b data/NA12878.EMSEQ.GAPDH.bam --ctbam data/NA12878.EMSEQ.GAPDH.bam -i chr12:6,517,169-6,555,718 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --panelratios 5,5,1,3,3 --ref data/Homo_sapiens_assembly38.fasta.gz --motif CG --skip_raw
```

### Loading and display of C/U substitution based data (e.g. BS-seq or EM-seq) (*depreciated*)


```
methylartist db-sub -b NA12878.EMSEQ.GAPDH.bam -d NA12878.EMSEQ.GAPDH.db

cat sub_test.data.txt
NA12878.EMSEQ.GAPDH.bam NA12878.EMSEQ.GAPDH.db

methylartist locus -d sub_test.data.txt -i chr12:6,517,169-6,555,718 -g data/Homo_sapiens.GRCh38.97.chr.sorted.gtf.gz --labelgenes --panelratios 5,5,1,3,3
```

![sub](https://github.com/adamewing/methylartist-tests/blob/main/png/sub_test.data.chr12_6517169_6555718.m.ms1.smw34.locus.meth.png?raw=true)


