# remind.pl
# July 2008
use strict;
use CGI qw|:standard|;
my $cid = param("id");
my $dbh = WebDB::conn('cnts');
my $sql = '';
my $rmd;

my $sth = $dbh->prepare("select reminder from contactrecords where id = ?");
$sth->execute($cid);
($rmd) = $sth->fetchrow_array();

my $new_rmd = 1 - $rmd;
 
if ($new_rmd == 1) {
    $sql=<<EOF;
UPDATE contactrecords 
SET callback = IF(DAYOFWEEK(CURDATE()) = 6,DATE_ADD(CURDATE(),INTERVAL 3 DAY),DATE_ADD(CURDATE(),INTERVAL 1 DAY)),reminder = '1' 
WHERE id = ?
EOF
}
else {
    $sql=<<EOF;
UPDATE contactrecords 
SET callback = DATE_ADD(CURDATE(),INTERVAL 1 MONTH),reminder = reminder = '0' 
WHERE id = ?
EOF
}

$sth = $dbh->prepare($sql) ;
my $ok += $sth->execute($cid);
print header(-type=>'text/plain'),$ok;
warn ($DBI::errstr) if $DBI::err;
$dbh->disconnect;
exit(0);
