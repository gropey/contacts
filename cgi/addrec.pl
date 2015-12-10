# addrec.pl
# Aug 2012
#
use strict;
use CGI qw|:standard :escapeHTML|;
#use DBI;
print header(-type=>"text/plain"),add_to();
exit(0);

sub dnc_check {
   my ($n,$id,$dbh) = @_;
   my $nv = q{};
   $n =~ s/\W//g;
   my $dnc = WebDB::conn('dnc');
   my $sth = $dnc->prepare("select * from areacode where ac = ?");
   my $nac = substr($n,0,3);
   $sth->execute($nac);
   my $ac = q{}; 
   $sth->bind_columns(\$ac);
   $sth->fetch;
   $sth = $dnc->prepare("select * from dncnums where nmbr = ?");
   $sth->execute($n);
   $sth->bind_columns(\$nv);
   $sth->fetch;
   if ($nv || !$ac) {
      $sth = $dbh->prepare("replace into dnc values (?)");
      $sth->execute($id);
   }
   else {
      $sth = $dbh->prepare("delete from dnc where cid = ?");
      $sth->execute($id);
   }
}

sub add_to {
   my $dbh = WebDB::conn("cnts");
   my %p = map {$_ => param($_)} param();
   $p{callback} = WebDB::my_date( $p{callback} );
   #$p{organization} = uc $p{organization};
   my $sth = $dbh->prepare(qq{INSERT INTO contactrecords VALUES (curdate(),1,'00:00',CURDATE(),?,?,?,?,?,?,NULL,?,?,?)});
   $sth->execute($p{contacts},$p{organization},$p{address},$p{phone},$p{email},'',$p{comment},$p{usrid},$p{source});
   $sth = $dbh->prepare("SELECT MAX(id) FROM contactrecords");
   $sth->execute();
   my ($crid) = $sth->fetchrow_array();
   if ($crid) {
      $sth = $dbh->prepare("INSERT INTO sectypes VALUES (?,?,?,?,?,?)");   
      $sth->execute($p{munis},$p{corps},$p{cmos},$p{agencies},$p{other},$crid);   
      if ($p{email} ne '') {
         my $ae;
         $sth = $dbh->prepare("SELECT repn FROM users WHERE id = ?");
         $sth->execute( $p{usrid} );
         $sth->bind_columns(\$ae);
         $sth->fetch;
         $sth = $dbh->prepare("REPLACE INTO inqemails SET email = ?,ae = ?,acctn = ?, added = CURDATE(),cid = ?,ok = 9"); 
         $sth->execute( $p{email},$ae,$p{acctno},$crid );
      }
      dnc_check($p{phone},$crid,$dbh);
      $dbh->do("insert into clients values ($crid,'$p{acctno}')") if $p{acctno};
   }
   $sth->finish();
   $dbh->disconnect; 
   return $crid;
}
