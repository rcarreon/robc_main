divert(-1)
# $Id: sink.mc,v 1.1 2005/09/26 02:49:01 jmates Exp $
#
# Configuration for a sendmail message sink that discard all incoming e-mail.
# Not for production use, nor for any host accessible from the Internet.
#
#MEH - 20081125 - send all mail to a file
# For more information, see: http://sial.org/howto/sendmail/discard/
divert(0)

dnl adjust following for system in question (darwin, linux, openbsd are
dnl common; see the cf/ostype directory for others).
OSTYPE(`linux')

VERSIONID(`$Id: sink.mc,v 1.1 2005/09/26 02:49:01 jmates Exp $')

dnl define(`confLOG_LEVEL', `9')

dnl FEATURE(`access_db')
dnl FEATURE(`blacklist_recipients')
dnl FEATURE(`virtusertable')
dnl FEATURE(`virtuser_entire_domain')
FEATURE(`mailertable')

FEATURE(`nocanonify')
dnl FEATURE(`use_cw_file')

define(`confDELIVERY_MODE', `interactive')
define(`confSAFE_QUEUE', `False')
dnl set DF_BUFFER_SIZE to slightly larger than the average test message size
define(`confDF_BUFFER_SIZE', `110000')
define(`confXF_BUFFER_SIZE', `16384')
define(`confCHECKPOINT_INTERVAL', `0')
define(`confQUEUE_SORT_ORDER', `Filename')
define(`confDEAD_LETTER_DROP', `/dev/null')

define(`confMAX_DAEMON_CHILDREN', `100')
define(`confREFUSE_LA', `25')
define(`confQUEUE_LA', `100')

define(`confFORWARD_PATH', `')
define(`confTO_IDENT', `0')
define(`STATUS_FILE', `')

FEATURE(`accept_unresolvable_domains')

FEATURE(`promiscuous_relay')

dnl define(`LUSER_RELAY', `local:nobody')

dnl define(`confDONT_BLAME_SENDMAIL', `')

MAILER(`smtp')
MAILER(`local')

