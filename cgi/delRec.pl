#! /usr/bin/perl
# delRec.pl
# REV APR 2013
use strict;
use CGI ':standard';
my $msg = 0;
my $id = param('id') || 0;
if ($id > 0) {
    $msg = del_record($id);
}
print header(-type=>'text/plain'),$msg;
exit(0);

sub del_record {
 my $id = shift;
 my $dbh = WebDB::conn('cnts');
 my $ok = 0;
 my $sth = $dbh->prepare("INSERT INTO del_emails SELECT *,curdate() FROM inqemails WHERE cid = ?");
 $ok += $sth->execute($id);
 $sth = $dbh->prepare("UPDATE contactrecords SET usrid = 0 WHERE id = ?");
 $ok += $sth->execute($id);
 $sth = $dbh->prepare("DELETE FROM sectypes WHERE crid = ?");
 $ok += $sth->execute($id);
 $sth = $dbh->prepare("DELETE FROM calls WHERE id = ?");
 $ok += $sth->execute($id);
 $sth = $dbh->prepare("DELETE FROM inqemails WHERE cid = ?");
 $ok += $sth->execute($id);
 return $ok;
}
