section .text
global main:

main:

	mov eax, 0xb8000				; /* video memory begins here. */
	mov DWORD [eax], 0x0e320e34		; 0x32 (2)  x034 (4)
									; 0x0e (14) yellow
