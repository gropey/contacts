# getminicard.pl
# April 2012
use strict;
use CGI qw|:standard :escapeHTML|;
my $cid = param("cid");
my $msg = 1;
if ($cid) {
    $msg = make_xml($cid); 
}
else {
    $msg = "Error:id paramenter: $cid";
}
if ($msg =~ /xml/) {
    print header(-type=>'text/xml'),$msg;
}
else {
    print header(-type=>'text/plain'),$msg;
}
exit(0);

sub make_xml{
 my $id = shift;
 my $dbh = WebDB::conn("cnts");
 my ($sql,$sth);
 $sql = "SELECT concat(c.contacts,' ',c.organization),c.address,c.phone FROM contactrecords c WHERE c.id = ?";
 $sth=$dbh->prepare($sql);
 my $ok = $sth->execute($id);
 my $table = '<table id="minicard">=rows=</table>';
 my $rows;
 if($ok + 0 > 0){
   my @html = map { "<tr><td>$_</td></tr>"} $sth->fetchrow_array();
   $rows = join ('',@html);
 }else{
   $rows = '<tr><td colspan="4">No contact record.</td></tr>';
 }
 $table =~ s/=rows=/$rows/;
 return $table;
}
