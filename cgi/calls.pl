# calls.pl
# June 10 2008 - mrktg version
use strict;
use CGI qw|:standard|;
my $id = param("id");
my $repn = param("repn");
my $dbh = WebDB::conn("cnts");
my $sql=<<EOF;
SELECT DATE_FORMAT(c.lastcontact,'%Y%m%d') AS sortby,DATE_FORMAT(c.lastcontact,'%m/%d/%y') AS lastcontact,c.notes,c.guid,IFNULL(u.usrname,'') AS usrname
FROM calls c 
JOIN users u ON c.repn = u.repn
WHERE c.id = ? AND u.start < c.lastcontact
order by sortby DESC
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($id);
print header(-type=>'text/xml'),WebDB::xml_data($sth);
exit;
