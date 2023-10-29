#!/usr/bin/python3
import os,os.path,sys,argparse,collections

Version=collections.namedtuple('Version','ver addr')

VERSIONS=[
    Version(ver="320",addr=0x8368),
    Version(ver="500",addr=0x8383),
    Version(ver="510",addr=0x83c0),
]

Command=collections.namedtuple('Command','name addr x y')

def main():
    commands={}
    for version in VERSIONS:
        with open('build/%s/all.orig'%version.ver,'rb') as f: data=f.read()
        i=version.addr&0x7fff
        while data[i]!=0:
            name=''
            while (data[i]&0x80)==0:
                name+=chr(data[i])
                i+=1
            if name not in commands: commands[name]={}
            assert version.ver not in commands[name]
            commands[name][version.ver]=Command(name=name,
                                                addr=data[i+0]*256+data[i+1],
                                                x=data[i+2],
                                                y=data[i+3])
            i+=4

    cols=['Command']+[version.ver for version in VERSIONS]
    print('|'+'|'.join(cols))
    print('|---')
    for name in sorted(commands.keys()):
        line='|'+name
        for version in VERSIONS:
            if version.ver not in commands[name]: line+='| -'
            else:
                c=commands[name][version.ver]
                line+='|'
                line+='$%04x $%02x $%02x'%(c.addr,c.x,c.y)
        print(line)

if __name__=='__main__': main()
