# getPhnos.pl
# SEPT 2012
use strict;
use CGI qw|:standard :escapeHTML|;
my $id = param('id');

if ($id) {
    print header(-type=>'text/xml'),join ',',make_xml($id);
}
exit(0);

sub make_xml{
 my $id = shift;
 my $dbh = WebDB::conn('cnts');
 my $sth = $dbh->prepare("SELECT person,dept,title,teleno FROM phone_nos WHERE cid = ?");
 $sth->execute($id);
 my $rows = '<tr class="row3"><th colspan="4">Addtional Contacts</th></tr>';
 while (my @ary = $sth->fetchrow_array()) {
    $rows .= "<tr><td width=\"150px\">$ary[0]</td><td width=\"150px\">$ary[1]</td><td width=\"150px\">$ary[2]</td><td width=\"150px\">$ary[3]</td></tr>";

 }
 if (!defined $rows) {
     $rows = "<tr><td colspan=\"4\">None found.</td></tr>";
 }
 return $rows;
}

