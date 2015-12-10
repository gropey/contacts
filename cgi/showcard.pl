# showcard.pl
# June 2008
use strict;
use CGI qw|:standard|;
my $id = param("id");
my $dbh = WebDB::conn("cnts");

my $sql=<<EOF;
SELECT TIME_FORMAT(c.timeto,'%H:%i') AS timeto,reminder,DATE_FORMAT(c.initialdate,'%m/%d/%y') AS added,
DATE_FORMAT(c.callback,'%m/%d/%y') AS callback,c.contacts,c.organization,c.address,
IF(d.cid AND clients.cid IS NULL,concat(LEFT(c.phone,length(c.phone)-3),'DNC'),c.phone) AS phone,c.email,c.bloomberg,
c.id,c.comment,c.usrid,s.munis,s.corps,s.cmos,s.agencies,s.other,IFNULL(clients.cid,'*') AS client,
IF(srcCodes.code = 's',CONCAT(e.event_date,' ',e.event),srcCodes.definition) AS source,clients.acctnum 
FROM contactrecords c 
LEFT JOIN sectypes s ON c.id = s.crid 
LEFT JOIN clients ON c.id = clients.cid 
LEFT JOIN srcCodes ON c.source = srcCodes.code 
LEFT JOIN event_contacts ec ON ec.cid = c.id 
LEFT JOIN events e ON e.id = ec.eid 
LEFT JOIN dnc d ON c.id = d.cid 
WHERE c.id = ?;
EOF

my $sth = $dbh->prepare($sql);
$sth->execute($id);
print header(-type=>'text/xml'),WebDB::xml_data($sth);
exit;

