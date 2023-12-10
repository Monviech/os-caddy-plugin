#!/usr/local/bin/python3

#
# Copyright (c) 2023 Cedrik Pischem
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#


import json
import sys
import re
from collections import deque

def tail(file_path, n):
    """Read last n lines from the file."""
    with open(file_path, 'r', encoding='utf-8') as file:
        return deque(file, n)

def read_log_file(file_path, limit, search_phrase=None, severity=None):
    log_entries = []
    total_count = 0

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            if is_entry_valid(line, search_phrase, severity):
                log_entries.append(parse_log_entry(line))
                total_count += 1

    # Sort the log entries by timestamp in descending order
    log_entries.sort(key=lambda x: x.get('ts', 0), reverse=True)

    # Get the last 'limit' number of log entries
    log_entries = log_entries[:limit]

    # Calculate the total number of lines in the file for accurate total_count
    with open(file_path, 'r', encoding='utf-8') as file:
        for _ in file:
            total_count += 1

    return list(log_entries), total_count

def is_entry_valid(line, search_phrase, severity):
    if search_phrase and search_phrase not in line:
        return False
    if severity:
        severity_match = re.search(r'"level":"(\w+)"', line)
        if severity_match and severity_match.group(1) not in severity:
            return False
    return True

def parse_log_entry(line):
    try:
        return json.loads(line)
    except json.JSONDecodeError:
        return {"error": "Invalid log entry format"}

def main():
    items_per_page = 50  # Default number of items per page
    current_page = 1  # Default current page
    search_phrase = None
    severities = None

    # Handle arguments
    if len(sys.argv) > 1 and sys.argv[1]:
        current_page = int(sys.argv[1])
    if len(sys.argv) > 2 and sys.argv[2]:
        items_per_page = int(sys.argv[2])
    if len(sys.argv) > 3 and sys.argv[3]:
        search_phrase = sys.argv[3]
    if len(sys.argv) > 4 and sys.argv[4]:
        severities = sys.argv[4].split(',')

    log_file_path = '/var/log/caddy/caddy.log'

    log_entries, total_count = read_log_file(
        log_file_path, items_per_page, search_phrase, severities
    )

    # Format response according to Bootgrid requirements
    response = {
        "current": current_page,
        "rowCount": items_per_page,
        "rows": log_entries,
        "total": total_count
    }

    print(json.dumps(response))

if __name__ == "__main__":
    main()
