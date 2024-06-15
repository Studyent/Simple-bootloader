;Réalisé avec NASM


[bits 16] ; Précise le Mode réel 16 bits
[org 0x7c00] ; démarre à l'addresse 0x7c00 après que la valeur 0xaa55 soit trouvé dans les 2 derniers
; bits du bootloader 

global _start

section .text

_start:

    xor ax,ax
    mov ds,ax
    mov es,ax
    mov si,msg
    mov bx,ax
    mov bx,0
    call FOR 
    jmp $ ; pas de code d'initialisation indésirable
    

FOR:
    cmp bx,10
    je ENDFOR
    mov si,msg
    call print
    add bx,1
    jmp FOR

ENDFOR:

    ret


print:
    mov al,[si] ; copie
    cmp al,0
    je done
    mov ah,0x0e
    int 0x10
    inc si
    jmp print

done:
    ret ; boucle effectué->boucle sur la meme addresse


    msg:
        db "Hello, World !",0; Chaque byte en code ASCII + 0 pour fin de chaine
        times 510-($-$$) db 0 ; remplir de 0 l'espace restant entre l'addresse courante $ et l'addresse de début $$
        dw 0xaa55 ; ajout aux 2 derniers bits la valeur 0xaa55m
