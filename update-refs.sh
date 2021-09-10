#!/bin/sh

scriptdir=$(cd $(dirname $0); pwd -P)
incldir=$scriptdir/_includes

rm -f $incldir/refs.md && ck genbib -m $incldir/refs.md
