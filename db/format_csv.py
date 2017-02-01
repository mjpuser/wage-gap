import fileinput
import csv

reader = csv.reader(fileinput.input())
for row in reader:
    print('|' + '|'.join(row) + '|')
