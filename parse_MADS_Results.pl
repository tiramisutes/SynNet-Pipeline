#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long;
use List::Util qw(sum max min);
#=pod 
###############################################
# 
#  C o m m a n d   l i n e   o p t i o n s
#
###############################################

my $limit;       # limit processing of data to first $limit sequences (for quick testing)
my $graph;       # produce some output ready for Excel or R
my $csv;         # produce CSV output file of results
my $n_limit;     # how many N characters should be used to split scaffolds into contigs
my $genome_size; # estimated or known genome size (will be used for some stats)
 
GetOptions ("limit=i"       => \$limit,
			"csv"           => \$csv, 
			"graph"         => \$graph,
			"n=i"           => \$n_limit,
			"genome_size=i" => \$genome_size);

# check we have a suitable input file
my $usage = "Usage: parse_MADS_Results.pl <MADS_Results>
options:
	-limit <int> limit analysis to first <int> sequences (useful for testing)
	-csv         produce a CSV output file of all results
	-graph       produce a CSV output file of NG(X) values (NG1 through to NG99), suitable for graphing
	-n <int>     specify how many consecutive N characters should be used to split scaffolds into contigs
	-genome_size <int> estimated or known genome size
";

die "$usage" unless (@ARGV == 1);
my ($file) = @ARGV;
#=cut 
#open(IN,"/public/home/zpxu/MADS_Results") or die $!;
open(IN,$file) or die $!;

while(<IN>){ 
	last if(/^Scores for complete sequences/); 
} 
if(<IN>){
	<IN>;
	while(<IN>){
		chomp;
		if(/^\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+?)$/){
			my $id = $9;
			my $score = $2;
			my $evalue = $1;
			print "$id\t$score\t$evalue\n";
		} else {
			last;
		}
	} 
}
close IN;
