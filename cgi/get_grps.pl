# get_grps.pl
# MAY 2013

use strict;
use CGI qw(:standard escapeHTML);

if (param()) {
    my $msg = get_groups();
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub get_groups {
    my ($dbh,$sth,$html);
    my $ok = 0;
    $dbh = WebDB::conn('cnts');
    $sth = $dbh->prepare("SELECT * FROM groups WHERE repcode = ?");
    $ok += $sth->execute(param('ae'));
    $html = "<option value=\"0\">Groups</option>";
    while (my @ary = $sth->fetchrow_array()) {
        $html .= "<option value=\"$ary[2]\">$ary[1]</option>";
    }
    return $html;
}
