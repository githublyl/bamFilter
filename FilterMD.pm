package FilterMD;

use strict;
use warnings;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION=1.00;
@ISA=qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(func1 func2);
%EXPORT_TAGS = ( DEFAULT => [qw(&filterMD)]);


sub filterMD{
        my $line=shift;
        my $cutoff=10;

        my $flag=1;
        if($line!~/^\d/){
                $flag=0;
                print STDERR "NOT MD:\t$line\n";
                return $flag;
        }
        if($line!~/\d$/){
                $flag=0;
                print STDERR "NOT MD:\t$line\n";
                return $flag;
        }
        my @num=split /(?:A|T|C|G)/,$line;
        if($#num >6){
                $flag=0;
        }
        if($num[0]<$cutoff){
                $flag=0;
        }
        if($num[-1]<$cutoff){
                $flag=0;
        }
        return $flag;
}
