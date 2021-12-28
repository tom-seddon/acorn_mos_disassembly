import collections

def main():
    order=['mem','mask','ora','eor']

    w=5

    line0=''
    for x in order:
        if len(line0)>0: line0+=' '
        line0+='%*s'%(w,x)

    print(line0)
        
    for value in range(16):
        a=value>>3&1
        b=value>>2&1
        c=value>>1&1
        d=value>>0&1

        xs={}
        xs[order[0]]=value>>3&1
        xs[order[1]]=value>>2&1
        xs[order[2]]=value>>1&1
        xs[order[3]]=value>>0&1
        
        a=xs['mask']
        a&=xs['ora']
        a|=xs['mem']
        temp=a
        a=xs['eor']
        a&=xs['mask']
        a^=temp

        print('%*d %*d %*d %*d  %d'%(w,xs[order[0]],
                                     w,xs[order[1]],
                                     w,xs[order[2]],
                                     w,xs[order[3]],
                                     a))

if __name__=='__main__': main()
