import argparse,os,os.path,sys,hashlib

##########################################################################
##########################################################################

def output(path,data):
    hasher=hashlib.sha1()
    hasher.update(data)
    print('%s  %s'%(hasher.hexdigest(),path))

##########################################################################
##########################################################################

def main2(options):
    for path in options.paths:
        apath=os.path.join(options.a,path)
        bpath=os.path.join(options.b,path)
        with open(apath,'rb') as f: adata=f.read()
        with open(bpath,'rb') as f: bdata=f.read()
        if adata!=bdata:
            output(apath,adata)
            output(bpath,bdata)
            if options.must_match: sys.exit(1)

##########################################################################
##########################################################################

def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('-a',metavar='PATH',required=True,help='''use %(metavar)s as path A''')
    p.add_argument('-b',metavar='PATH',required=True,help='''use %(metavar)s as path B''')
    p.add_argument('paths',metavar='FILE',nargs='+',help='''file(s) to check''')
    p.add_argument('--must-match',action='store_true',help='''exit with process exit code 1 if files don't match''')
    
    main2(p.parse_args(argv))

##########################################################################
##########################################################################

if __name__=='__main__': main(sys.argv[1:])
