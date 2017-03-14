#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import nested_scopes
import codecs,string,sys
'''
import psyco
psyco.full()
'''
from unicode_csv import *
from time import time

import re 

#
# The simplest, lambda-based implementation
# Source: http://code.activestate.com/recipes/81330-single-pass-multiple-replace/
#

def multiple_replace(dict, text): 

  """ Replace in 'text' all occurences of any key in the given
  dictionary by its corresponding value.  Returns the new tring.""" 
  keys = dict.keys()
  # Reverse 
  keys.sort(lambda a,b:len(b)-len(a))
  # Or
  #sorted(d.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)
  #sorted(keys, key=len, reverse=True)

  # Create a regular expression  from the dictionary keys
  regex = re.compile("(%s)" % "|".join(map(re.escape, keys)))

  # For each match, look-up corresponding value in dictionary
  return regex.sub(lambda mo: dict[mo.string[mo.start():mo.end()]], text) 

#
# You may combine both the dictionnary and search-and-replace
# into a single object using a 'callable' dictionary wrapper
# which can be directly used as a callback object.
# 

# In Python 2.2+ you may extend the 'dictionary' built-in class instead
from UserDict import UserDict 
class Xlator(UserDict):
  count = 0

  """ An all-in-one multiple string substitution class """ 

  def _make_regex(self): 

    """ Build a regular expression object based on the keys of
    the current dictionary """
    t0 = time()
    tmp = re.compile("(%s)" % "|".join(map(re.escape, self.keys()))) 
    t1 = time()
    print 're    %.4f' % (t1-t0)
    return tmp

  def __call__(self, mo): 
    
    """ This handler will be invoked for each regex match """

    # Count substitutions
    self.count += 1 # Look-up string

    return self[mo.string[mo.start():mo.end()]]

  def xlat(self, text): 

    """ Translate text, returns the modified text. """ 

    # Reset substitution counter
    self.count = 0 

    # Process text
    return self._make_regex().sub(self, text)

