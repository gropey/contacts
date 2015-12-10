#  Mar 31, 2008
#  addcall.pl
use strict;
use CGI qw{:standard};

my $dbh = WebDB::conn('cnts');
my $id = param("id") || 0;
my $callback = WebDB::my_date(param("callback")) || 0;
my $time = param("t") || 0;
my $note = param("notes");
my $repn = param("repn");
my $msg = 1;
my $sth;
if($id > 0){
 if($note =~ /\w+/){
  $note =~ s/(\r|\n)/ /g;
  $sth = $dbh->prepare("INSERT INTO calls VALUES (?,CURDATE(),?,?,NULL)");
  $msg &&= $sth->execute($repn,$note,$id);
 }
 if($callback != 0){
   $sth = $dbh->prepare("UPDATE contactrecords SET callback = ? WHERE id = ?"); 
   $msg &&= $sth->execute($callback,$id);
 }
 if($time != 0 && $time =~ /\d{1,2}:\d{1,2}/){
    $sth = $dbh->prepare("UPDATE contactrecords SET timeto = ? WHERE id = ?");
    $msg &&= $sth->execute($time,$id);
 }
}else{
 $msg = "Parameter error.";
}
if($msg + 0 eq 0){
 $msg = "Database error.";
}else{
 $msg = "Success";
}
print header(-type=>"text/plain"),$msg;
exit(0);
