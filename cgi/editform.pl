#! /usr/bin/perl
# contacts.pl
use strict;
use CGI ':standard';
my ($dbh,$sth,$ref,$sref,$sql);
my $d = `date`;
$d = substr($d,24,4).'-'.substr($d,4,3).'-'.substr($d,8,2);
$dbh = WebDB::conn('cnts');
my $cnt_id = param("id") || 0;
exit unless $cnt_id;
$sql = qq{SELECT DATE_FORMAT(callback,'%m/%d/%y') AS callback,DATE_FORMAT(initialdate,'%m/%d/%y') AS initialdate,contacts,organization,address,phone,email,bloomberg,comment,id,usrid FROM contactrecords WHERE id = ?;};
$sth = $dbh->prepare($sql);
$sth->execute($cnt_id);
$ref = $sth->fetchrow_hashref();
$sql = qq/SELECT * FROM sectypes WHERE crid = ?/;
$sth = $dbh->prepare($sql);
$sth->execute($cnt_id);
$sref = $sth->fetchrow_hashref();
print header(),start_form(-name=>'edit'),
h3('Edit Contact Record'),
table({-id=>"edtbl"},
 Tr(th("Added"),td($ref->{initialdate})),
 Tr(th("Org./Last Name"),td(textfield(-name=>'organization',-size=>'35',-value=>$ref->{organization},-val=>'t'))),
 Tr(th("Address"),td(textfield(-name=>'address',-size=>'35',-value=>$ref->{address}))),
 Tr(th("Contacts"),td(textfield(-name=>'contacts',-size=>'35',-value=>$ref->{contacts},-val=>'t'))),
 Tr(th( "Phone " ),td(textfield(-name=>'phone',-size=>'15',-value=>$ref->{phone},-val=>'p'))),
 Tr(th( "EMail " ),td(textfield(-name=>'email',-size=>'25',-value=>$ref->{email},-val=>'e'))),
 Tr(th( "Add. Info "),td(textfield(-name=>'bloomberg',-size=>'25',-value=>$ref->{bloomberg}))),
 Tr(th( "Munis  "),td(textfield(-name=>'munis',-size=>'40',-value=>$sref->{munis}))),
 Tr(th("Corps  "),td(textfield(-name=>'corps',-size=>'40',-value=>$sref->{corps}))),
 Tr(th("CMOs  "),td(textfield(-name=>'cmos',-size=>'40',-value=>$sref->{cmos}))),
 Tr(th("Other "),td(textfield(-name=>'other',-size=>'40',-value=>$sref->{other})))),
 br(),br(),
 button(-name=>'OK',-class=>'buttons',-value=>'Update',-onClick=>"ckform()"),
 button(-name=>'Cancel',-class=>'buttons',-value=>'Close',-onClick=>"chgMode()"),
 end_form;
exit;
