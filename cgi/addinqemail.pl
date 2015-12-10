# addinqemail.pl
# Sept 2010 
use strict;
use CGI qw(:standard escapeHTML);
if (param()) {
    my $msg = insert_inq() ? "Added" : "Error";
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub insert_inq{
   my ($dbh,$sql,$sth,$uid,$id);
   my $rc = 0;
   my $ok = (param('send') eq 0) ? '9' : param('send');
   my $zip = param('zip') if defined param('zip'); 
   my $contact = param('contacts');
   my $organization = param('organization');
   CGI::delete('send');
   CGI::delete('zip');
   $dbh = WebDB::conn('cnts');
   $sth = $dbh->prepare("select id from users where repn = ?");
   $sth->execute(param('ae'));
   $sth->bind_columns(\$uid);
   $sth->fetch;
   $sth = $dbh->prepare("INSERT INTO contactrecords VALUES (CURDATE(),1,'09:00',CURDATE(),?,?,'','',?,'',null,'',?,?)");
   $rc += $sth->execute($contact,$organization,param('email'),$uid,'xx');
   if($rc){
      $sth = $dbh->prepare("SELECT LAST_INSERT_ID()");
      $sth->execute();
      ($id) = $sth->fetchrow_array();
   }
   else {
      return $rc;
   }
   $sth = $dbh->prepare("REPLACE INTO inqemails (email,acctn,ae,state,cid,ok) VALUES (?,?,?,?,?,?)");
   $rc += $sth->execute(param('email'),'00000000',param('ae'),param('state'),$id,$ok);

   if ( $rc > 0 && $zip) {
      $sth = $dbh->prepare("SELECT LAST_INSERT_ID()");
      $sth->execute();
      my (@id) = $sth->fetchrow_array();
      $sth = $dbh->prepare("INSERT INTO zips VALUES (?,?)");
      $sth->execute($zip,$id[0]);
   }
   return $rc;
}
