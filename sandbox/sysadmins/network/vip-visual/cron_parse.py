#!/usr/bin/python
# -*- coding: utf-8 -*-

#http://stackoverflow.com/questions/1754841/log-pysvn-update
import time
from datetime import datetime, timedelta
import pysvn
import os
from Model_Buff import *
import sys
from lockfile import FileLock, LockError

Session = sessionmaker(bind=db)()

def svn_diff(d_path, wk_path):
    default_path = d_path
    os.chdir(default_path)
    work_path = default_path + wk_path

    client = pysvn.Client()

    entry = client.info(work_path)
    old_rev = entry.revision.number

    revs = client.update(work_path)
    new_rev = revs[-1].number
    print 'updated from %s to %s.\n' % (old_rev, new_rev)

    head = pysvn.Revision(pysvn.opt_revision_kind.number, old_rev)
    end = pysvn.Revision(pysvn.opt_revision_kind.number, new_rev)

    log_messages = client.log(work_path, revision_start=head, revision_end=end,
            limit=0)
    for log in log_messages:
        timestamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(log.date))
        print '[%s]\t%s\t%s\n  %s\n' % (log.revision.number, timestamp,
                log.author, log.message)
    print

    FILE_CHANGE_INFO = {
            pysvn.diff_summarize_kind.normal: ' ',
            pysvn.diff_summarize_kind.modified: 'M',
            pysvn.diff_summarize_kind.delete: 'D',
            pysvn.diff_summarize_kind.added: 'A',
            }

    print 'file changed:'
    summary = client.diff_summarize(work_path, head, work_path, end)
    print 'summary', len(summary)
    for info in summary:
        path = info.path
        if info.node_kind == pysvn.node_kind.dir:
            path += '/'
        file_changed = FILE_CHANGE_INFO[info.summarize_kind]
        prop_changed = ' '
        if info.prop_changed:
            prop_changed = 'M'
        print file_changed + prop_changed, path
    print
    return summary, new_rev

def parse(d_path, rv1, rv2):
    os.system(d_path + '/config_parse.sh')
    os.system(d_path + '/fwsm_parse.py')
    #os.system(d_path + '/ip_no_device.py')
    os.system(d_path + '/sql_parse.py')
    os.system(d_path + '/pxy_parse.py')
    revision = Revision()
    revision.source = "configs"
    revision.revision = rv1
    revision.date_inserted = datetime.now()
    Session.add(revision)
    Session.commit()
    os.system(d_path + '/unbuff.sh')

if __name__ == "__main__":
    target_path = "/app/shared/vipvisual"
    sum1, rev1 = svn_diff(target_path,"/configs")
    sum2, rev2 = svn_diff(target_path,"/zones")
    print sum1, rev1
    print sum2, rev2
    if len(sum1) or len(sum2):
        try:
            print "Acquiring lock (/tmp/cron_parse)..."
            lock_f = FileLock('/tmp/cron_parse')
            lock_f.acquire(timeout=0)
        except Exception, err:
            print "Failed."
            sys.exit(str(err))
        try:
            print "Lock acquired..."
            parse(target_path, rev1, rev2)
        finally:
            print "Done. Releasing lock."
        lock_f.release()
