#!/bin/bash

    # let's say you install using "non-root" method.  (Adjust GL_BINDIR for root
    # method or package method).

    # install normally, then make changes directly in $GL_ADMINDIR/conf and
    # $GL_ADMINDIR/keydir.  (Please leaves "logs/" and "hooks/" alone).

    # Then run this:

    export GL_ADMINDIR=/app/shared/gitolite/.gitolite
    export GL_BINDIR=/usr/bin
    export GL_RC=/app/shared/gitolite/.gitolite.rc

    cd $GL_ADMINDIR
    $GL_BINDIR/gl-compile-conf

    # BE SURE TO REMOVE THE ADMIN REPO ITSELF FROM conf/gitolite.conf, as well as
    # repositories/gitolite-admin.git, lest a push by someone end up overwriting
    # this hand- (or machine-) crafted config.

    # you can get away even further from gitolite's control.  You can, for
    # example, set GL_NO_SETUP_AUTHKEYS in the rc file, and manage even the keys
    # yourself.  Just put the full path to $GL_BINDIR/gl-auth-command followed by
    # the username in the "command=" part of the authkeys file you generate.
