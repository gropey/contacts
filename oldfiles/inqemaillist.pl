# inqemaillist.pl
# Dec 2010 
use strict;
use CGI qw(:standard escapeHTML);

print header(-type=>'text/plain'),list_inq(param('ae'));
exit;

sub list_inq {
my $r = shift;
my %taxsts = ("Y","Taxable","N","Tax-Free","A","Any");
my %rating = ("I","Inv Grd","J","High Yld","A","Any");
my %mat = (0,"0-5yrs",1,"5-10yrs",2,"10 + yrs",3,"Any");
my %px = ("disc","Discount","par","Par","prem","Prem","any","Any");
my $dbh = WebDB::conn('cnts');
my $sql=<<EOF;
SELECT e.*,s.definition,concat(c.contacts," ",c.organization) AS contact 
FROM inqemails e 
JOIN contactrecords c ON (e.email = c.email OR e.cid = c.id)
JOIN sendstatus s ON e.ok = s.code
WHERE e.ae = ? 
ORDER BY e.email
LIMIT 250
EOF

my $sth = $dbh->prepare($sql);
my $rows = '';
$sth->execute($r);
my $html=<<END;
<table id="inqem">
<col width="200" /><col width="80" /><col width="80" /><col width="80" />
<col width="55px" /><col width="40px" /><col width="100px" /><col width="180px" />
<col width="100px" />
<tr style="font-size:10pt;" align="right">
<th>Email</th><th>TaxStatus</th><th>Rating</th><th>Mat</th><th>Px</th><th>State</th><th>Status</th><th>Name</th>
</tr>
=rows=</table>
END

 while (my @ary = $sth->fetchrow_array()) {
     $rows .= qq|<tr onclick="editEmail(this)" id="$ary[11]" cid="$ary[9]"><td class="emails">$ary[4]</td><td>$taxsts{$ary[0]}</td><td>$rating{$ary[1]}</td><td>$mat{$ary[2]}</td><td>$px{$ary[3]}</td><td>$ary[7]</td><td>$ary[12]</td><td>$ary[13]</td></tr>|;
 }
$html =~ s/=rows=/$rows/;
return $html;
}

