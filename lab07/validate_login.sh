#!/bin/bash

read -p "Enter a username: " USERNAME

if [ -z "$USERNAME" ]; then
	echo "Error: no username entered" >&2
	exit 1
fi

if grep -q "^$USERNAME," intel/users.csv; then
	SOURCE="CURRENT"

	USER_LINE=$(grep "^$USERNAME," intel/users.csv)
	ROLE=$(echo "$USER_LINE" | cut -d',' -f2)
	STATUS=$(echo "$USER_LINE" | cut -d',' -f3)
elif grep -qx "$USERNAME" case/backups/users.old; then
	SOURCE="LEGACY"
else
	SOURCE="UNKNOWN"
fi

FAILED=$(grep -c "Failed password for $USERNAME " case/logs/auth.log)
ACCEPTED=$(grep -c "Accepted password for $USERNAME " case/logs/auth.log)

echo "Account: $USERNAME"
echo "Source: $SOURCE"

if [ "$SOURCE" = "CURRENT" ]; then
	echo "Role:   $ROLE"
	echo "Status: $STATUS"
fi

echo "Failed logins:    $FAILED"
echo "Accepted logins:  $ACCEPTED"

./risk_level.sh "$FAILED"

if [ "$SOURCE" = "CURRENT" ] && [ "$STATUS" = "disabled" ] && [ "$ACCEPTED" -gt 0 ]; then
	echo "WARNING: disabled account has accepted logins"
fi

if [ "$SOURCE" = "LEGACY" ] || [ "$SOURCE" = "UNKNOWN" ]; then
	if [ "$FAILED" -gt 0 ]; then
		echo "WARNING: attacker targeted a non-current account"
	fi
fi

if [ "$SOURCE" = "CURRENT" ] && [ "$ACCEPTED" -gt 0 ]; then
	if grep -q "^$USERNAME:" case/evidence/passwords.txt; then
		echo "WARNING: account has plaintext credentials and successful logins"
	fi
fi

if [ "$SOURCE" = "CURRENT" ]; then
	exit 0
elif [ "$SOURCE" = "LEGACY" ]; then
	exit 2
else
	exit 3
fi
