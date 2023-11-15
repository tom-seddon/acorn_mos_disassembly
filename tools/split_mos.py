#!/usr/bin/python3
import os,os.path,sys,argparse

##########################################################################
##########################################################################

def fatal(msg):
    sys.stderr.write('FATAL: %s\n'%msg)
    sys.exit(1)

##########################################################################
##########################################################################

def main2(options):
    with open(options.input_path,'rb') as f: megarom=f.read()
    expected_size=128*1024
    if len(megarom)!=expected_size:
        fatal('unexpected input length: expected %d, got %d'%(expected_size,
                                                              len(megarom)))

    if not os.path.isdir(options.output_path):
        os.makedirs(options.output_path)

    for i in range(8):
        if i==0: name='mos'
        else: name='%x'%(8+i)

        output_path=os.path.join(options.output_path,
                                 '%s.rom'%name)
        n=16*1024
        with open(output_path,'wb') as f: f.write(megarom[i*n:i*n+n])

##########################################################################
##########################################################################
    
def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('-o','--output',dest='output_path',metavar='FOLDER',help='''write output files to %(metavar)s (will be created if non-existent)''')
    p.add_argument('input_path',metavar='FILE',help='''read MegaROM contents from %(metavar)s''')
    main2(p.parse_args(argv))

##########################################################################
##########################################################################
    
if __name__=='__main__': main(sys.argv[1:])
