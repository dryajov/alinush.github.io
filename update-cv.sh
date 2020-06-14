#!/bin/sh

scriptdir=$(cd $(dirname $0); pwd -P)

cd $scriptdir/../cv
make

cp main.pdf $scriptdir/files/cv.pdf 

