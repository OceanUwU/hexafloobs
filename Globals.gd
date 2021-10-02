extends Node

const HEX_CHARS = '0123456789ABCDEF'

func convert_to_hex(num):
    return HEX_CHARS[floor(num / 16)] + HEX_CHARS[num % 16]
