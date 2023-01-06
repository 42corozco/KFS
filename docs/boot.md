# Boot:

 A boot loader brings the kernel 

The multiboot section requires:

- magic number
- mode code
- the checksum: 

The field checksum is a 32-bit unsigned value which, when added to the magic fields, must have a 32-bit unsigned sum of zero.
To solve for checksum, 