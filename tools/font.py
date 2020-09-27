#!/usr/bin/python
import sys,argparse

##########################################################################
##########################################################################

def font(options):
    with open(options.input_path,'rb') as f: data=[ord(x) for x in f.read()]

    for ch in range(32,256):
        line='; CHR$%d'%ch
        if ch>=32 and ch<=126 and ch!=96: line+=' - %s'%chr(ch)
        print line
        
        for row in range(8):
            x=data[0x3900+(ch-32)*8+row]

            line='.byte %'
            for col in range(7,-1,-1): line+=str((x>>col)&1)

            print line

        print

##########################################################################
##########################################################################

def main(argv):
    parser=argparse.ArgumentParser()

    parser.add_argument('input_path',metavar='FILE')

    font(parser.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
