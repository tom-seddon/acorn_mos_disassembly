#!/usr/bin/python3
import os,os.path,sys,collections,argparse

##########################################################################
##########################################################################

Version=collections.namedtuple('Version','name configure_table_addr eeprom')

Item=collections.namedtuple('Item','metadata_by_version')

Metadata=collections.namedtuple('Metadata','m0 m1')

def pr(x): sys.stdout.write(x)

def main2(options):
    all_versions=[Version('329',0x853c,False),
                  Version('350',0x853c,False),
                  Version('500',0x8787,True),
                  Version('510',0x87c4,True),
                  Version('511',0x87c4,True),
                  Version('CFA3000',0x853c,False),
                  Version('PC128S',0x87cf,True),
                  Version('autocue',0x87c4,True)]

    options.versions=[version.lower() for version in options.versions]
    max_version_width=max([len(version.name) for version in all_versions])
    
    items_by_name={}
    for version in all_versions:
        if (len(options.versions)>0 and
            version.name.lower() not in options.versions):
            continue
        
        assert (version.configure_table_addr>=0x8000 and
                version.configure_table_addr<0xc000)
        with open('orig/%s/utils.rom'%version.name,'rb') as f: rom=f.read()

        def rb(addr):
            assert addr>=0x8000 and addr<0xc000
            return rom[addr&0x3fff]

        def rc(addr): return chr(rb(addr))

        addr=version.configure_table_addr
        while rb(addr)!=0:
            name=''
            while (rb(addr)&0x80)==0:
                name+=rc(addr)
                addr+=1

            m=Metadata(m0=rb(addr+0),m1=rb(addr+1))
            addr+=2

            if name not in items_by_name: items_by_name[name]=Item(metadata_by_version={})

            assert version not in items_by_name[name].metadata_by_version,(version,name)

            items_by_name[name].metadata_by_version[version]=m

    max_name_width=max([len(name) for name in items_by_name.keys()])

    for name in sorted(items_by_name.keys()):
        item=items_by_name[name]

        for version in all_versions:
            m=item.metadata_by_version.get(version)
            if m is None: continue

            pr('%-*s: %-*s: '%(max_name_width,name,
                               max_version_width,version.name))

            if (m.m0&0x40)==0:
                pr(' routine address: $%02x%02x\n'%(m.m0,m.m1))
            else:
                mask=(m.m0>>3)&7
                value=m.m0&7

                n1=(m.m1&0x80)!=0
                index=(m.m1>>3)&0xf
                shift=m.m1&7

                mask=(1<<mask+1)-1
                if version.eeprom: index+=5
                else: index+=1

                pr(' index=$%x'%index)
                pr(' mask=$%02x'%mask)
                pr(' shift=%d'%shift)
                pr(' value=%d'%value)
                pr(' n1=%s'%str(n1).lower())
                pr('\n')

                # pr('mask=$%02x value=%d n1=%s index=$%x shift=%d\n'%
                #    (mask,value,n1,index,shift))
        

def main(argv):
    p=argparse.ArgumentParser()
    p.add_argument('versions',metavar='VERSION',nargs='*',default=[],help='''version(s) to display, or none for all''')
    main2(p.parse_args(argv))
    
if __name__=='__main__': main(sys.argv[1:])
