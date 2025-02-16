#!/bin/bash
rm -rf test-pipelinec-"$1" lextab.py yacctab.py
#pipelinec --sweep --start 42 --out_dir ./test ./main.c
pipelinec --out_dir ./test-pipelinec-"$1" "$1" #./main.c
