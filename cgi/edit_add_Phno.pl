#  SEP2012
#  EDITPHNO.PL
use strict;
use CGI qw{:standard};
my $dbh = WebDB::conn('cnts');
my @REQ = qw/person teleno cid/;
my $msg = 0;
my $sth;

sub check_missing{
    my (%p);
    grep (param($_) ne '' && $p{$_}++, @_);
    return grep (!$p{$_},@REQ);
}

sub error{
    print header(-type=>"text/plain"),"@_";
    exit;
}

my @missing = check_missing(param());

if(@missing) {
    $msg = 'Missing parameters: '.join ',',@missing;
    error($msg);
}
else {
    my %p = map { $_ => param($_) } param();
    $p{id} = 'NULL' if !$p{id}; 
    my @values;
    my @flds;
    my @sets;
    my @place_hldrs;
    foreach (param()) {
        push @values, param($_);
        push @sets, "$_ = ?";
        push @flds, $_;
        push @place_hldrs, '?';
    }
    my $upds = join ',', @sets;
    my $new_flds = join ',', @flds;
    my $new_plc_hldrs = join ',', @place_hldrs;
    my  $sql = "INSERT INTO phone_nos ($new_flds) VALUES ($new_plc_hldrs) ON DUPLICATE KEY UPDATE $upds";
    $sth = $dbh->prepare($sql);
    $msg += $sth->execute(@values,@values);
}
if($msg == 0){
    error("Database error.");
}else{
 $msg = "1";
}
print header(-type=>"text/plain"),$msg;
exit(0);
