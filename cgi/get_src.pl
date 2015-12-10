use CGI ":standard";
my $dbh = WebDB::conn("cnts");

my $sql=<<EOF;
select s.* 
from srcCodes s 
join contactrecords c on c.source = s.code 
where c.usrid = ? 
group by c.source
order by s.definition
EOF
my $usrid = param('uid'); 

my $sth = $dbh->prepare($sql);
$sth->execute($usrid);
my $opts = "";
while ( my @ary = $sth->fetchrow_array()) {
    $opts .= "<option value=\"$ary[0]\">$ary[1]</option>";
}

print header('text/plain'),$opts;
exit;
