include iscsi
iscsi::multipath{'svnrepomp':
    mp_wwid =>'deadbeefdeadbeefdeadbeefdeadbeef',
    mp_alias=>'deadbeefrepos',
}
