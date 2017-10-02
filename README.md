# Questions

## What's `stdint.h`?

A library that contains data types used in bmp.h

## What's the point of using `uint8_t`, `uint32_t`, `int32_t`, and `uint16_t` in a program?

They set the size, in bits, of several data types that will be used in the program

## How many bytes is a `BYTE`, a `DWORD`, a `LONG`, and a `WORD`, respectively?

8, 32, 32, 16

## What (in ASCII, decimal, or hexadecimal) must the first two bytes of any BMP file be? Leading bytes used to identify file formats (with high probability) are generally called "magic numbers."

0x00 0x0D

## What's the difference between `bfSize` and `biSize`?

bfSize is the size of the bitmap file in bytes while biSize is the amount of bytes that the BITMAPINFOHEADER structure needs.

## What does it mean if `biHeight` is negative?

It means that the DIB is top down and that it starts in the top left corner. Also, it can't be compressed

## What field in `BITMAPINFOHEADER` specifies the BMP's color depth (i.e., bits per pixel)?

biBitCount

## Why might `fopen` return `NULL` in lines 24 and 32 of `copy.c`?

fopen will return 'NULL' if the file it's trying to open does not exist

## Why is the third argument to `fread` always `1` in our code?

1 is the number of elements passed to fread

## What value does line 65 of `copy.c` assign to `padding` if `bi.biWidth` is `3`?

3

## What does `fseek` do?

fseek skips ahead a given number of bytes in a given file from a given position in that file. In this code, it skips 'padding'
number of bytes from the current position in 'inptr'

## What is `SEEK_CUR`?

The current position of the pointer in 'infile'

Help from:
https://www.tutorialspoint.com/c_standard_library/c_function_fseek.htm
https://www.tutorialspoint.com/c_standard_library/c_function_fopen.htm
https://www.tutorialspoint.com/c_standard_library/c_function_fread.htm
