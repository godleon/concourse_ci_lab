#!/usr/bin/env python3

import ConfigParser

#if len(sys.argv) == 0:   

config = ConfigParser.RawConfigParser()
config.read(sys.argv[1])