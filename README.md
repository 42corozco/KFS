# Kernel From Scratch pt1

This project is an introduction to kernel development and the first part of a series to develop a functional kernel.

## What we learned

We wrote a little article summarizing what we learned during the development of this project. Click [here](/docs/kfs.md) if you are interested !

## Getting Started

### Prerequisites

To run this project locally, you must have installed:

* binutils
* nasm
* gcc
* grub-common
* make
* xorriso

### Installation

1. Clone this repository

```sh
git clone https://github.com/42corozco/KFS.git
```
2. Build the ISO
```sh
cd KFS
make 
```

3. Run it with qemu
```sh
make run
```

### Cross-Compiler for [École 42][42]
[42]: /docs/Cross-Compiler.md