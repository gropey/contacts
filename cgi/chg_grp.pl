# chg_grp.pl
# JUNE 2013

use strict;
use CGI qw(:standard escapeHTML);
use WbDB;

if (param()) {
    my $msg = chg_group() ? "Changed" : "Error";
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub chg_group {
    my ($dbh,$sql,$sth);
    my $ok = 0;
    $dbh = WebDB::conn('cnts');
    $sth = $dbh->prepare("UPDATE groups SET grp_name = ? WHERE id = ?");
    $ok += $sth->execute(param('grp_name'),param('gid'));
    return $ok;
}
