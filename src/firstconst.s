global firstconst

section .text

firstconst:
    ; prologue
    push    ebp
    mov     ebp, esp
    sub     esp, 16         ; allocate char array which will serve as a buffer, bool variable and 1 byte integer variable
    push    esi             ; save esi on stack as it will be used in function
    
    mov     esi, [ebp + 8]  ; pointer on string argument
    xor     eax, eax        ; clear accumulator
    xor     edx, edx        ; clear register for previous character

    mov     ecx, 11         ; loop counter

clear_loop_beginning:               ; loop which is zeroing buffer array
    mov     [ebp - 19 + ecx], eax
    loop    clear_loop_beginning

    mov     [ebp - 4], eax          ; set isNumber boolean variable to false
    xor     ecx, ecx                ; set string buffer index to zero

    mov     al, BYTE [esi]          ; load first character from argument

while_loop_beginning:
    test    eax, eax
    jz      end_while_loop          ; if character is '\0', exit the loop
    
    cmp     eax, '0'
    jb      while_loop_next_char    ; if character is less than '0', get next character

    cmp     eax, '9'
    jna     while_loop_char_ok      ; if character is greater than '9', check if it is hex digit

    cmp     BYTE [ebp - 4], 0       
    je      while_loop_next_char    ; if character is not a decimal digit and number has not been encountered, get next character

    cmp     eax, 'A'
    jb      while_loop_next_char    ; if character is less than 'A', get next character

    cmp     eax, 'F'
    jna     while_loop_char_ok      ; if character is greater than 'F', check if it is lower case hex digit

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
    mov     edx, eax                ; store previous character
    inc     esi
    mov     al, BYTE [esi]          ; load next character from string argument
    
    cmp     BYTE [ebp - 4], 1
    jne     while_loop_beginning    ; if number was already read, exit the loop

end_while_loop:
    cmp     edx, 'h'
    jne     not_hex             ; if suffix is not 'h', it is not a hexadecimal value

    ; convert hexadecimal
    lea     eax, [ebp - 19]     ; load the address of string buffer
    push    eax                 ; pass the address of buffer to convert_number subroutine
    push    4                   ; pass exponent of 2's power to convert_number subroutine
    call    convert_number
    add     esp, 8              ; pop arguments from the stack
    jmp     return

not_hex:
    cmp     edx, 'q'
    je      convert_oct
    cmp     edx, 'o'
    jne     not_oct             ; if suffix is not 'o' nor 'q', it is not an octal value

convert_oct:
    ; convert octal
    lea     eax, [ebp - 19]     ; load the address of string buffer
    push    eax                 ; pass the address of buffer to convert_number subroutine
    push    3                   ; pass exponent of 2's power to convert_number subroutine
    call    convert_number
    add     esp, 8              ; pop arguments from the stack
    jmp     return

not_oct:
    cmp     edx, 'b'            ; if suffix is not 'b', it is not a binary value
    jne     not_bin

    ;convert binary
    lea     eax, [ebp - 19]     ; load the address of string buffer
    push    eax                 ; pass the address of buffer to convert_number subroutine
    push    1                   ; pass exponent of 2's power to convert_number subroutine
    ; call    convert_number
    add     esp, 8              ; pop arguments from the stack
    jmp     return     

not_bin:
    ;convert decimal
    lea     eax, [ebp - 19]     ; load the address of string buffer
    push    eax                 ; pass the address of buffer to convert_number_decimal subroutine
    ; call    convert_decimal_number
    add     esp, 4              ; pop arguments from the stack
    jmp     return

return:
    ; epilogue
    pop     esi
    pop     edx
    add     esp, 20
    leave
    ret

convert_number:
    ; prologue
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 12]     ; set index on the beginning of buffer array

    xor     eax, eax            ; clear accumulator, it will store the converted value
    xor     edx, edx
    mov     cl, BYTE [ebp + 8]  ; load cl with exponent - only cl can be used for that purpose

next_digit:
    shl     eax, cl         ; multiply accumulator's value by adequate power of 2
    
    cmp     BYTE [esi], '9'
    jg      not_decimal     ; if not decimal digit, check if upper or lower case letter

    sub     eax, 48         ; substract value of ASCII code for '0' to get the proper value
    jmp     save_result

not_decimal:
    cmp     BYTE [esi], 'F' 
    jg      not_upper_case  ; if not upper case letter, convert lower case letter

    sub     eax, 55         ; substract ASCII code 55 to get the proper value
    jmp     save_result

not_upper_case:
    sub     eax, 87     ; substract ASCII code 87 to get the proper value

save_result:
    mov     dl, BYTE [esi]
    ; add     al, BYTE [esi] ; add digit's ASCII code to accumulator
    add     eax, edx
    inc     esi             ; increment buffer index

    cmp     BYTE [esi], 0
    jne     next_digit      ; if character is '\0', finish subroutine

    ; epilogue
    pop     esi
    leave
    ret