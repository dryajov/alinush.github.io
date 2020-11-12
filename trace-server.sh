#!/bin/sh

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "Usage: $0 [port]"
    echo
    echo "Launches the website locally at http://localhost:<port>"
    echo "<port> defaults to 4000"
    exit
fi

bundle exec jekyll serve --trace -P $1
