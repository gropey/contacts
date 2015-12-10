# inqemailgrps.pl
# MAY 2013 
use strict;
use CGI qw(:standard escapeHTML);
print header(-type=>'text/plain'),list_inq(param('gid'),param('ae'));
exit;

sub list_inq{
my $g = shift;
my $ae = shift;
my %taxsts = ("Y","Taxable","N","Tax-Free","A","Any");
my %rating = ("I","Inv Grd","J","High Yld","A","Any");
my %mat = (0,"0-5yrs",1,"5-10yrs",2,"10 + yrs",3,"Any");
my %px = ("disc","Discount","par","Par","prem","Prem","any","Any");
my $dbh = WebDB::conn('cnts');
my $sql=<<EOF;
SELECT i.*,s.definition,ifnull(gm.group_id,0),c.organization,c.contacts
FROM inqemails i
JOIN sendstatus s ON s.code = i.ok
LEFT JOIN contactrecords c ON c.id = i.cid
LEFT JOIN group_members gm ON i.id = gm.eid AND gm.group_id =? 
WHERE i.ae = ? 
ORDER BY i.email
EOF

my$sth = $dbh->prepare($sql);
$sth->execute($g,$ae);
my $html=<<EOF;
<table width="85%" id="inqem">
<col width="100" /><col width="100" />
<col width="200" /><col width="80" /><col width="80" /><col width="80" />
<col width="55px" /><col width="40px" /><col width="100px" /><col width="40px" />
<tr style="font-size:10pt;" align="right">
<th>Contacts</th><th>LastName/Co.</th><th>Email</th><th>TaxStatus</th><th>Rating</th><th>Mat</th><th>Px</th><th>State</th><th>Send</th><th>Group</th></tr>
=rows=
</table>
EOF
my $rows = "";
 while (my @ary = $sth->fetchrow_array()) {
    $rows .= qq{<tr><td>$ary[14]</td><td>$ary[15]</td><td>$ary[4]</td><td>$taxsts{$ary[0]}</td><td>$rating{$ary[1]}</td><td>$mat{$ary[2]}</td><td>$px{$ary[3]}</td><td>$ary[7]</td><td>$ary[12]</td><td><input type="checkbox" name="group_id" gid="$ary[13]" id="$ary[11]" /></td></tr>};
 }
$html =~ s/=rows=/$rows/;
return $html;
}

