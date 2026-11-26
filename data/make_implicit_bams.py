#!/usr/bin/env python

''' Re-tag MCF7_ATCC.modification_tags.bam (legacy unflagged Mm:Z:C+m) over the test locus as a pair:
    *.ambiguous.bam: MM:Z:C+m? with every call kept
    *.implicit.bam:  MM:Z:C+m. with calls below 51/255 dropped, i.e. left implicit (canonical)
    locus should give about the same methylation for both. '''

import array
import pysam

chrom = "chr19"
start = 56172382
end   = 56187168

ml_cutoff = 51  # p_mod < 0.2: canonical under the default --can_thresh 0.8

bam = pysam.AlignmentFile('MCF7_ATCC.modification_tags.bam')

outs = {
    '?': pysam.AlignmentFile('MCF7_ATCC.modification_tags.ambiguous.bam', 'wb', template=bam),
    '.': pysam.AlignmentFile('MCF7_ATCC.modification_tags.implicit.bam', 'wb', template=bam),
}

for read in bam.fetch(chrom, start, end):
    if not read.has_tag('Mm') or not read.get_tag('Mm').startswith('C+m,'):
        continue

    skips = list(map(int, read.get_tag('Mm').rstrip(';').split(',')[1:]))
    mls = list(read.get_tag('Ml'))

    for mode, out in outs.items():
        new_skips = []
        new_mls = []
        carry = 0

        for skip, ml in zip(skips, mls):
            if mode == '.' and ml < ml_cutoff:
                carry += skip + 1
            else:
                new_skips.append(skip + carry)
                new_mls.append(ml)
                carry = 0

        read.set_tag('Mm', None)
        read.set_tag('Ml', None)
        read.set_tag('MM', 'C+m' + mode + ''.join(',%d' % s for s in new_skips) + ';')
        read.set_tag('ML', array.array('B', new_mls))

        out.write(read)

for out in outs.values():
    out.close()
    pysam.index(out.filename.decode())
