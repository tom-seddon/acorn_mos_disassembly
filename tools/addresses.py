#!/usr/bin/python3
import os,os.path,sys,argparse,collections

Vectors=collections.namedtuple('Vectors','reset irq')
Version=collections.namedtuple('Version','ver star_commands_table_addr')

VERSIONS=[
    Version(ver="320",star_commands_table_addr=0x8368),
    Version(ver="400",star_commands_table_addr=0x8349),
    Version(ver="500",star_commands_table_addr=0x8383),
    Version(ver="510",star_commands_table_addr=0x83c0),
    Version(ver="511",star_commands_table_addr=0x83c0),
    Version(ver="PC128S",star_commands_table_addr=0x83cb),
]

Command=collections.namedtuple('Command','name addr x y')

def main():
    commands={}
    vectors={}
    
    for version in VERSIONS:
        with open('build/%s/all.orig'%version.ver,'rb') as f: data=f.read()

        def byte(i): return data[i&0x7fff]
        def word(i): return byte(i)*256+byte(i+1)

        i=version.star_commands_table_addr
        while byte(i)!=0:
            name=''
            while (byte(i)&0x80)==0:
                name+=chr(byte(i))
                i+=1
            if name not in commands: commands[name]={}
            assert version.ver not in commands[name]
            commands[name][version.ver]=Command(name=name,
                                                addr=word(i+0),
                                                x=byte(i+2),
                                                y=byte(i+3))
            i+=4

        assert version.ver not in vectors
        vectors[version.ver]=Vectors(reset=word(0xfffc),
                                     irq=word(0xfffe))

        
    def header(col1):
        print('|'+'|'.join([col1]+[version.ver for version in VERSIONS]))
        print('|---')

    def row(col1,map,fun):
        line='|'+col1
        for version in VERSIONS:
            if version.ver not in map: line+='| -'
            else: line+='|'+fun(map[version.ver])
        print(line)

    print('* MOS routine addresses')
    print('** Star commands')
    print()
    header('Command')
    for name in sorted(commands.keys(),key=str.lower):
        row(name,commands[name],lambda x:'$%04x'%x.addr)

    print()
    print('** Vectors')
    print()
    header('Vector')
    row('reset',vectors,lambda x:'$%04x'%x.reset)
    row('irq',vectors,lambda x:'$%04x'%x.irq)

if __name__=='__main__': main()
