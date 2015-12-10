# get_clicks.pl
# 201409
use strict;
use CGI qw|:standard|;
my $id = param("id");
my $dbh = WebDB::conn("cnts");

my $sql=<<EOF;
SELECT * FROM clicks WHERE id = ? ORDER BY clk_date DESC
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($id);
print header(-type=>'text/xml'),WebDB::xml_data($sth);
exit;

