# srcCodes.pl
# Aug 2010 -

use strict;
use CGI qw|:standard|;
my $dbh = WebDB::conn("cnts");
my ($uid,$code,$def,$sql);
$uid = param("uid");

$sql =<<EOF;
 SELECT s.* 
 FROM srcCodes s 
 LEFT JOIN contactrecords c on s.code = c.source 
 WHERE =where=
 GROUP BY s.code
EOF

if ($uid) {
   $sql =~ s/=where=/c.usrid = ?/;
}
else {
   $sql =~ s/=where=/s.code regexp 'x'/;
}

my $sth = $dbh->prepare($sql);
($uid) ? $sth->execute($uid) : $sth->execute();

my $html = '<option value="0">Source</option>';
my $rv = $sth->bind_columns(\$code,\$def);
while ( $sth->fetch) {
   $html .= "<option value=\"$code\">$def</option>";
} 
print header(-type=>'text/html'),$html;
exit;
