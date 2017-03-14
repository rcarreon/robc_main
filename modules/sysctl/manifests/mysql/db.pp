# $Id$
# $URL$
#

# /modules/sysctl/maniests/mysql/db.pp
class sysctl::mysql::db {
  include sysctl
  conf {
    'net.core.rmem_max': value => '16777216';
    'net.core.wmem_max': value => '16777216';
    'net.core.rmem_default': value => '262144';
    'net.core.wmem_default': value => '262144';
    'kernel.sem': value => '250 32000 32 1024';
    'kernel.msgmni': value => '2048';
    }
}
