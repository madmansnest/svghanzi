#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys, json, re

class ZaoZi:
  
  def __init__(self, fontsize=64):
    with open('scales.json') as f:
      self.scales = json.load(f)
    # print(self.scales, file=sys.stderr)
    for k in self.scales:
      self.scales[k] = [self._split_keys(d) for d in self.scales[k]]
    self.opcodes = {
      'LR':u'⿰',
      'UD':u'⿱',
      'LCR':u'⿲',
      'UCD':u'⿳',
      'S':u'⿴',
      'SU':u'⿵',
      'SD':u'⿶',
      'SL':u'⿷',
      'SLU':u'⿸',
      'SRU':u'⿹',
      'SLD':u'⿺',
      'OV':u'⿻',
      'TR':u'△'
    }
  
  def compose(self, verb, args, fontsize="144", fontfamily="sans-serif"):
    if not is_positive_numeric(fontsize):
      raise TypeError('wrong font size')
    # This is an adjustment to move the <g>roup slightly up so that the
    # character fits into SVG borders.
    # It is a magic number, but it works.
    adj = float(fontsize) / 7 / 2
    height = adj * 8 * 2
    output = ["""<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns:svg="http://www.w3.org/2000/svg" 
xmlns="http://www.w3.org/2000/svg" width="{}" height="{}">
<g transform="translate(0, {})" style="font-family: {};">""".format(fontsize, height, adj, fontfamily)]
    scales = self.scales[verb]
    if len(scales)!=len(args):
      raise TypeError('wrong arguments')
    for i, a in enumerate(args):
      # TODO: This solution should be rewritten to account
      # for the third character in a non-kludgy way.
      keys = [a, '*']      
      if i==0:
        keys.insert(0, '*'+args[1])
        keys.insert(0, a+args[1])
      if i==1:
        keys.insert(0, args[0]+'*')
        keys.insert(0, args[0]+a)
      key = [k for k in keys if k in scales[i].keys()][0]
      s = scales[i][key]
      print(u'{}: {}'.format(a, key).encode('utf-8'), file=sys.stderr)
      output.append(u"""<text x="{}em" y="{}em" transform="scale({}, {})" font-size="{}">{}</text>""".format(s[0], s[1], s[2], s[3], fontsize, a))
    output.append('</g></svg>')
    return ''.join(output)

  # Parses the command and returns verb and list of arguments
  def normalize_command(self, cmd):
    if cmd[0] in self.opcodes.values():
      verb, args = cmd[0], cmd[1:]
    else:
      ops = sorted(self.opcodes.keys())
      ops.reverse()
      for o in ops:
        if cmd.find(o)==0:
          verb = self.opcodes[o]
          args = cmd[len(o):]
          break

    def selective_convert(a):
      if a[0]=='':
        return a[1]
      else:
        return unichr(int(a[0], 16))
    args = [selective_convert(a) for a in re.findall(r'\+([1234567890abcdef]+)|(.)', args)]
    
    # As there are no unary operators, unary form is an abbreviated binary or ternary form only.
    # Thus, if a unary form is given, i expand it into appropriate binary or ternary form.
    if len(args)==1:
      args = args * len(self.scales[verb])
    return verb, args
    
  # Returns a copy of the Hash with every key containing several characters
  # replaces with several one-characters keys (while keeping the value).
  def _split_keys(self, d):
    e = {}
    for k in d:
      if k.find(',') > -1:
        for c in k.split(','):
          e[c] = d[k]
      else:
        e[k] = d[k]
    return e

def is_positive_numeric(s):
  try:
    return float(s) > 0
  except ValueError:
    return False
    
def main():
  try:
    fontsize = sys.argv[2]
  except IndexError:
    fontsize = "64"
  try:
    fontfamily = sys.argv[3]
  except IndexError:
    fontfamily = "sans-serif"
  z = ZaoZi()
  verb, args = z.normalize_command(sys.argv[1].decode('utf-8'))
  print(z.compose(verb, args, fontsize, fontfamily).encode('utf-8'))
  # print(ZaoZi().scales, file=sys.stderr)

if __name__ == '__main__':
  main()