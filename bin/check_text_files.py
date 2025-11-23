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

    good=True

    for found_path in found_paths:
        with open(found_path,'rb') as f: data=f.read()

        # must be valid UTF-8.
        try: text=data.decode('utf-8')
        except UnicodeDecodeError as exc:
            sys.stderr.write('%s: %s\n'%(found_path,exc))
            good=False

        # must have consistent line endings.
        expected_eol=None
        i=0
        line_number=1
        while i<len(data):
            if data[i]==13 or data[i]==10:
                j=i+1
                if (i+1<len(data) and
                    (data[i+1]==13 or data[i+1]==10) and
                    data[i+1]!=data[i]):
                    j+=1

                eol=data[i:j]
                if expected_eol is None: expected_eol=eol
                elif eol!=expected_eol:
                    sys.stderr.write('%s:%d: EOL mismatch\n'%(found_path,line_number))
                    good=False
                    break   # no point looking for more...

                line_number+=1
                i=j
            else: i+=1

    if not good: sys.exit(1)
                
def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('patterns',metavar='PATTERN',nargs='+',help='''check file(s) matching glob pattern %(metavar)s''')
    p.add_argument('-i',dest='search_paths',action='append',metavar='FOLDER',default=[],help='''search %(metavar)s recursively for files. Search cwd if none specified''')
    main2(p.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
