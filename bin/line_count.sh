#!/bin/bash

#inspired by https://gist.github.com/ezamelczyk/78b9c0dd095f8706a3f6a41e8eae0afd

if [ -z "$1" ]; then
# Use current month
set -- "$(date +%b)"
fi

if [ -z "$2" ]; then
# Use current year
set -- "$1" "$(date +%Y)"
fi

echo "$1 $2"
if [ "$1" != "all" ]; then
# Filter by month and year
case $(uname -s) in
Darwin*)
    # previous month as number
    pm=$(date -j -v$1m -v1d -v$2y -v-1m +%m)
    # previous month as name
    pms=$(date -j -v$1m -v1d -v$2y -v-1m +%b)
    # last day of previous month
    ld_pm=$(date -j -v${pms}m -v1d -v$2y -v+1m -v1d +%b)
    # next month as number
    nm=$(date -j -v$1m -v1d -v$2y -v+1m +%m)
    ;;
*)
    # previous month as number
    pm=$(date -d "$1 1, $2 -1 month" +%m)
    # previous month as name
    pms=$(date -d "$1 1, $2 -1 month" +%b)
    # last day of previous month
    ld_pm=$(date -d "$pms 1, $2 +1 month -1 day" +%d)
    # next month as number
    nm=$(date -d "$1 1, $2 +1 month" +%m)
    ;;
esac
after_year=$2
before_year=$2
if [ $pm -eq 12 ]; then
# Decrement after year if previous month is December
((after_year--))
    fi
    if [ $nm -eq 01 ]; then
# Increment before year if next month is January
((before_year++))
    fi
    filter="--after="$after_year-$pm-$ld_pm" --before="$before_year-$nm-01""
    msg="for $1 $2"
    else
# Get all logs
    filter=""
    msg="as of $($datecmd "+%b %Y")"
    fi

    echo "" ; echo "Generating contribution log $msg ..." ; echo ""

    git log --shortstat $filter | grep -E "(Author: )(\b\s*([a-zA-Z]\w+)){1,2}|fil(e|es) changed" | awk '
{
    if($1 ~ /Author/) {
        author = $2" "$3
    }
    else {
        files[author]+=$1
            inserted[author]+=$4
            deleted[author]+=$6
            delta[author]+=$4-$6
    }
}
END { for (key in files) { print "Author: " key "\n\tfiles changed: ", files[key], "\n\tlines inserted: ", inserted[key], "\n\tlines deleted: ", deleted[key], "\n\tlines delta: ", delta[key] } }
'