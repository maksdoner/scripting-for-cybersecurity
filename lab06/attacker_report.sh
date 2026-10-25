#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <logfile>" >&2
	exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
	echo "Error: file '$LOGFILE' not found" >&2
	exit 2
fi

FAILED=$(grep -c "Failed password" "$LOGFILE")

TOP_ATTACKER=$(grep "Failed password" "$LOGFILE" |
	awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
	sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
TOP3=$(grep "Failed password" "$LOGFILE" |
	awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
	sort | uniq -c | sort -nr | head -n 3)
TOP_USERS=$(grep "Failed password" "$LOGFILE" |
	awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}' |
	sort | uniq -c | sort -nr | head -n 3)

echo "Failed password events: $FAILED"
echo "Top attacker: $TOP_ATTACKER"

echo "Top 3 attackers: "
echo "$TOP3"

echo "Top 3 targeted usernames: "
echo "$TOP_USERS"

exit 0
