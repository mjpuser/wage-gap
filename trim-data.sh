#!/bin/bash

# 9 -> Age
# 68 -> Education
# 70 -> Sex
# 73 -> Wage
# 74 -> Hours
# 76 -> Weeks worked past 12 months
rm data/agg-census-data.csv
# echo 'age,education,sex,salary,hours,weeks,occupation10,' > data/agg-census-data.csv
for file in data/raw/ss15pus{a,b,c,d}.csv; do
  tail -n +2 $file \
    | cut -d',' -f '9,68,70,73,74,76,108,109,188' \
    >> data/agg-census-data.csv;
done
