#-e This is a basic VCL configuration file for varnish.  See the vcl(7)
#man page for details on VCL syntax and semantics.
#
#Default backend definition.  Set this to point to your content
#server.
#
backend fe {
  .host = "10.2.10.180";
  .port = "80";
}
backend publishers {
  .host = "10.2.10.181";
  .port = "80";
}
backend stats_cms {
  .host = "10.2.10.182";
  .port = "80";
}
backend stats_fe {
  .host = "10.2.10.183";
  .port = "80";
}
backend upl {
  .host = "10.2.10.184";
  .port = "80";
}
backend bld {
  .host = "10.2.10.185";
  .port = "80";
}
backend media {
  .host = "10.2.10.186";
  .port = "80";
}
#
#Below is a commented-out copy of the default VCL logic.  If you
#redefine any of these subroutines, the built-in logic will be
#appended to your code.
#
sub vcl_recv {
    if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        error;
    }

	# By default, use fe unless you match others below
	set req.backend = fe;
	# Regex for spring board platforms
	if (req.http.host ~ "(publishers\.|prod\.cms\.atomiconline\.com|cms\.dvdfile\.com)") {
		set req.backend = publishers;
		pass;		# Don't cache these
	}
	if (req.http.host ~ "(preview\.|sitebuilder\.)") {
		set req.backend = bld;
		pass;		# Don't cache these
	}
	if (req.http.host ~ "((\w+\.)?upload\.)") {
		set req.backend = upl;
	}
	if (req.http.host ~ "(springboard\.gorillanation\.com|media\.cdn\.dvdfile\.com)") {
		set req.backend = media;
	}
	if (req.http.host ~ "(analytics.(\w+\.)?gorillanation.com)") {
		set req.backend = stats_cms;
	}
	if (req.http.host ~ "(analytics.(\w+\.)?atomiconline.com)") {
		set req.backend = stats_fe;
	}

   
    if (req.request != "GET" && req.request != "HEAD") {
        /* We only deal with GET and HEAD by default */
        pass;
    }
        if (req.url ~ "\.(css|gif|ico|jpg|js|png|swf|tiff?)$") {
		unset req.http.cookie;
		lookup;
	}
    if (req.http.Authorization) {
        /* Not cacheable by default */
        return (pass);
    }
    lookup;
}
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
sub vcl_hash {
    set req.hash += req.url;
    if (req.http.host) {
        set req.hash += req.http.host;
    } else {
        set req.hash += server.ip;
    }
    return (hash);
}

sub vcl_hit {
    if (!obj.cacheable) {
        return (pass);
    }
    deliver;
}
#
#sub vcl_miss {
#    return (fetch);
#}
#
sub vcl_fetch {
	# By default, we cache all static content
        if (req.url ~ "\.(css|gif|ico|jpg|js|png|swf|tiff?)$") {
                set obj.ttl = 10m;
		unset obj.http.set-cookie;

		# See http://varnish.projects.linpro.no/wiki/VCLExampleLongerCaching
		/* Remove Expires from backend, it's not long enough */
		unset obj.http.expires;

		/* Set the client's TTL on this object */
		set obj.http.cache-control = "max-age = 600";

		/* Don't use Pragma */
		unset obj.http.pragma;
        }
    if (!obj.cacheable) {
        return (pass);
    }
    if (obj.http.Set-Cookie) {
        return (pass);
    }
#    set obj.prefetch =  -30s;
	deliver;
}

sub vcl_deliver {
	# See http://varnish.projects.linpro.no/wiki/VCLExampleHitMissHeader
        if (obj.hits > 0) {
                set resp.http.X-Cache = "HIT";
        } else {
                set resp.http.X-Cache = "MISS";
        }
}
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
#    <address>
#       <a href="http://www.varnish-cache.org/">Varnish</a>
#    </address>
#  </body>
#</html>
#"};
#    return (deliver);
#}


