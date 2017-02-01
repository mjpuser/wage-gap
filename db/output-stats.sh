#!/bin/bash

sqlite3 -header -csv census.db < read-stats.sql | python format_csv.py
