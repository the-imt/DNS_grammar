#!/usr/bin/raku

use lib './lib';

use dns_grammar;
use dns_grammar_AD;
use dns_data;


sub MAIN($source, $outfile, $type="def")  {

	my $OutData = DNS_data.new();
	if $type eq "ad"  {
		for $source.IO.lines -> $line  {
			next if $line ~~ /';'/;
			my $DNS_parsed = DNS_grammar_AD.parse($line, actions => DNS_captures.new);
			next unless $DNS_parsed.defined();
			my $GetIt = $DNS_parsed.made;
			$OutData.ingest($GetIt<line>);
		}	
		
	} else  {
		for $source.IO.lines -> $line  {
			next if $line ~~ /';'/;
			my $DNS_parsed = DNS_grammar.parse($line, actions => DNS_captures.new);
			next unless $DNS_parsed.defined();
			my $GetIt = $DNS_parsed.made;
			$OutData.ingest($GetIt<line>);
		}
	}
	$OutData.csv_out($outfile);
}

