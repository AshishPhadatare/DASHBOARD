import csv
import json

csvfile = open('input.csv', 'r')
jsonfile = open('cmsit.json', 'w')

fieldnames = ("Layer","User","IPAddr","SshConn","MainCodeAvailable","MainCodeUse")
reader = csv.DictReader( csvfile, fieldnames)
out = json.dumps( [ row for row in reader ] )
jsonfile.write(out)