# This class defines members of the zookeeper cluster and their properties
class zookeeper::cluster {
  $members = {
    'zookeeper' => [
      'app1v-zookeeper-bd.tp.prd.lax.gnmedia.net',
      'app2v-zookeeper-bd.tp.prd.lax.gnmedia.net',
      'app3v-zookeeper-bd.tp.prd.lax.gnmedia.net',
     ]
  }

  include zookeeper::config
  
}