#!/usr/bin/python3
import sys,os,os.path

def main(argv):
    with open(argv[0],'rb') as f: data=f.read()

    def find(s):
        i=data.index(s)
        assert i>=0

        while i>0 and data[i]!=ord('='): i-=1
        assert i>0
        i+=1

        j=i
        while chr(data[j]).isdigit(): j+=1

        return int(data[i:j])

    mosn=find(b'mosUnusedSize')
    terminaln=find(b'terminalUnusedSize')

    print('%s: %d (utils: %d; MOS: %d)'%(os.path.splitext(os.path.basename(argv[0]))[0],
                                         terminaln+mosn,
                                         terminaln,
                                         mosn))

if __name__=='__main__': main(sys.argv[1:])
