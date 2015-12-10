# inqemail.pl
# Sept 2010 
use strict;
use CGI qw(:standard escapeHTML);

if(param()){
 my $msg = insert_inq() ? "Added" : "Error";
 print header(-type=>'text/plain'),$msg;
}else{
 print header(-type=>'text/plain'),p("Error.");
}
exit;
sub insert_inq{
my ($field,@vals,@cols,$dbh,$sql,$sth);
foreach $field(param()){
 push (@cols,$field);
 push(@vals,"'".param($field)."'"); 
}
my $values=join(",",@vals);
my $fields=join(",",@cols);
$fields .= ",added,id";
$dbh = WebDB::conn('cnts');
$sql = qq{INSERT INTO inqemails ($fields) VALUES ($values,CURDATE(),NULL)};
$sth = $dbh->prepare($sql);
return $sth->execute();
}
