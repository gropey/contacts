# toogle_member.pl
# MAY 2013
use strict;
use CGI qw(:standard escapeHTML);

if (param()) {
    my $msg = toogle_member();
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub toogle_member {
    my ($dbh,$sth,$html);
    my $ok = 0;
    $dbh = WebDB::conn('cnts');
    if (param('gid') > 0) {
        $sth = $dbh->prepare("REPLACE INTO group_members SET group_id = ?,eid = ?");
        $ok += $sth->execute(param('gid'),param('eid'));
    }
    else {
        $sth = $dbh->prepare("DELETE FROM group_members WHERE eid = ?");
        $ok += $sth->execute(param('eid'));
    }
    return $ok;
}
