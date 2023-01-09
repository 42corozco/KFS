section .text
global main:

main:

	mov eax, 0xb8000
	mov DWORD [eax], 0x0e320e34
