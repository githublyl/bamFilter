package CheckBaseQuality;

use strict;
use warnings;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION=1.00;
@ISA=qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(func1 func2);
%EXPORT_TAGS = ( DEFAULT => [qw(&checkBaseQuality)]);

sub checkBaseQuality{
        my $quality=shift;
        my $read_length=length($quality);
        my $window_size=10;
        my $step_size=6;
        my $iteration=int(($read_length-$window_size)/$step_size);

        my @bases=split //,$quality;
        my $flag=1;
        for(my $i=0;$i<$iteration;$i++){
                my $start_num=$i*$step_size;
                my $end_num=$start_num+$window_size;
                my @tmp=@bases[$start_num .. $end_num];
                my $window_seq=join "",@tmp;
                my $flag=&calASCII($window_seq);
                if($flag==0){
                        return 0;
                }
        }
        return $flag;
}

sub calASCII{
        my $seq=shift;
        my @tmp=split //,$seq;
        my $sum=0;
        foreach my $base(@tmp){
                my $ascii=ord($base)-33;
                $sum+=$ascii;
        }
        my $average=$sum/@tmp;
        if($average<30){
                return 0;
        }else{
                return 1;
        }
}

