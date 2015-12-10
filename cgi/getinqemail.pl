# getinqemail.pl
# Jan 2011 
use strict;
use CGI qw(:standard escapeHTML);
my $id = param('id') || 0;
my $dbh = WebDB::conn('cnts');

my $sql=<<EOF;
SELECT c.contacts,c.organization,i.taxstatus,i.rating,i.mat,i.px,i.email,i.acctn,i.ae,
i.state,i.added,i.cid,i.ok+0,i.id,z.zip
FROM inqemails i
LEFT JOIN contactrecords c ON (i.cid = c.id OR i.email = c.email)
LEFT JOIN zips z ON i.id = z.eid 
WHERE i.id = ?
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($id);
my (@ary) = $sth->fetchrow_array();
print header(-type=>'text/plain'), join "|" ,@ary;
exit;
