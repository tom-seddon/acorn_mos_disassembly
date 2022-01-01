import collections

Buffer=collections.namedtuple('Buffer','name addr size')

def main():
    msbs=[0x03,0x0a,0x08,0x07,0x07,0x07,0x07,0x07,0x09,]
    lsbs=[0x00,0x00,0xc0,0xc0,0x50,0x60,0x70,0x80,0x00,]
    idxs=[0xe0,0x00,0x40,0xc0,0xf0,0xF0,0xF0,0xF0,0xC0,]
    names=['Keyboard','RS423Input','RS423Output','Printer','SoundChannel0','SoundChannel1','SoundChannel2','SoundChannel3','8']

    buffers=[]

    print()
    
    for i in range(9):
        offset0=idxs[i]
        buffers.append(Buffer(name=names[i],
                              addr=(msbs[i]<<8|lsbs[i])+offset0,
                              size=256-offset0))

    for buffer in buffers:
        print('buffer%sAddress=$%04x'%(buffer.name,buffer.addr))
        print('buffer%sSize=%d'%(buffer.name,buffer.size))

    print('_:=[]')
    for buffer in buffers:
        print('_..=[(buffer%sAddress,buffer%sSize)]'%(buffer.name,buffer.name))

    print()

        
if __name__=='__main__': main()

