#!/usr/bin/python
import sys,os,os.path,argparse,re

##########################################################################
##########################################################################

# Sneak in and fix up the hex prefix at this stage, since it's keeping
# track of string/not string.
def get_stmts(line):
    i=0
    in_str=False
    stmts=[]
    got_stmt=False
    for ch in line:
        if not got_stmt:
            stmts.append('')
            got_stmt=True

        if in_str:
            stmts[-1]+=ch
            if ch=='"': in_str=False
        else:
            if ch==':': got_stmt=False
            else:
                if ch=='"': in_str=True

                # translate non-string chars
                if ch=='&': ch='$'
                
                stmts[-1]+=ch

    return stmts

##########################################################################
##########################################################################

g_64tass_instr_from_beebasm_lc_instr={
    'equs':'.text',
    'equb':'.byte',
    'equw':'.word',
    'equd':'.dword',
    'print':'.warn',
}

def get_64tass_instr(beebasm_instr):
    instr=g_64tass_instr_from_beebasm_lc_instr.get(beebasm_instr.lower())
    if instr is not None: return instr
    else: return beebasm_instr.lower()

g_and_255=' AND 255'
g_div_256=' DIV 256'

def get_64tass_hilo(operand,operator):
    if operand.startswith('#'): i=1
    else: i=0

    return '%s%s%s'%(operand[:i],
                     operator,
                     operand[i:])

def get_64tass_operands(oper):
    if oper.endswith(g_and_255):
        return get_64tass_hilo(oper[:-len(g_and_255)],'<')
    elif oper.endswith(g_div_256):
        return get_64tass_hilo(oper[:-len(g_div_256)],'>')
    else: return oper
    
##########################################################################
##########################################################################

def fixup2(options,fout):
    var_re=re.compile(r'''^\s*[A-Za-z_][A-Za-z0-9_]*\s*=\s*''')
    
    with open(options.input_path,'rt') as f:
        input_lines=[line.rstrip() for line in f.readlines()]

    if options._64tass:
        label_column=0
        stmt_column=16
        comment_column=45
        label_prefix=''
        label_suffix=':'
        comment_char=';'
    else:
        label_column=0
        stmt_column=0
        comment_column=34
        label_prefix='.'
        label_suffix=':'
        comment_char='\\'

    output_lines=[]

    if options._64tass:
        output_lines+=[
            '*=$8000',
        ]
    
    for input_line in input_lines:
        if options._64tass and input_line.endswith('; not 64tass'):
            continue
            
        orig_input_line=input_line
        
        # find any comment
        comment_pos=input_line.find('\\')
        if comment_pos==-1: comment=None
        else:
            comment=input_line[comment_pos+1:]
            input_line=input_line[0:comment_pos]

        stmts=get_stmts(input_line)

        if comment_pos==0:
            output_lines.append('%s%s'%(comment_char,comment))
        elif orig_input_line=='':
            output_lines.append('')
        else:
            for stmt_idx in range(len(stmts)):
                stmt=stmts[stmt_idx].strip()

                if stmt=='': continue

                if stmt.startswith('.'):
                    stmt='%s%s%s'%(label_prefix,
                                   stmt[1:],
                                   label_suffix)
                    column=label_column
                elif var_re.match(stmt):
                    column=0
                else:
                    column=stmt_column
                    
                    if options._64tass:
                        parts=stmt.split(None,1)
                        parts[0]=get_64tass_instr(parts[0])

                        if len(parts)>1:
                            parts[1]=get_64tass_operands(parts[1].strip())

                        stmt=' '.join(parts)

                output_line='%s%s'%(column*' ',stmt)

                if stmt_idx==0 and comment is not None:
                    output_line='%-*s%s%s'%(comment_column,
                                            output_line,
                                            comment_char,
                                            comment)

                output_lines.append(output_line)


    for output_line in output_lines: print>>fout,output_line

##########################################################################
##########################################################################

def fixup(options):
    if options.output_path is None: fixup2(options,None)
    else:
        with open(options.output_path,'wt') as f: fixup2(options,f)

##########################################################################
##########################################################################

def main(argv):
    parser=argparse.ArgumentParser()

    parser.add_argument('--64tass',dest='_64tass',action='store_true',help='do the 64tass conversion step')
    parser.add_argument('input_path',metavar='FILE',help='read from %(metavar)s')
    parser.add_argument('-o',dest='output_path',metavar='FILE',default=None,help='write to %(metavar)s (default=stdout)')

    fixup(parser.parse_args(argv))

if __name__=='__main__': main(sys.argv[1:])
