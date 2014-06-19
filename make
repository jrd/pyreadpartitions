#!/usr/bin/env python
# coding: utf8
# vim:et:sta:st=2:ts=2:tw=0:
from __future__ import division, unicode_literals, print_function, absolute_import
import sys
import os
import shutil
from glob import glob
import pip
from pip.util import get_installed_distributions as pip_get_installed


MODULE_NAME = 'pyreadpartitions'
os.chdir(os.path.dirname(os.path.abspath(sys.argv[0])))


def usage():
  print("""\
Usage: make ACTION [OPTIONS]
ACTION:
  clean: clean the mess
  build: create a .whl (python wheel) file
  install [global]: install the wheel file, eventually globaly
  info: information about {0}, if installed
OPTIONS:
  --help, -h: this help
  --verbose, -v: be verbose
""".format(MODULE_NAME))


def clean(verbose=False):
  if verbose:
    print("Removing wheelhouse")
  shutil.rmtree('wheelhouse', True)


def pip_run(*args):
  pip.main(list(args))
  pip.logger.consumers = []  # correct an error on multile call to pip.main


def build(verbose=False):
  clean(verbose=verbose)
  args = ['wheel', '.']
  if verbose:
    args.append('-v')
  pip_run(*args)


def install(isLocal, verbose=False):
  build(verbose=verbose)
  wheel_file = glob('wheelhouse/*.whl')[0]
  args = ['install', '--upgrade', '--force-reinstall']
  if isLocal:
    args.append('--user')
  args.append(wheel_file)
  if verbose:
    args.append('-v')
  pip_run(*args)


def info():
  if [d.key for d in pip_get_installed() if d.key == MODULE_NAME]:
    pip_run('show', MODULE_NAME)
  else:
    print("{0} is not installed, try ./make install or ./make install global".format(MODULE_NAME), file=sys.stderr)
    sys.exit(1)

args = sys.argv[1:]
all_options = {'h': 'help', 'v': 'verbose'}
options = {}
n = len(args)
for i in range(0, n):
  j = n - i - 1
  arg = args[j]
  if len(arg) >= 2:
    if arg[0:2] == '--':
      option = arg[2:]
      if option in all_options.values():
        options[option] = True
        del args[j]
      else:
        raise Exception('Option {0} not recognized'.format(arg))
    elif arg[0] == '-':
      option = arg[1:]
      if option in all_options.keys():
        options[all_options[option]] = True
        del args[j]
      else:
        raise Exception('Option {0} not recognized'.format(arg))
if 'help' in options:
  usage()
  sys.exit(0)
if not args:
  args = ['build']
while args:
  arg = args[0]
  args = args[1:]
  if arg == 'help':
    usage()
    sys.exit(0)
  elif arg == 'clean':
    clean(**options)
  elif arg == 'build':
    build(**options)
  elif arg == 'install':
    if args and args[0] == 'global':
      args = args[1:]
      install(isLocal=False, **options)
    else:
      install(isLocal=True, **options)
  elif arg == 'info':
    info(**options)
  else:
    usage()
    sys.exit(1)
