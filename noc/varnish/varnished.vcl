#This is a basic VCL configuration file for varnish.  See the vcl(7)
#man page for details on VCL syntax and semantics.
#
#Default backend definition.  Set this to point to your content
#server.
#
backend web1 {
	
  .host = "192.168.12.47";
  .port = "80";
  

}
backend web2 {
  .host = "192.168.12.44";
  .port = "80"; 	
}

backend web3 {
  .host = "200.38.154.166";
  .port = "80"; 	
}

backend webo1 {
  .host = "192.168.12.47";
  .port = "80";
}
backend webo2 {
  .host = "192.168.12.49";
  .port = "80";
}


director director_dftl round-robin {
  { .backend = web1; }
  { .backend = web2; }
}
director dev_mipage round-robin {
  { .backend = webo1; }
  { .backend = webo2; }
}


#sub vcl_recv {
# set req.backend = default_director;
#}

sub vcl_recv {
#     if (req.http.host ~ "ubuntu.hmo.gnmedia.net/mediawiki"{
#	set req.backed = web1;
#	}
    if (req.http.host ~ "wiki.hmo.gnmedia.net") {
        # route wiki.hmo.gnmedia.net  traffic to web1
        set req.backend = director_dftl;
	}
     #else if (req.http.host ~ "ubuntu.hmo.gnmedia.net") {
        # route wiki.hmo.gnmedia.net  traffic to web1
     #   set req.backend = web2;   } 
      else if (req.http.host ~ "dif.hmo.gnmedia.net") {
        # route 200.38.154.166 to web2
        set req.backend = web3;
    } else if (req.http.host ~ "mipage.hmo.gnmedia.net") {
        # route 200.38.154.166 to web2
        set req.backend = dev_mipage;
    }
}



#
#Below is a commented-out copy of the default VCL logic.  If you
#redefine any of these subroutines, the built-in logic will be
#appended to your code.
#
#sub vcl_recv {
#    if (req.request != "GET" &&
#      req.request != "HEAD" &&
#      req.request != "PUT" &&
#      req.request != "POST" &&
#      req.request != "TRACE" &&
#      req.request != "OPTIONS" &&
#      req.request != "DELETE") {
#        /* Non-RFC2616 or CONNECT which is weird. */
#        return (pipe);
#    }
#    if (req.request != "GET" && req.request != "HEAD") {
#        /* We only deal with GET and HEAD by default */
#        return (pass);
#    }
#    if (req.http.Authorization || req.http.Cookie) {
#        /* Not cacheable by default */
#        return (pass);
#    }
#    return (lookup);
#}
#
#sub vcl_pipe {
#    # Note that only the first request to the backend will have
#    # X-Forwarded-For set.  If you use X-Forwarded-For and want to
#    # have it set for all requests, make sure to have:
#    # set req.http.connection = "close";
#    # here.  It is not set by default as it might break some broken web
#    # applications, like IIS with NTLM authentication.
#    return (pipe);
#}
#
#sub vcl_pass {
#    return (pass);
#}
#
#sub vcl_hash {
#    set req.hash += req.url;
#    if (req.http.host) {
#        set req.hash += req.http.host;
#    } else {
#        set req.hash += server.ip;
#    }
#    return (hash);
#}
#
#sub vcl_hit {
#    if (!obj.cacheable) {
#        return (pass);
#    }
#    return (deliver);
#}
#
#sub vcl_miss {
#    return (fetch);
#}
#
#sub vcl_fetch {
#    if (!obj.cacheable) {
#        return (pass);
#    }
#    if (obj.http.Set-Cookie) {
#        return (pass);
#    }
#    set obj.prefetch =  -30s;
#    return (deliver);
#}
#
#sub vcl_deliver {
#    return (deliver);
#}
#
#sub vcl_discard {
#    /* XXX: Do not redefine vcl_discard{}, it is not yet supported */
#    return (discard);
#}
#
#sub vcl_prefetch {
#    /* XXX: Do not redefine vcl_prefetch{}, it is not yet supported */
#    return (fetch);
#}
#
#sub vcl_timeout {
#    /* XXX: Do not redefine vcl_timeout{}, it is not yet supported */
#    return (discard);
#}
#
#sub vcl_error {
#    set obj.http.Content-Type = "text/html; charset=utf-8";
#    synthetic {"
#<?xml version="1.0" encoding="utf-8"?>
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
# "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
#<html>
#  <head>
#    <title>"} obj.status " " obj.response {"</title>
#  </head>
#  <body>
#    <h1>Error "} obj.status " " obj.response {"</h1>
#    <p>"} obj.response {"</p>
#    <h3>Guru Meditation:</h3>
#    <p>XID: "} req.xid {"</p>
#    <hr>
#    <address>
#       <a href="http://www.varnish-cache.org/">Varnish cache server</a>
#    </address>
#  </body>
#</html>
#"};
#    return (deliver);
#}
