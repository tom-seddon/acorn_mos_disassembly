#!/usr/bin/python3
import os,os.path,sys,argparse,contextlib,html,collections

##########################################################################
##########################################################################

g_verbose=False

def pv(msg):
    if g_verbose: sys.stderr.write(msg)
    
##########################################################################
##########################################################################

ListFields=collections.namedtuple('ListFields','num off pc hex mon src')

class Line: pass

def main3(fout,options):
    with open(options.input_path,'rt') as f:
        lst_lines=[line.rstrip().expandtabs(8) for line in f.readlines()]

    pv('%s: %d lines\n'%(options.input_path,len(lst_lines)))

    lst_idx=0

    def consume_blank_lines():
        nonlocal lst_idx
        while lst_lines[lst_idx]=='': lst_idx+=1

    consume_blank_lines()
    
    _64tass_header=[]
    while lst_lines[lst_idx]!='':
        _64tass_header.append(lst_lines[lst_idx])
        lst_idx+=1

    consume_blank_lines()

    def fatal(msg):
        sys.stderr.write('%s:%d: %s\n'%(options.input_path,lst_idx+1,msg))
        sys.exit(1)

    try:
        fields=ListFields(num=lst_lines[lst_idx].index(';Line'),
                          off=lst_lines[lst_idx].index(';Offset'),
                          pc=lst_lines[lst_idx].index(';PC'),
                          hex=lst_lines[lst_idx].index(';Hex'),
                          mon=lst_lines[lst_idx].index(';Monitor'),
                          src=lst_lines[lst_idx].index(';Source'))
    except ValueError: fatal('unexpected columns indicator format: %s'%lst_lines[lst_idx])
    pv('Fields: %s\n'%(fields,))

    consume_blank_lines()

    prefix_return=';******  Return to file: '
    prefix_processing=';******  Processing file: '
    prefix_processing_input=';******  Processing input file: '

    for idx,l in enumerate(lst_lines[lst_idx:]):
        if l==';******  End of listing': break

        assert '\t' not in l

        i=fields.num
        num=''
        while i<len(l) and l[i]!=' ': num+=l[i]; i+=1
        assert i<fields.off,(1+lst_idx+idx)

        i=fields.off
        off=''
        while i<len(l) and l[i]!=' ': off+=l[i]; i+=1
        assert i<fields.pc,(1+lst_idx+idx)

        # if addr.startswith(prefix_return): continue
        # if addr.startswith(prefix_processing): continue
        # if addr.startswith(prefix_processing_input): continue
        
        # assert i<fields.pc,(1+lst_idx+idx)
        

    def tag1(s,**kwargs):
        fout.write('<%s'%s)
        if len(kwargs)!=0:
            for k,v in kwargs.items():
                fout.write(' %s="%s"'%(k,html.escape(v)))
        fout.write('>')

    @contextlib.contextmanager
    def tag(s,**kwargs):
        tag1(s,**kwargs)
        try: yield None
        finally: fout.write('</%s>'%s)

    def text(s): fout.write(html.escape(s))

    fout.write('<!DOCTYPE html>\n')
    with tag('html'):
        with tag('head'):
            with tag('title'):
                text(os.path.basename(options.input_path))
        with tag('body'):
            pass

##########################################################################
##########################################################################

def main2(options):
    global g_verbose;g_verbose=options.verbose

    if options.output is None: main3(sys.stdout,options)
    else:
        with open(options.output,'wt') as f: main3(f,options)

##########################################################################
##########################################################################

def main(argv):
    p=argparse.ArgumentParser()

    p.add_argument('-v','--verbose',action='store_true',help='''be more verbose (prints to stderr)''')
    p.add_argument('-o','--output',default=None,metavar='FILE',help='''output to %(metavar)s, or stdout if not specified''')
    p.add_argument('input_path',metavar='FILE',help='''read 64tass .lst input from %(metavar)s''')

    main2(p.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
