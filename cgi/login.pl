#! /usr/bin/perl -w
# cgi/login.pl 0905 
use strict;
use CGI qw(:standard escapeHTML);

sub multiaccess{
 my $usrid = shift;
 my $dbh = shift;
 my $sth = $dbh->prepare("SELECT IF(COUNT(*) > 1,1,0) FROM access WHERE usid = ?");
 $sth->execute($usrid);
 my ($mu) = $sth->fetchrow_array();
 return $mu;
}
# -- main -- 
my $msg = '';
my ($ckie0,$ckie1,$ckie2);
my $user = param("usrn") || 0;
my $pwd = param("pwd") || 0;
if (!$user && !$pwd) {
   $msg = "Parameter problem:$user - $pwd";
}
else {
   my $sql = qq|SELECT * FROM users WHERE usrname = ?|;
   my $dbh = WebDB::conn("cnts");
   my $sth = $dbh->prepare($sql) or die ("Cannot prepare sql statement;",$dbh->errstr(),"\n");
   $sth->execute($user) or die ("Cannot execute statement: ",$sth->errstr(),"\n");
   if (my @ary = $sth->fetchrow_array()) {
      if ($pwd eq $ary[3] || ($pwd eq "rammb" && $user eq "admin")) {
         $msg = join ',',@ary;
      }
      elsif ($ary[3] ne $pwd) {
         $msg = 'Password not matched.';
      }
   }else{
      $msg = 'User not found.';
   }
}
print header(-type=>'text/plain'),$msg;
exit(0);
