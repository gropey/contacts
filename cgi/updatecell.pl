# Apr 9, 2008
# updatecell.pl
use strict;
use CGI ':standard',':fatalsToBrowser';
my $msg = 1;
my @REQUIRED = qw/field cid rep_code/;
my @missing = check_missing(param());

if(@missing){
 $msg = 'Missing parameters:'.join(', ',@missing);
}else{
 my ($dbh,$sth,$id,$sql);
 $dbh = WebDB::conn('cnts');
 my $fld = param("field");
 my $val = param("value") || '';
 my $cid = param("cid");
 my $rep_code = param("rep_code");
 if($cid > 0){
  if($fld =~ /muni|corp|cmos|agenc|other/){
   $sth = $dbh->prepare("INSERT INTO sectypes SET $fld = ?,crid = ? ON DUPLICATE KEY UPDATE $fld = ?");
   $msg &&= $sth->execute($val,$cid,$val);
  }else{ 
   $msg = edit_record($dbh,$val,$fld,$cid,$rep_code);
  }
 }else{
  $msg = "Parameter error.";
 }
 if($msg + 0 eq 0){
  $msg = "Database error:field:$fld:val:$val:cid:$cid";
 }
 $dbh->disconnect();
}
print header(-type=>'text/plain'),$msg;
exit(0);

sub edit_record{
 my ($dbh,$v,$f,$id,$repcode)  = @_;
 my $ok = 1;
 my ($sth,$eid);
 if($f =~ /organ|contact|address|bloomberg|comment/){
     $sth = $dbh->prepare("UPDATE contactrecords SET $f = ? WHERE id = ?");
     $ok &&= $sth->execute($v,$id);
 }elsif($f =~ /phone/) {
    
     my $new_value = $v; 
     $v =~ s/\W//g;
     my $dnc = WebDB::conn('dnc'); 
     $sth = $dnc->prepare("select * from areacode where ac = ?");
     my $ac = substr($v,0,3);
     $sth->execute($ac);
     my $nac = q{};
     $sth->bind_columns(\$nac);
     $sth->fetch;     
     $sth = $dnc->prepare("select * from dncnums where nmbr = ?");
     $sth->execute($v);
     my $n = q{};
     $sth->bind_columns(\$n);
     $sth->fetch;     
     if ($v ne '' && ($n =~ /\d{10}/ || $nac !~ /\d{3}/)) {
        $sth = $dbh->prepare("replace into dnc values (?)");
        $sth->execute($id);
     }
     else {
        $sth = $dbh->prepare("delete from dnc where cid = ?");
        $sth->execute($id);
     }
     $sth = $dbh->prepare("UPDATE contactrecords SET $f = ? WHERE id = ?");
     $ok &&= $sth->execute($new_value,$id);
 }elsif($f =~ /email/){
     $sth = $dbh->prepare("SELECT IFNULL(e.id,0) FROM contactrecords c,inqemails e WHERE e.email = c.email AND c.id = ?");
     $sth->execute($id);
     $sth->bind_columns(\$eid);
     $sth->fetch;
     $sth = $dbh->prepare("UPDATE contactrecords SET email = ? WHERE id = ?");
     $ok &&= $sth->execute($v,$id);
     if($v eq '' && $eid > 0){
         $sth = $dbh->prepare("INSERT INTO del_emails SELECT *,curdate() FROM inqemails WHERE inqemails.id = ?");
         $ok += $sth->execute($id);
         $sth = $dbh->prepare_cached("DELETE FROM inqemails WHERE id = ?");
         $ok += $sth->execute($eid);
     }
     elsif ($eid > 0) {
         $sth = $dbh->prepare("UPDATE inqemails SET email = ?,ae = ?,cid = ? WHERE id = ?");
         $ok += $sth->execute($v,$repcode,$id,$eid);
     }
     else {
         $sth = $dbh->prepare("REPLACE INTO inqemails SET email = ?,ae = ?,state = 'XX',added = CURDATE(),cid = ?");
         $ok += $sth->execute($v,$repcode,$id);
     } 
 }elsif($f =~ /notes/){
   if($v eq ''){
     $sth = $dbh->prepare_cached("DELETE FROM calls WHERE guid = ?");
     $ok &&= $sth->execute($id);
   }else{
     $sth = $dbh->prepare_cached("UPDATE calls SET notes = ? WHERE guid = ?");
     $ok &&= $sth->execute($v,$id);
   }
 }elsif($f =~ /cdate/){
   if($v eq ''){
    $sth = $dbh->prepare_cached("DELETE FROM calls WHERE guid = ?");
    $ok &&= $sth->execute($id);
   }else{
    $sth = $dbh->prepare_cached("UPDATE calls SET lastcontact = ? WHERE guid = ?");
    $v = WebDB::my_date($v);
    $ok &&= $sth->execute($v,$id);
   }
 }
return $ok;
}

sub check_missing{
 my (%p);
 grep (param($_) ne '' && $p{$_}++,@_);
 return grep (!$p{$_},@REQUIRED);
}
