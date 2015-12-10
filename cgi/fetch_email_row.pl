# fetch_email_row.pl
# Sep 2011 
use strict;
use CGI qw(:standard);
my $find = param("email");

if (!$find) {
    print header(-type=>'text/plain'),"Error";
    exit;
}

my $dbh = WebDB::conn('cnts');
my $sql=<<EOF;
SELECT i.taxstatus,i.rating,i.mat,i.px,i.email,i.acctn,i.ae,i.state,i.added,i.cid,i.ok+0,i.id,z.zip,
c.organization
FROM inqemails i
LEFT JOIN contactrecords c ON (i.cid = c.id OR i.email = c.email)
LEFT JOIN zips z ON i.id = z.eid 
WHERE i.email = ?
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($find);
print header(-type=>'text/plain'),join ",", $sth->fetchrow_array();
exit;

