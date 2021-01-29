global firstconst

section .text

firstconst:
    ; prologue
    push    ebp
    mov     ebp, esp
    sub     esp, 16         ; allocate char array which will serve as a buffer and a bool variable
    
    mov     esi, [ebp + 8]  ; pointer on string argument
    xor     eax, eax        ; clear accumulator

    mov     [ebp - 4], eax  ; set boolean variable to false
    xor     ecx, ecx        ; set string buffer index to zero

    mov     al, BYTE [esi]  ; load first character from argument

while_loop_beginning:
    test    eax, eax
    jz      end_while_loop  ; if character is '\0', exit the loop
    
    cmp     eax, '0'
    jb      while_loop_next_char    ; if character is less than '0', get next character

    cmp     eax, '9'
    jna     while_loop_char_ok           ; if character is greater than '9', check if it is hex digit

    cmp     eax, 'A'
    jb      while_loop_next_char    ; if character is less than 'A', get next character

    cmp     eax, 'F'
    jna     while_loop_char_ok           ; if character is greater than 'F', check if it is lower case hex digit

    cmp     eax, 'a'
    jb      while_loop_next_char    ; if character is less than 'a', get next character

    cmp     eax, 'f'
    ja      while_loop_next_char    ; if character is greater than 'f', get next character

while_loop_char_ok:
    mov     [ebp - 19 + ecx], al    ; save digit into buffer
    inc     ecx                     ; decrement buffer's index
    mov     BYTE [ebp - 4], 1       ; set boolean variable to true, as number was encountered

    inc     esi
    mov     al, BYTE [esi]          ; load next character from string argument

    jmp     while_loop_beginning    ; proceed next character

while_loop_next_char:
    inc     esi
    mov     al, BYTE [esi]          ; load next character from string argument
    
    cmp     BYTE [ebp - 4], 1
    jne     while_loop_beginning    ; if number was already read, exit the loop

end_while_loop:
    
return:
    ; epilogue
    add     esp, 16
    leave
    ret