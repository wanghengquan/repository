#!/usr/bin/python  
# -*- coding: utf-8 -*-
import re
import hashlib

__author__ = 'Shawn Yan'
__date__ = '13:51 2018/8/10'

SEPARATE_CODE = "="


def get_hash(f):
    line = f.readline()
    hash_code = hashlib.md5()
    while line:
        hash_code.update(line)
        line = f.readline()
    return hash_code.hexdigest()


def encrypt(s, key=365):
    """ Encrypt a string
    """
    b = bytearray(str(s).encode("gbk"))
    n = len(b)
    c = bytearray(n*2)
    j = 0
    for i in range(0, n):
        key -= 1
        b1 = b[i]
        b2 = b1 ^ key
        c1 = b2 % 16 + 65
        c2 = b2 // 16 + 65
        c[j] = c1
        c[j+1] = c2
        j += 2
    my_code = c.decode("gbk")
    return SEPARATE_CODE.join(my_code)


def decrypt(s, key=365):
    """ Decrypt a string
    """
    s = re.sub(SEPARATE_CODE, "", s)
    c = bytearray(str(s).encode("gbk"))
    n = len(c)
    if n % 2 != 0:
        return ""
    n //= 2
    b = bytearray(n)
    j = 0
    for i in range(0, n):
        key -= 1
        c1 = c[j] - 65
        c2 = c[j+1] - 65
        j += 2
        b2 = c2 * 16 + c1
        b1 = b2 ^ key
        b[i] = b1
    return b.decode("gbk")

if __name__ == "__main__":
    key_list = ("China", "Beijing Shanghai", "Shijiazhuang  ~!^&%#*~&!^(*&#)@~!*( & Tianjin")
    for k in key_list:
        _c = encrypt(k)
        _d = decrypt(_c)
        print(k, _c, _d)
        assert k == _d, "Wrong Encryption!"