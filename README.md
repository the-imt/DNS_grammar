# DNS_grammar
Simple grammar to turn DNS zone files into CSV files for A and CNAME records

Feed it a DNS zone file and it spits out csv files.  1 each for CNAMES and A records,
named output_label_a.csv and output_label_cname.csv.  Tests worked as expected.
I don't dump AAAA records yet, will add that eventually.

./dns_zone.pl <source> <output_label>

Enjoy.
C.
