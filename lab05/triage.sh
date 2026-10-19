#!/bin/bash

CASE_DIR="case"
REPORT="triage-report-auto.txt"

read -p "Enter analyst name: " ANALYST
read -p "Enter case reference: " CASE_REF

PYTHON_FILES=$(find "$CASE_DIR" -type f -name "*.py" | wc -l)
SHELL_SCRIPTS=$(find "$CASE_DIR" -type f -name "*.sh" | wc -l)
LOG_FILES=$(find "$CASE_DIR" -type f -name "*.log" | wc -l)
CONFIG_FILES=$(find "$CASE_DIR" -type f -name "*.conf" | wc -l)

SCRIPTS=$((PYTHON_FILES + SHELL_SCRIPTS))

echo "File Triage Report" > "$REPORT"
echo "Analyst: $ANALYST" >> "$REPORT"
echo "Case Reference: $CASE_REF" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"

echo "Total Files: $(find "$CASE_DIR" -type f | wc -l)" >> "$REPORT"
echo "Total Directories: $(find "$CASE_DIR" -type d | wc -l)" >> "$REPORT"
echo "Python Files: $PYTHON_FILES" >> "$REPORT"
echo "Shell Scripts: $SHELL_SCRIPTS" >> "$REPORT"
echo "Log Files: $LOG_FILES" >> "$REPORT"
echo "Configuration Files: $CONFIG_FILES" >> "$REPORT"
echo "Empty Files: $(find "$CASE_DIR" -type f -size 0 | wc -l)" >> "$REPORT"
echo "Archives: $(find "$CASE_DIR" -type f -name "*.zip" | wc -l)" >> "$REPORT"
echo "" >> "$REPORT"

echo 'Files Containing "admin":' >> "$REPORT"
grep -rl "admin" "$CASE_DIR" >> "$REPORT"
echo "" >> "$REPORT"

echo "Detected File Types in Evidence:" >> "$REPORT"
file "$CASE_DIR"/evidence/* >> "$REPORT"
echo "" >> "$REPORT"

echo "Scripts (Python + shell): $SCRIPTS" >> "$REPORT"

echo "Report created: $REPORT"
