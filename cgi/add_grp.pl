# add_grp.pl
# MAY 2013

use strict;
use CGI qw(:standard escapeHTML);

if (param()) {
    my $msg = insert_group() ? "Added" : "Error";
    print header(-type=>'text/plain'),$msg;
}
else {
    print header(-type=>'text/plain'),p("Parameter Error.");
}
exit;

sub insert_group {
    my ($dbh,$sql,$sth);
    my $ok = 0;
    $dbh = WebDB::conn('cnts');
    $sth = $dbh->prepare("INSERT INTO groups VALUES (?,?,NULL)");
    $ok += $sth->execute(param('ae'),param('grp_name'));
    return $ok;
}
