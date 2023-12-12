#!/usr/bin/env python
"""interfaces with linkgrammar"""
import os
import sys
from linkgrammar import *

# change this to the absolute path of the linkgrammar installation
LINKDIR = "/usr/local/lib/liblink-grammar.so"
LINKDIR = "/home/mlynatom/link-grammar-5.12.0/"


class LinkParser:

    def __init__(self, path=None):
        """initialize parser. need to cd into the linkgrammar home dir"""
        if path is None:
            os.chdir(LINKDIR)
        else:
            os.chdir(path)
        self.po = ParseOptions(min_null_count=0, max_null_count=999, max_parse_time=20)
        # self.p = Parser()

    def has_parse(self, s):
        """returns True if a parse was found for a sentence"""
        try:
            length = len(Sentence(s, Dictionary("en"), self.po).parse())
        except:
            length = 0
        return length > 0
