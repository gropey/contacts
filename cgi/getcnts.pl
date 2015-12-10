# getcnts.pl
# 201409
use strict;
use CGI qw|:standard :escapeHTML|;
use WebDB;

 my %phash = (
  callback=>"c.callback = CURDATE()",
  munis=>"s.munis",
  corps=>"s.corps",
  cmos=>"s.cmos",
  other=>"s.other",
  organization=>"c.organization",
  contacts=>"c.contacts",
  comment=>"c.comment",
  notes=>"n.notes",
  phone=>"c.phone",
  email=>"c.email",
  address=>"c.address",
  source=>"c.source",
  cid=>"clients.cid"
);

my %p = map { $_ => param($_) } param();

my $msg;
my $header_type = "text/xml";
$msg = "Error: Parameters" unless $p{id};
if($msg eq ''){
 my $sql = make_sql(\%p);
 $msg = make_xml(\%p,$sql); 
}
if($msg =~ /Error/){
 $header_type = "text/plain";
}
print header(-type=>$header_type),$msg;
exit(0);

sub make_xml{
 my $hash_ref = shift;
 my $s = shift;
 my $ok = 1;
 my $dbh = WebDB::conn('cnts');
 my $sth = $dbh->prepare($s);
 my $c = $s =~ tr/\?//;

 if ($c == 0) {
     $ok &&= $sth->execute();
 } 
 if ($c == 1) {
     if (($s =~ /organization/ || $s =~ /cid/) && length $hash_ref->{filteron} == 1 ) {
         $hash_ref->{filteron} =~ s/\W//g;
         $ok &&= $sth->execute("^$hash_ref->{filteron}");
     }
     elsif ($s =~ /source/) {
         $ok &&= $sth->execute($hash_ref->{src});
     }
     else {
         $ok &&= $sth->execute($hash_ref->{filteron});
    }
 }
 if ($c == 2){
     $ok &&= $sth->execute("^$hash_ref->{filteron}",$hash_ref->{src});
 }
 if ($ok) {
     return WebDB::xml_data($sth);
 }
 else {
     return "Error: $s"
 }
}

sub make_sql {
 my $prm = shift;
 my ($comment,$join,@where);
 
 my $sql=<<EOF;
 SELECT c.id,LEFT(c.organization,25) AS organization,
 IF(dnc.cid AND clients.cid IS NULL,c.phone,c.phone) AS phone,c.contacts,=comment= AS comment,
 IF(c.timeto != 0,TIME_FORMAT(c.timeto,'%H%i'),'3333') AS stime,
 IF(c.callback=CURDATE(),c.timeto,DATE_FORMAT(c.callback,'%m/%d/%y')) AS callback,
 DATE_FORMAT(c.callback,'%y%m%d') AS sdate,IF(c.reminder = '1' OR c.callback = CURDATE(),'1','0') AS reminder,
 clients.cid,=srcCode= 
 FROM contactrecords c 
 LEFT JOIN clients ON c.id = clients.cid
 =srcJoin=  
 =assignJoin= 
 =clicks=
 LEFT JOIN dnc ON c.id = dnc.cid =join=
 WHERE =where= 
EOF

   push @where, "c.usrid = $prm->{id}";
   if ($prm->{cat} eq 'cid') {
      push @where, "clients.cid IS NOT NULL";
   }
   elsif ($prm->{cat} eq 'reminder') {
      push @where, "c.callback = curdate()";
   }
   elsif ($prm->{cat} eq 'callback') {
      push @where, "$phash{ $prm->{cat} }";
   }
   elsif ($prm->{cat} eq 'assigned') {
      $sql =~ s/=assignJoin=/JOIN (select r.cid,u.usrname from reassigned r join users u on r.usrid = u.id where r.usrid != $prm->{id} group by cid) r on c.id = r.cid /;
      $sql =~ s/=comment=/r.usrname/;
   }
   elsif ($prm->{cat} eq "notes") {
      $sql =~ s/=join=/LEFT JOIN calls n ON n.id = c.id/;
      $sql =~ s/=comment=/n\.notes/;
   }
   elsif ($prm->{cat} =~ /munis|corps|cmos|agencies|other/) {
      $sql =~ s/=join=/LEFT JOIN sectypes s ON c.id = s.crid /;
      $sql =~ s/=comment=/$phash{ $prm->{cat} }/;
   }
   elsif ($prm->{cat} eq 'clicks') {
      $sql =~ s/=clicks=/JOIN clicks ON c.id = clicks.id/;
      $sql =~ s/=comment=/count(clicks.id)/;
   }
   elsif($prm->{cat}) {
      push @where, "$phash{ $prm->{cat} } != ''";
   }  
   if ($prm->{filteron} ){
      if (!$prm->{cat} || $prm->{cat} =~ /assigned|clicks|reminder|cid|callback/) { 
         push @where, "organization REGEXP ?";
      }
      else {
         push @where, "$phash{ $prm->{cat} } REGEXP ?";
      }
   }
   if ($prm->{src}) {
      push @where, "c.source = ?";
      $sql =~ s/=srcJoin=/LEFT JOIN srcCodes ON c.source = srcCodes.code/;
      $sql =~ s/=srcCode=/srcCodes\.definition/;
   }
   my $w = join " AND ",@where;
   $sql .= " GROUP BY c.id " if $prm->{cat} eq 'clicks';
   $sql .= "LIMIT 500";
   $sql =~ s/=comment=/c\.comment/;
   $sql =~ s/=where=/$w/;
   $sql =~ s/,?=\w+=//g;
   $sql =~ s/\n|\r|//g;
   return $sql;
}
