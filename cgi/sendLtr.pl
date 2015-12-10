# sendLtr.pl
# Nov 2009
use strict;
use CGI qw|:standard :escapeHTML|;
use Mail::Sendmail;

my $rep = param("rep")||0;
my $cid = param("cid");
if($rep && $cid){
 my $uname=get_usr();
 sendout($cid,$uname); 
}else{
 exit(1);
}
exit(0);
sub get_usr{
 my $dbh=WebDB::conn("cnts");
 my $sth=$dbh->prepare(qq{SELECT usrname FROM users WHERE repn='$rep'});
 $sth->execute();
 return ($sth->fetchrow_array());
}
sub sendout{
 my $id=shift;
 my $un=shift;
 my $dbh=WebDB::conn("cnts");
 my $sth=$dbh->prepare(qq{SELECT contacts,organization,address FROM contactrecords WHERE id=$cid});
 $sth->execute();
 while((my @ary)=$sth->fetchrow_array()){
   my %mail=(To=>'hvogel@rseelaus.com',From=>$un.'@rseelaus.com',Subject=>'Send Letter',Message=>$ary[0].' '.$ary[1]."\n".$ary[2],Smtp=>'10.10.10.2');
  sendmail(%mail) or die $Mail::Sendmail::error;
 }
warn ($DBI::errstr) if $DBI::err;
$sth->finish();
$dbh->disconnect;
}
