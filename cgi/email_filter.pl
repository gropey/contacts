# email_filter.pl
# SEP 2015 
use strict;
use CGI qw(:standard escapeHTML);
use WebDB;

my $repno = param("ae") || 0;
my $str_srch = param("str");
my $dbh = WebDB::conn('cnts');
my $sql=<<EOF;
SELECT case e.taxstatus when "Y" then "Taxable" when "N" then "TaxFree" else "Any" end as taxstatus,
case e.rating when "I" then "InvGrd" when "J" then "HighYield" else "Any" end as rating,
case e.mat when 0 then "0-5yrs" when 1 then "5-10yrs" when 2 then "10+ yrs" else "Any" end as mat,
e.px,e.acctn,e.email,e.ae,e.state,e.added,e.cid,e.ok,e.id,
s.definition,c.contacts,c.organization
FROM inqemails e 
LEFT JOIN contactrecords c ON e.cid = c.id 
JOIN sendstatus s ON e.ok = s.code
WHERE e.ae = ? AND e.email REGEXP ?
ORDER BY e.email
LIMIT 500
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($repno,$str_srch);
print header(-type=>'text/xml'),WebDB::xml_data($sth);
exit;
