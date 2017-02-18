#!/usr/bin/python3

import os, json, copy, sys, shutil, math
from os.path import abspath, dirname
from jinja2 import Environment, FileSystemLoader

cur_path = dirname(abspath(__file__))
propagate_tests_path = cur_path + "/propagated_tests"
