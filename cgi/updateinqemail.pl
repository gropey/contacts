# updateinqemail.pl
# Sept 2010
# rev. 4-9-2012 added email deletion. 
use strict;
use CGI qw(:standard escapeHTML);
use Mail::Sendmail;
if (param()) {
    my $dbh = WebDB::conn('cnts');
    update_cnts($dbh,param('organization'),param('contacts'),param('email'),param('cid')) if param('cid');
    update_inq($dbh);
}
else {
    print header(-type=>'text/plain'),p("Error.");
}
exit;

sub update_cnts{
 my ($dbh,$lname,$fname,$email,$cid) = @_;
 my $sth;
 if ($cid) {
    if (defined(param("del"))) {
        $sth = $dbh->prepare("UPDATE contactrecords SET email = '' WHERE id = ?");
        $sth->execute($cid);
    }
    else {
        $sth = $dbh->prepare("UPDATE contactrecords SET contacts = ?,organization = ?,email = ? WHERE id = ?");
        $sth->execute($fname,$lname,$email,$cid);
    }
 }
}

sub update_inq{
    my ($dbh,$sql,$sth,$fld,$setfld);
    my $id = param("id");
    $dbh = shift;
    my $ok = 0;
    $sql = "SELECT u.usrname,i.ae,i.email FROM inqemails i,users u WHERE i.id = ? AND i.ae = u.repn";
    $sth = $dbh->prepare($sql);
    $ok += $sth->execute($id);
    my ($rname,$ae,$em) = $sth->fetchrow_array();
    if (defined(param("del"))) {
        $sql = "INSERT INTO del_emails SELECT *,curdate() FROM inqemails WHERE inqemails.id = ?";
        $sth = $dbh->prepare($sql);
        $ok += $sth->execute($id);
        $sql = "DELETE FROM inqemails WHERE id = ?";
        $sth = $dbh->prepare($sql);
        $ok += $sth->execute($id);
        $sql = "DELETE FROM group_members WHERE eid = ?";
        $sth = $dbh->prepare($sql);
        $ok += $sth->execute($id);
        # Trigger deletes from zips 
        my %mail = (From=>'admin@rseelaus.com',To=>'rseelaus@rseelaus.com',Subject=>'Deleted client email','Content-type'=>'text/html',body=>"<h2>$rname</h2><p>$em</p>",smtp=>'10.10.10.2');
        sendmail(%mail) || print header('text/plain'),$Mail::Sendmail::error;
    }
    else {
        foreach $fld(param()) {
            if ($fld eq 'taxstatus') {
                $setfld .= "$fld='".param($fld)."',"; 
            } 
            elsif ($fld eq 'rating') {
                $setfld .= "$fld='".param($fld)."',";
            }
            elsif ($fld eq 'px') {
                $setfld .= "$fld='".param($fld)."',";
            }
            elsif($fld eq 'email') {
                my $email_addr = param('email');
                $setfld .= "$fld='".$email_addr."',";
            }
            elsif ($fld eq 'acctn') {
                $setfld .= "$fld='".param($fld)."',";
            }
            elsif ($fld eq 'state') {
                $setfld .= "$fld='".param($fld)."',";
            }
            elsif ($fld eq 'send') {
                $setfld .= "ok=".param($fld).",";
            }
            elsif ($fld eq 'mat') {
                $setfld .= "$fld=".param($fld).","; 
            }
        }
        $sql = qq{UPDATE inqemails SET }.$setfld;
        chop($sql);
        $sql .= " WHERE id = ?";
        $sth = $dbh->prepare($sql);
        $ok += $sth->execute($id);
        if(defined param('zip')) {
            $sth = $dbh->prepare("REPLACE INTO zips VALUES (?,?)");
            $ok += $sth->execute(param('zip'),$id);
        }
    }
    print header(-type=>'text/plain'),"Updated.";
}
