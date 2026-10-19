#!/bin/bash

read -p "Enter a username to look up: " TARGET_USER
read -p "Enter a department: " DEPARTMENT

echo "Searching for user $TARGET_USER in department $DEPARTMENT"
grep "$TARGET_USER" intel/users.csv | grep "$DEPARTMENT" | awk -F',' '{print "Role: " $2 "\nStatus: " $3}'
