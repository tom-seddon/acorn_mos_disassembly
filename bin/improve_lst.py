#!/usr/bin/python3
import sys,os,os.path,argparse,re

##########################################################################
##########################################################################

def main2(options):
    with open(options.input_path,'rt') as f:
        lines=[line.rstrip() for line in f.readlines()]

    # Remove uninteresting directive lines.
    boring_re=re.compile(r'''^[0-9]+\s+\.((cerror\s)|(if\s)|else|(elsif\s)|endif).*$''')
    lines=[line for line in lines if boring_re.match(line) is None]

    # Create output.
    output='\n'.join(lines)

    # Remove runs of blank lines.
    nls_re=re.compile(r'''\n(\n+)''')
    output=nls_re.sub('\n\n',output)

    if options.output_path is not None:
        with open(options.output_path,'wt') as f: f.write(output)
    else: sys.stdout.write(output)

##########################################################################
##########################################################################

def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('-o',dest='output_path',metavar='FILE',default=None,help='''write output to %(metavar)s (stdout if not specified)''')
    p.add_argument('input_path',metavar='FILE',help='''read input from %(metavar)s''')
    main2(p.parse_args(argv))

##########################################################################
##########################################################################

if __name__=='__main__': main(sys.argv[1:])
