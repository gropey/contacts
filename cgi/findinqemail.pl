# findinqemail.pl
# Sep 2011 
use strict;
use CGI qw(:standard escapeHTML);

my $find = param("chrs");
my $rep = param("rep");
my $dbh = WebDB::conn('cnts');
my $sql=<<EOF;
SELECT ifnull(c.contacts,'n/a') AS contacts,ifnull(c.organization,'n/a') as organization,i.taxstatus,
i.rating,i.mat,i.px,i.email,i.acctn,i.ae,i.state,i.added,i.cid,ok+0,i.id 
FROM inqemails i 
LEFT JOIN contactrecords c ON i.cid = c.id OR i.email = c.email
WHERE i.email REGEXP ? AND i.ae = ? 
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($find,$rep);
print header(-type=>'text/plain'),join "|", $sth->fetchrow_array();
exit;
