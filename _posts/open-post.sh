#!/bin/bash

scriptdir=$(cd $(dirname $0); pwd -P)
postdir="$scriptdir/"
line=1

is_number()
{
    local re='^[0-9]+$'
    if [[ "$1" =~ $re ]] ; then
        return 1
    else
        return 0
    fi
}

files=`cd $postdir && find . -name "*.md"`

files=`echo "$files" | grep -v "/files/"`
files=`echo "$files" | grep -v "/templ.md"`
files=`echo "$files" | grep -v "/TODO.md"`
files=`echo "$files" | grep -v "/refs.md"`

files=`echo "$files" | cut -c 3-` # cuts the first two characters (i.e., the ./)

files=`echo "$files" | sort`

sorted_files=`echo "$files" | sort -r`

if [ "$1" == "l" -o "$1" == "list" -o "$1" == "-l" ]; then
    titles=`grep '^title:' $sorted_files | cut -f 3 -d':' | sed -e 's/^[[:space:]]*//'`

    # remove quotes from titles of the form "<title>" and just use <title>
    titles=`echo "$titles" | gsed -e 's/^"//'  -e 's/"$//'`

    echo "$titles" | awk '{printf "%d\t%s\n", NR, $0}' | more
else
    line=$1
    if [ -z "$line" ]; then
        line=1
    elif is_number "$line"; then
        echo "ERROR: '$line' is not a number"
        exit 1
    fi
    files=`echo "$files" | tail -n "$line"`
    file=`echo "$files" | head -n 1`

    vim "$postdir/$file"
fi

