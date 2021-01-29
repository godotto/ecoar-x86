global firstconst

section .text

firstconst:
    ; prologue
    push    ebp
    mov     ebp, esp
    sub     esp, 20         ; allocate char array which will serve as a buffer, bool variable and 1 byte integer variable
    
    mov     esi, [ebp + 8]  ; pointer on string argument
    xor     eax, eax        ; clear accumulator

    mov     ecx, 11         ; loop counter

clear_loop_beginning:               ; loop which is zeroing buffer array
    mov     [ebp - 19 + ecx], eax
    loop    clear_loop_beginning

    mov     [ebp - 4], eax          ; set isNumber boolean variable to false
    mov     [ebp -20], eax          ; set isFirstDigitDecimal variable to zero

    xor     ecx, ecx                ; set string buffer index to zero

    mov     al, BYTE [esi]          ; load first character from argument

while_loop_beginning:
    test    eax, eax
    jz      end_while_loop          ; if character is '\0', exit the loop
    
    cmp     eax, '0'
    jb      while_loop_next_char    ; if character is less than '0', get next character

    cmp     eax, '9'
    jna     while_loop_char_ok      ; if character is greater than '9', check if it is hex digit

    cmp     eax, 'A'
    jb      while_loop_next_char    ; if character is less than 'A', get next character

    cmp     eax, 'F'
    jna     while_loop_char_ok      ; if character is greater than 'F', check if it is lower case hex digit

    cmp     eax, 'a'
    jb      while_loop_next_char    ; if character is less than 'a', get next character

    cmp     eax, 'f'
    ja      while_loop_next_char    ; if character is greater than 'f', get next character

while_loop_char_ok:
    cmp     BYTE [ebp - 20], 0
    jnz     not_first_digit         ; if isFirstDigitDecimal is not zero, it is not a first digit and process normally next character

    cmp     eax, '9'
    ja      not_decimal
    mov     BYTE [ebp - 20], 1      ; if the first digit is decimal, set isFirstDigitDecimal to 1
    jmp     not_first_digit

not_decimal:
    mov     BYTE [ebp - 20], 2      ; if the first digit is one of letter digit of hexadecimal system, set isFirstDigitDecimal to 2

not_first_digit:
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
    add     esp, 20
    leave
    ret