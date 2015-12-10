# del_grp.pl
# MAY 2013

use strict;
use CGI qw(:standard escapeHTML);

if (param()) {
    my $msg = del_group() ? "Deleted" : "Error";
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub del_group {
    my ($dbh,$sql,$sth);
    my $ok = 0;
    $dbh = WebDB::conn('cnts');
# Remove from groups table.
    $sth = $dbh->prepare("DELETE FROM groups WHERE id = ?");
    $ok += $sth->execute(param('gid'));
# Remove from group_ids table.
    $sth = $dbh->prepare("DELETE FROM group_members WHERE group_id = ?");
    $ok += $sth->execute(param('gid'));
    return $ok;
}
