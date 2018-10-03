#!/usr/bin/python3
import difflib
from pprint import pprint

my_res = open("./test_res_my.txt", "r")
org_res = open("./test_res.txt", "r")

org_contents = org_res.read()
my_contents = my_res.read()

d = difflib.Differ()

result = list(d.compare(my_contents, org_contents))

pprint(result)