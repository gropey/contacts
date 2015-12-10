#  Mar 31, 2008
#  addcall.pl
use strict;
use CGI qw{:standard};
my $dbh = WebDB::conn('cnts');
my $id = param("id") || 0;
my $cdate = WebDB::my_date(param("cdate")) || 0;
my $note = param("note");
my $msg = 1;
my $sth;
if($id > 0){
 if($note =~ /\w+/){
  $note =~ s/(\r|\n)/ /g;
  $sth = $dbh->prepare("UPDATE calls SET lastcontact = ?,notes = ? WHERE guid = ?");
  $msg &&= $sth->execute($cdate,$note,$id);
 }else{
  $sth = $dbh->prepare("DELETE FROM calls WHERE guid = ?");
  $msg &&= $sth->execute($id);
 } 
}
if($msg + 0 eq 0){
 $msg = "Database error.";
}
print header(-type=>"text/plain"),$msg;
exit(0);
