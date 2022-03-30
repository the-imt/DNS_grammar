=begin pod

=head1 NAME

dns_data

=head1 SYNOPSIS

dns_data

Library to handle parsed DNS zone files from the associated grammar

=head1 DESCRIPTION

This application takes input from a Raku parser.  It then does a bunch of
different thngs.  I'll probably add more here eventually


=head1 GENERATED BY

Some guy with a keyboard

=head1 AUTHOR

Colin Wass

=head1 LICENSE


Copyright (c) 2018 - 2022, Colin Wass, The IMT
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that
the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.


=end pod


unit module dns_data;

class DNS_data is export {

							
	has %.DomainData;
	has %.Cnames;

	method CNAME(%line_in)  {
		%.Cnames{%line_in<value>} = %line_in<additional>;
		
	}
	
	method A(%line_in)  {
		#Yeah, I know, but the method name matches the record type
		%.DomainData{%line_in<value>} = %line_in<additional>;
	}

	method AAAA(%line_in)  {
		#Yeah, I know, see above where I copy/pasted this from
		%.DomainData{%line_in<value>} = %line_in<additional>;
	}
	
	method ingest(%line_in)  {
		my $action = %line_in{"type"};
		if self.^lookup($action)  {
			self."$action"(%line_in);
		}
	}

	# The following 2 methods exist for testing purposes, they don't really do anything else at this point

	method get_record($label)  {
		return %.DomainData{$label} if %.DomainData{$label}:exists;
	}
	
	method get_cname($label)  {
		return %.Cnames{$label} if %.Cnames{$label}:exists;
	}
	
	method csv_out($filename)  {

		for %.DomainData.kv -> $host, $label  {
			say "$host\t$label";
		}

		my $a_filename = $filename ~ "_a.csv";
		my $cname_filename = $filename ~ "_cname.csv";
		spurt "reports/$a_filename", "hostname,definition\n", :createonly;
		for %.DomainData.kv -> $hostname, $definition  {
			spurt "reports/$a_filename", "$hostname,$definition\n", :append;
		}
		spurt "reports/$cname_filename", "alias,hostname\n", :createonly;
		for %.Cnames.kv -> $alias, $hostname  {
			spurt "reports/$cname_filename", "$alias,$hostname\n", :append;
		}
		return;
	}
		
}
	
