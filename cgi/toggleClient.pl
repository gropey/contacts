# toggleClient.pl
# Aug. 2012
use strict;
use CGI qw|:standard|;
my $cid = param("cid");
my $acctnum = param("acctnum");
my $ok = 0;
if ( !$cid ) { 
    print header(-type=>'text/plain'),"Parameter error: cid = $cid"; 
}
else {
   my $sql = qq{};
   my $dbh = WebDB::conn('cnts');
   $sql = "SELECT * FROM clients WHERE cid = ?";
   my $sth = $dbh->prepare($sql) ;
   $ok += $sth->execute($cid);
   if ( $ok ) {
       $sql = "DELETE FROM clients WHERE cid = ?";
   }
   else {
       $sql = "INSERT INTO clients VALUES (?,?)";
   }
   
   $sth = $dbh->prepare($sql) ;
   $ok += ($ok) ? $sth->execute($cid) : $sth->execute($cid,$acctnum);
   $sth = $dbh->prepare("update inqemails set acctn = ? where cid = ?");
   $ok += $sth->execute($acctnum,$cid);
   print header(-type=>'text/plain'), $ok;
   $dbh->disconnect;
}
exit(0);
