#!/usr/bin/python
# -*- coding: utf-8 -*-
import shlex, re
from subprocess import *
## yum list installed | grep -v "^[[:space:]]" | sed -r s/"[[:space:]]+.*\$"//
listall = Popen(["yum", "list", "installed"], stdout = PIPE)
packageLines = Popen(["grep", "-v", "^[[:space:]]"], stdin = listall.stdout, stdout = PIPE)
output = packageLines.communicate()[0]

result = output.split("\n")
packs = set()
for line in result:
	pack = re.sub("\s+.*", "", line)
	packs.add(pack)

total = len(packs)
count = 0
for pack in packs.copy():
	print "checking deps of %s" % (pack)
	deplist = Popen(["yum", "deplist", pack], stdout = PIPE) # | sed s/"provider: "// |\
	providers = Popen(["grep", "-o", "provider: .* "], stdin=deplist.stdout, stdout = PIPE)
	output = providers.communicate()[0]
	result = output.split("\n")
	result = set(result)
	for dep in result:
		depname = re.sub("provider: ", "", dep).strip()
		print "found %s, discarding..." % (depname)
		packs.discard(depname)
	count += 1
	print ".... %s packs still in list" % len(packs)
	print "Progress: %s%%" % (count*100.0/total)

print "============================================================"
print packs

#result = output.split("\n")
#print output
#for x in result:
#	print x
print "\n"
