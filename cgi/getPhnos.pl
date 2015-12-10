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
 my $sth = $dbh->prepare("SELECT * FROM phone_nos WHERE cid = ?");
 $sth->execute($id);
 my $table =<<END;
 <table id="phnos">
 <col width="100px" />
 <col width="100px" />
 <col width="100px" />
 <col width="100px" />
 =rows=
 </table>
END
 my $rows = "";
 while (my @ary = $sth->fetchrow_array()) {
    $rows .= "<tr id=\"$ary[5]\"><td>$ary[1]</td><td>$ary[2]</td><td>$ary[3]</td><td>$ary[0]</td></tr>";
 }
 $table =~ s/=rows=/$rows/;
 return $table;
}

