#!/bin/sh
cd ../skeleton2
make
./subc < test.c > my_result
cd ../test
./compare_res.py
