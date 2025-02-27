;Lefki Meidi Thomas
;Réalisé avec Nasm
; Timer 16 bits
[bits 16]
[org 0x7c00]

section .data
    seconds db 0
    TIME_1 db 0
    fn_b db 0
section .text

    global _start

_start:
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov cl,0
    mov si,msg
    call FOR     

    jmp $ ; boucle infini sur une addresse après avoir exécuter le code pour éviter d'executer du code indésirable

FOR:
    cmp byte [fn_b],4
    je ENDFOR
    mov si,msg
    call TIMER
    call print
    mov cl,1
    add byte [fn_b],cl
    jmp FOR

ENDFOR:
    ret


print:
    mov al, [si]      
    cmp byte [si], 0  
    je print_done     
    mov ah, 0x0e      
    int 0x10          
    inc si            
    jmp print         

print_done:
    ret               

;;;;;;;;;;;;;;;;;;;;;;
;;                  ;;
;; TIMER ARTIFICIEL ;;
;;                  ;;
;;;;;;;;;;;;;;;;;;;;;;
;TIMER_OUT est une loop dans laquelle il y a une loop imbriquée

TIMER_OUT:
    cmp bx,5
    je fin_out
    inc bx
    jmp TIMER
    jmp TIMER_OUT

fin_out:    
    ret
;INITIALISATION valeur max de 16 bits 65535 

TIMER:
    mov cx,65535

; LOOP EXTERIEUR

TIMER_OUTER_BOUCLE:
    mov dx,65535

;LOOP INTERIEUR
TIMER_INNER_BOUCLE: 
    dec dx
    jnz TIMER_INNER_BOUCLE

    dec cx
    jnz TIMER_OUTER_BOUCLE
    jmp TIMER_OUT



msg:
    db "Hi",10,13, 0

    times 510-($-$$) db 0
    dw 0xaa55
