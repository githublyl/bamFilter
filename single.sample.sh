bamdir="/.../8.indel_realignment"
prefix=$1
bam=$bamdir/$prefix.pe.fixmate.sort.merge.rmdup.realigned.bam
newbamdir="/.../9.filter_bam/new_bam"
outsam=$newbamdir/$prefix.after_custom_filter.sam
outbam=$newbamdir/$prefix.after_custom_filter.bam
bin="/.../9.filter_bam/fbam/filter_bam.pl"


perl $bin   $bam 50  150 300 3 50  >$outsam
samtools view -b $outsam >$outbam


