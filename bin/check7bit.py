#!/usr/bin/python3
import os,os.path,sys,argparse,fnmatch

def main2(options):
    if len(options.search_paths)>0: search_paths=options.search_paths
    else: search_paths=['.']

    found_paths=set()
    for search_path in search_paths:
        for dirpath,dirnames,filenames in os.walk(search_path):
            for filename in filenames:
                matched=False
                for pattern in options.patterns:
                    if fnmatch.fnmatch(filename,pattern):
                        matched=True
                        break

                if matched:
                    p=os.path.normpath(os.path.join(dirpath,filename))
                    found_paths.add(p)

    for found_path in found_paths:
        with open(found_path,'rb') as f: data=f.read()
        n=1
        i=0
        s=0
        bad=False

        def eol(possible_other):
            nonlocal n,i,s,bad
            
            e=i
            i+=1
            if i<len(data) and data[i]==possible_other: i+=1

            if bad:
                raw_line=data[s:e]
                printable_line=''
                for c in raw_line:
                    if c<32 or c>=128: printable_line+='\\x%02X'%c
                    else: printable_line+=chr(c)
                print('%s:%d: %s'%(found_path,n,printable_line))

            bad=False
            n+=1
            s=i
        
        while i<len(data):
            if data[i]==13: eol(10)
            elif data[i]==10: eol(13)
            elif data[i]>128:
                bad=True
                i+=1
            else: i+=1
                
def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('patterns',metavar='PATTERN',nargs='+',help='''check file(s) matching glob pattern %(metavar)s''')
    p.add_argument('-i',dest='search_paths',action='append',metavar='FOLDER',default=[],help='''search %(metavar)s recursively for files. Search cwd if none specified''')
    main2(p.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
