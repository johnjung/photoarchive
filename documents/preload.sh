#!/bin/sh

ls *.out | sort -n |  sed -e s:^:\":g -e s':$:\"\,:'g > docs2preload
