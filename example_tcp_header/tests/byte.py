#!/usr/bin/python

f = open('fixtures/tcp_header.byte', 'w')
f.write(b'\x00\x26\xbb\x14\x62\xb7\xcc\x33\x58\x55\x1e\xed\x08\x00\x45\x00\x03\x78\xf7\xac')
f.close()
