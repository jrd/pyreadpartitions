#!/bin/env python
# coding: utf-8
# vim:et:sta:sw=2:sts=2:ts=2:tw=0:
from __future__ import division, print_function, absolute_import

from setuptools import setup
import os
import codecs
import re


MODULE_NAME = 'pyreadpartitions'


def read(*paths):
  """Build a file path from *paths* and return the contents."""
  with codecs.EncodedFile(open(os.path.join(*paths), 'rb'), 'utf-8') as f:
    return f.read()


def find_info(info, *file_paths):
  file_paths = list(file_paths)
  file_paths.append('__init__.py')
  info_file = read(*file_paths)
  python_simple_string = r"(?:[^'\"\\]*)"
  python_escapes = r"(?:\\['\"\\])"
  python_string = r"{delim}((?:{simple}{esc}?)*){delim}".format(delim=r"['\"]", simple=python_simple_string, esc=python_escapes)
  info_match = re.search(r"^__{0}__ = {1}".format(info, python_string), info_file, re.M)
  if info_match:
    return info_match.group(1)
  else:
    python_arrays = r"\[(?:{ps})?((?:, {ps})*)\]".format(ps=python_string)
    info_match = re.search(r"^__{0}__ = {1}".format(info, python_arrays), info_file, re.M)
    if info_match:
      matches = [info_match.group(1)]
      if info_match.groups(2):
        matches.extend(re.findall(r", {0}".format(python_string), info_match.group(2)))
      return ', '.join(matches)
  raise RuntimeError("Unable to find {0} string.".format(info))


def find_version(*file_paths):
  return find_info('version', *file_paths)

config = {
  'name': MODULE_NAME,
  'description': 'Read MBR and GPT partitions',
  'long_description': read('README.rst'),
  'license': find_info('license', MODULE_NAME),
  'author': find_info('credits', MODULE_NAME),
  'author_email': find_info('email', MODULE_NAME),
  'version': find_version(MODULE_NAME),
  'url': 'https://github.com/jrd/pyreadpartitions/',
  'download_url': 'https://github.com/jrd/pyreadpartitions/archive/master.zip',
  'packages': [MODULE_NAME],
  'classifiers': [  # https://pypi.python.org/pypi?%3Aaction=list_classifiers
    'Development Status :: 5 - Production/Stable',
    'Intended Audience :: Developers',
    'Natural Language :: English',
    'License :: OSI Approved :: MIT License',
    'Operating System :: POSIX',
    'Operating System :: Unix',
    'Operating System :: MacOS :: MacOS X',
    'Programming Language :: Python',
    'Programming Language :: Python :: 2',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.3',
    'Topic :: Software Development :: Libraries :: Python Modules',
    'Topic :: System :: Filesystems',
    'Topic :: Utilities',
  ],
}
setup(**config)
