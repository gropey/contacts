# delPhno.pl
# SEPT 2012
use strict;
use CGI qw|:standard|;
my $id = param('id') || 0;

if ($id) {
    print header(-type=>'text/plain'),del_row($id);
}
else {
    print header(-type=>'text/plain'),"Error in delPhno.pl : $id";
}
exit(0);

sub del_row {
 my $id = shift;
 my $ok = 0;
 my $dbh = WebDB::conn('cnts');
 my $sth = $dbh->prepare("DELETE FROM phone_nos WHERE id = ?");
 return $ok += $sth->execute($id);
}

