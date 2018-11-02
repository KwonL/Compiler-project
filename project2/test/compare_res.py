#!/usr/bin/python3
import difflib
from pprint import pprint

my_res = open("../skeleton2/my_result", "r")
org_res = open("../skeleton2/test_result", "r")

for idx, my_content in enumerate(my_res):
    org_content = org_res.readline()
    if my_content != org_content :
        print("diff: line No." + str(idx) + "\n\t"  + my_content + "\t" + org_content)

