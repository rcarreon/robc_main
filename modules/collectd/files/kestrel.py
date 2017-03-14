#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; only version 2 of the License is applicable.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#
# Authors:
#   Chris Riccomini <criccomini at gmail.com>
#
# About this plugin:
#   This plugin uses collectd's Python plugin to record Kestrel information.
#   Based on https://github.com/powdahound/redis-collectd-plugin
#   Stats information at
#   https://github.com/robey/kestrel/blob/master/docs/guide.md
#
# collectd:
#   http://collectd.org
# Kestrel:
#   https://github.com/robey/kestrel
# collectd-python:
#   http://collectd.org/documentation/manpages/collectd-python.5.shtml

import collectd
import socket

# Host to connect to. Override in config by specifying 'Host'.
KESTREL_HOST = 'localhost'

# Port to connect on. Override in config by specifying 'Port'.
KESTREL_PORT = 6379

# Verbose logging on/off. Override in config by specifying 'Verbose'.
VERBOSE_LOGGING = False

def fetch_info():
  """Connect to Kestrel server and request info"""
  try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((KESTREL_HOST, KESTREL_PORT))
    log_verbose('Connected to Kestrel at %s:%s' % (KESTREL_HOST, KESTREL_PORT))
  except socket.error, e:
    collectd.error('kestrel plugin: Error connecting to %s:%d - %r'
             % (KESTREL_HOST, KESTREL_PORT, e))
    return None
  fp = s.makefile('r')
  log_verbose('Sending info command')
  s.sendall('stats\r\n')

  info_data = []
  while True:
    data = fp.readline().strip()
    if data == 'END':
      log_verbose('Finished STATS call.')
      break
    elif data.startswith('STAT '):
      info_data.append(data)
      
  fp.close()
  s.close()
  return parse_info(info_data)

def parse_info(info_lines):
  """Parse info response from Kestrel"""
  info = {}
  for line in info_lines:
    split_line = line.split(' ')
    if len(split_line) > 2:
      info[split_line[1]] = split_line[2]
    else:
      log_verbose('Skipping malformed line: %s' % line)
  return info

def configure_callback(conf):
  """Receive configuration block"""
  global KESTREL_HOST, KESTREL_PORT, VERBOSE_LOGGING
  for node in conf.children:
    if node.key == 'Host':
      KESTREL_HOST = node.values[0]
    elif node.key == 'Port':
      KESTREL_PORT = int(node.values[0])
    elif node.key == 'Verbose':
      VERBOSE_LOGGING = bool(node.values[0])
    else:
      collectd.warning('kestrel plugin: Unknown config key: %s.'
               % node.key)
  log_verbose('Configured with host=%s, port=%s' % (KESTREL_HOST, KESTREL_PORT))

def dispatch_value(info, key, type, type_instance=None):
  """Read a key from info response data and dispatch a value"""
  if key not in info:
    collectd.warning('kestrel plugin: Info key not found: %s' % key)
    return

  if not type_instance:
    # Key max length is 63 chars. See http://collectd.org/wiki/index.php/Naming_schema
    type_instance = key[:63]

  value = float(info[key])
  log_verbose('Sending value: %s=%s' % (type_instance, value))

  val = collectd.Values(plugin='kestrel')
  val.type = type
  val.type_instance = type_instance
  val.values = [value]
  val.dispatch()

def read_callback():
  log_verbose('Read callback called')
  info = fetch_info()

  if not info:
    collectd.error('kestrel plugin: No info received')
    return

  # send high-level values
  dispatch_value(info, 'curr_items', 'gauge')
  dispatch_value(info, 'total_items', 'counter')
  dispatch_value(info, 'bytes', 'bytes')
  dispatch_value(info, 'reserved_memory_ratio', 'gauge')
  dispatch_value(info, 'curr_connections', 'gauge')
  dispatch_value(info, 'total_connections', 'counter')
  dispatch_value(info, 'cmd_get' , 'counter')
  dispatch_value(info, 'cmd_set', 'counter')
  dispatch_value(info, 'cmd_peek' , 'counter')
  dispatch_value(info, 'get_hits' , 'counter')
  dispatch_value(info, 'get_misses' , 'counter')
  dispatch_value(info, 'bytes_read' , 'counter')
  dispatch_value(info, 'bytes_written' , 'counter')
  dispatch_value(info, 'queue_creates' , 'counter')
  dispatch_value(info, 'queue_deletes' , 'counter')
  dispatch_value(info, 'queue_expires', 'counter')

  sent = []
  
  # queue stats
  for key in info:
    if key.startswith('queue_') and key not in ['queue_deletes', 'queue_creates', 'queue_expires'] and '+' not in key:
      tipe = 'gauge'
      if key.endswith('_children'):
        # count the number of children (fanouts) for this task
        info[key] = len(info[key].split(','))
      elif key.endswith('_items') or key.endswith('_total_items') or key.endswith('_logsize') or key.endswith('_expired_items') or key.endswith('_discarded') or key.endswith('_total_flushes'):
        tipe = 'counter'
      
      max_length_key = key[:63]
      
      if max_length_key not in sent:
        dispatch_value(info, key, tipe)
        sent.append(max_length_key)
      else:
        log_verbose('Skipping duplicate key %s. Likely a key longer than 64 characters.' % key)

def log_verbose(msg):
  if not VERBOSE_LOGGING:
    return
  collectd.info('kestrel plugin [verbose]: %s' % msg)

# register callbacks
collectd.register_config(configure_callback)
collectd.register_read(read_callback, name='kestrel')
