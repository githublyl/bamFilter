use strict;
use warnings;
use File::Basename;
use FilterMD;
use CheckBaseQuality;

unless(@ARGV==6){
        &usage;
        die "\n******************************\nError: Please input parameters\n******************************\n";
}

sub usage{
        print "fbam v1.0\n";
        print "perl $0 bam qual_cutoff insertsize_lower insertsize_upper nm_cutoff as_cutoff >sampleid.sam\n";
        print "Input parameters:\n";
        print "\t1. Bam file name\n";
        print "\t2. Mapping quality cutoff\n";
        print "\t3. Insert size minimum cutoff (could be negative, considering PE1 has a negative insert size number comparing to PE2)\n";
        print "\t4. Insert size maximum cutoff\n";
        print "\t5. Maximum edit distance number allowed\n";
        print "\t6. Alignment score\n\n";

        print "Output files:\n";
        print "\t1. Quality summary: prefix.qual.txt\n";
        print "\t2. Clean sam file\n\n";
        print "Email yanli.carol.li\@gmail.com if there are problems\n";
}

my $bamfile=shift;
my $qual_cutoff=shift;
my $insertsize_lower_bound=shift;
my $insertsize_upper_bound=shift;
my $nm_cutoff=shift;
my $as_cutoff=shift;

my $file=basename($bamfile);
my $prefix=(split /\./,$file)[0];
my $samtools="/fml/chones/local/bin/samtools";
open O, ">$prefix.qual.txt" or die $!;
open I, "$samtools view -h $bamfile |" or die $!;
while(<I>){
        chomp;
        if($_=~/^@/){
                print "$_\n";
                next;
        }
        my ($qual,$cigar,$mate,$insertsize,$base_quality)=(split)[4,5,6,8,10];
        $insertsize=abs($insertsize);
        my $flag=1;
        if($qual<$qual_cutoff){
                $flag=0;
                next;
        }
        if($cigar ne "101M"){
                $flag=0;
                next;
        }
        if($mate ne "="){
                $flag=0;
                next;
        }
        if($insertsize<$insertsize_lower_bound || $insertsize>$insertsize_upper_bound){
                $flag=0;
                next;
        }
        $flag=CheckBaseQuality::checkBaseQuality($base_quality);
        if($flag==0){
                next;
        }
        my ($md,$nm_num,$as_num,$xs_num);
        if($_=~/MD\:Z:(\w+\d+)/){
                $md=$1;
        }
        if($_=~/XS\:i\:(\d+)/){
                $xs_num=$1;
        }
        if($_=~/AS\:i\:(\d+)/){
                $as_num=$1;
        }
        if($_=~/NM\:i\:(\d+)/){
                $nm_num=$1;
        }

        if(! defined $md){
                $flag=0;
        }else{
                $flag=FilterMD::filterMD($md);
        }
        if(!defined $nm_num){
                $flag=0;
        }elsif($nm_num>$nm_cutoff){
                $flag=0;
        }
        if(! defined $as_num){
                $flag=0;
        }elsif($as_num<$as_cutoff){
                $flag=0;
        }
        if(! defined $xs_num){
                $flag=0;
        }elsif($xs_num>0){
                $flag=0;
        }

        if($flag==1){
                print "$_\n";
        }

        if( defined $nm_num && defined $as_num && defined $xs_num){
                print O "$qual\t$insertsize\t$nm_num\t$as_num\t$xs_num\n";
        }
}
