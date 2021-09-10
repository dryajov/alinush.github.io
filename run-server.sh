#!/bin/sh

scriptdir=$(cd $(dirname $0); pwd -P)

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "Usage: $0 [port]"
    echo
    echo "Launches the website locally at http://localhost:<port>"
    echo "<port> defaults to 4000"
    exit
fi

# NOTE(Alin): For some reason, jekyll gets confused when overwriting the symlink in _site/drafts/refs.md, so I have to delete it here 

rm -f $scriptdir/_site/drafts/refs.md

bundle exec jekyll serve -P $1
