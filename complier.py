# _*_ coding: utf-8 _*_
from __future__ import print_function

branchindex = {
    'branch':'empty'
}

int_reg = {
    'R1':'10000001',
    'R2':'10000010',
    'R3':'10000100',
    'R4':'10001000',
    'R5':'10010000',
}

instr = {
    'WAIT':'1100',
    'SET':'10',
    'CPY':'0111',
    'JMP':'0100',
    'CALL':'0001',
    'RETURN':'0011'
}
#should input str/int and output str
def hex2dec(a):
    b = int(str(a),16)
    return str(b)

def hex2bin(a):
    return bin(int(hex2dec(a))).lstrip('0b')

def dec2bin(a):
    return bin(int(a)).lstrip('0b')

def display_reg(a,b=8):
    bin_value = int_reg.get(a)
    c=bin_value.zfill(b)
    return c

#etiblish a branchindex dictionary
counter=0
frd=open('./instlist','r')
for line in frd.readlines():
    counter=counter+1
    colon_find=line.find(":")
    if(colon_find!=-1):
        branchindex[line.rstrip(':\n')]=counter
frd.close()
print(branchindex)
#now write the binary file
with open('./rom.bin','w') as f1:
    with open('./instlist','r') as f:
        for line in f.readlines():
            l=line.strip().split()
            print(l)
            if(len(l)==0):
                f1.write("0"*20+'\n')
            elif(l[0]=='SET'):
                f1.write(instr.get(l[0]))
                f1.write(display_reg(l[1]))
                f1.write(str(hex2bin(l[2])).zfill(10)+'\n')
            elif(l[0]=='CPY'):
                f1.write(instr.get(l[0]))
                f1.write(display_reg(l[1]))
                f1.write(display_reg(l[2])+'\n')
            elif(l[0]=='WAIT'):
                f1.write(instr.get(l[0]))
                f1.write(l[1])
                if(l[1]=='1'):
                    f1.write(dec2bin(l[2]).zfill(2))
                    f1.write(display_reg(l[3],13)+'\n')
                elif(l[1]=='0'):
                    f1.write(dec2bin(l[2]).zfill(2))
                    f1.write(hex2bin(l[3]).zfill(13)+'\n')
            elif((l[0]=='JMP')|(l[0]=='CALL')):
                f1.write(instr.get(l[0]))
                f1.write(dec2bin(branchindex.get(l[1])).zfill(16)+'\n')
            elif(l[0]=='RETURN'):
                f1.write(instr.get(l[0]))
                f1.write('0'*16+'\n')
            else:
                f1.write('0'*20+'\n')
f.close()
f1.close()               
