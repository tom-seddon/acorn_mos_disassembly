#!/usr/bin/python
import os,os.path,sys,argparse

##########################################################################
##########################################################################

def fatal(msg):
    print>>sys.stderr,'FATAL: %s'%msg
    sys.exit(1)

##########################################################################
##########################################################################

def table(options):
    with open('mos.rom','rb') as f: mos=[ord(x) for x in f.read()]

    if options.word:
        size=2
        directive='EQUW'
    else:
        size=1
        directive='EQUB'
        
    if (options.last-options.first+1)%size!=0:
        fatal('length of table must be a multiple of %d'%size)

    for addr in range(options.first,options.last+1,size):
        value=0

        for i in range(size): value|=mos[(addr+i)&0x3fff]<<(i*8)

        line='%s &%0*X'%(directive,size*2,value)

        # line='EQUB &%02X'%value

        while len(line)<17: line+=' '

        line+=':\ %04X='%addr

        for i in range(size): line+=' %02X'%mos[(addr+i)&0x3fff]

        while len(line)<38: line+=' '

        for i in range(size):
            value=mos[(addr+i)&0x3fff]
            if value>=32 and value<=127: line+=chr(value)
            else: line+='.'
        
        print line
    
##########################################################################
##########################################################################

def hex_int(x): return int(x,16)

def main(argv):
    parser=argparse.ArgumentParser()

    parser.add_argument('-w','--word',action='store_true',help='table is table of words')

    parser.add_argument('first',metavar='ADDR',type=hex_int,help='address of first byte')
    parser.add_argument('last',metavar='ADDR',type=hex_int,help='address of last byte')

    table(parser.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
