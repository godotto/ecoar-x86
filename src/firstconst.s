global firstconst

section .text

firstconst:
    ; prologue
    push    ebp
    mov     ebp, esp
    push    esi
    push    ebx
    push    edi

    mov     esi, [ebp + 8]  ; string's argument index
    
    ; state q0 - initial state
    mov     al, BYTE [esi]  ; load the character

    cmp     al, ' '
    je      state_q2        ; if character is space, go to state q2 (separator)

    cmp     al, 59
    je      state_q5        ; if character is a semicolon, it is a comment and go to q5 (final state)

    test    al, al
    jz      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

    cmp     al, 'A'
    jb      invalid_string  ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'Z'
    jna     state_q1        ; if character is upper case letter, go to q1 (token)

    cmp     al, 'a'
    jb      invalid_string  ; if character is below a, it is not a valid first character and automaton is stuck

    cmp     al, 'z' 
    ja      invalid_string  ; if character is lower case letter, go to q1 (token)

state_q1:                   ; state q1 - token
    inc     esi             ; move to the next character
    mov     al, BYTE [esi]  ; load the character

    cmp     al, ':'
    je      state_q1        ; if character is a colon, it is a label and go to q1

    cmp     al, 59
    je      state_q5        ; if character is a semicolon, it is a comment and go to q5 (final state)

    test    al, al
    jz      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

    cmp     al, ' '
    je      state_q2        ; if character is space, go to state q2 (separator)

    cmp     al, ']'
    je      state_q2        ; if character is a right square bracket, go to q2 (separator)

    cmp     al, '+'
    jb      invalid_string

    cmp     al, '-'
    jna     state_q2        ; if character is +, - or a comma go to q2 (separator)

    cmp     al, '0'
    jb      invalid_string  ; if it chatacter is less than any digit, it is invalid character

    cmp     al, '9'
    jna     state_q1        ; if it is a digit, stay at q1

    cmp     al, 'A'
    jb      invalid_string  ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'Z'
    jna     state_q1        ; if character is upper case letter, stay at q1

    cmp     al, 'a'
    jb      invalid_string  ; if character is below a, it is not a valid first character and automaton is stuck

    cmp     al, 'z' 
    jna     state_q1        ; if character is lower case letter, stay at q1
    jmp     invalid_string  ; if it is other character, it is invalid and automaton is stuck
    
state_q2:                            ; state q2 - separator
    inc     esi                      ; move to the next character
    mov     al, BYTE [esi]           ; load the character

    cmp     al, 59
    je      state_q5                 ; if character is a semicolon, it is a comment and go to q5 (final state)

    test    al, al
    jz      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

    cmp     al, ' '
    je      state_q2                 ; if character is space, stay at state q2

    cmp     al, ']'
    je      state_q2                 ; if character is a right square bracket, stay at q2

    cmp     al, '['
    je      state_q2                 ; if character is a left square bracket, stay at q2

    cmp     al, '+'
    jb      invalid_string

    cmp     al, '-'
    jna     state_q2                ; if character is +, - or a comma stay at q2

    cmp     al, '0'
    jb      invalid_string          ; if it chatacter is less than any digit, it is invalid character

    cmp     al, '9'
    jna     state_q3_save_pointer   ; if it is a digit, go to q3 (number)

    cmp     al, 'A'
    jb      invalid_string          ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'Z'
    jna     state_q1                ; if character is upper case letter, go to q1 (token)

    cmp     al, 'a'
    jb      invalid_string          ; if character is below a, it is not a valid first character and automaton is stuck

    cmp     al, 'z' 
    jna     state_q1                ; if character is lower case letter, go to q1 (token)
    jmp     invalid_string

state_q3_save_pointer:      ; state q3 - number
    mov     edx, esi        ; save address of the beginning of the number
    xor     edi, edi        ; clear digit counter

state_q3:
    inc     edi             ; increment digit counter
    inc     esi             ; move to the next character
    mov     al, BYTE [esi]  ; load the character

    cmp     al, 59
    je      state_q6     ; if character is a semicolon, it is a comment and go to q6 (final state with number found)

    test    al, al
    jz      state_q6     ; if character is null terminator, it is the end of string and go to q6 (final state with number found)

    cmp     al, ' '
    je      state_q6     ; if character is space, go to q6 (final state with number found)

    cmp     al, ']'
    je      state_q6     ; if character is a right square bracket, go to q6 (final state with number found)

    cmp     al, '+'
    jb      invalid_string

    cmp     al, '-'
    jna     state_q6     ; if character is +, - or a comma go to q6 (final state with number found)

    cmp     al, 'o'
    je      state_q6

    cmp     al, 'q'
    je      state_q6

    cmp     al, 'h'
    je      state_q6

;     cmp     al, 59
;     je      convert_decimal_number     ; if character is a semicolon, it is a comment and go to q6 (final state with number found)

;     test    al, al
;     jz      convert_decimal_number     ; if character is null terminator, it is the end of string and go to q6 (final state with number found)

;     cmp     al, ' '
;     je      convert_decimal_number     ; if character is space, go to q6 (final state with number found)

;     cmp     al, ']'
;     je      convert_decimal_number     ; if character is a right square bracket, go to q6 (final state with number found)

;     cmp     al, '+'
;     jb      invalid_string

;     cmp     al, '-'
;     jna     convert_decimal_number     ; if character is +, - or a comma go to q6 (final state with number found)

; not_decimal:
;     cmp     al, 'o'
;     je      convert_octal

;     cmp     al, 'q'
;     jne     not_octal

; convert_octal:
;     mov     cl, 3           ; pass the exponent to make proper number of shifts in order to multiply by 8
;     jmp     convert_number  ; if it is octal system, convert number

; not_octal:
;     cmp     al, 'h'
;     jne     not_hex

;     mov     cl, 4           ; pass the exponent to make proper number of shifts in order to multiply by 16
;     jmp     convert_number  ; if it is hexadecimal system, convert number

; not_hex:
    cmp     al, 'b'
    je      state_q4

    cmp     al, 'd'
    je      state_q4

    cmp     al, '0'
    jb      invalid_string          ; if it chatacter is less than any digit, it is invalid character

    cmp     al, '9'
    jna     state_q3                ; if it is a digit, stay at q3

    cmp     al, 'A'
    jb      invalid_string          ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'F'
    jna     state_q3                ; if character is upper case digit, stay at q3

    cmp     al, 'a'
    je      state_q3

    cmp     al, 'c'
    je      state_q3

    cmp     al, 'e'
    je      state_q3

    cmp     al, 'f'
    je      state_q3
    jmp     invalid_string

state_q4:                             ; state q4 - check suffix
    inc     edi                       ; increment digit counter
    inc     esi                       ; move to the next character
    mov     al, BYTE [esi]            ; load the character

    cmp     al, 59
    je      state_q6_restore_prev     ; if character is a semicolon, it is a comment and go to q6 (final state with number found)

    test    al, al
    jz      state_q6_restore_prev     ; if character is null terminator, it is the end of string and go to q6 (final state with number found)

    cmp     al, ' '
    je      state_q6_restore_prev     ; if character is space, go to q6 (final state with number found)

    cmp     al, ']'
    je      state_q6_restore_prev     ; if character is a right square bracket, go to q6 (final state with number found)

    cmp     al, '+'
    jb      invalid_string

    cmp     al, '-'
    jna     state_q6_restore_prev     ; if character is +, - or a comma go to q6 (final state with number found)

    cmp     al, '0'
    jb      invalid_string          ; if it chatacter is less than any digit, it is invalid character

    cmp     al, '9'
    jna     state_q3                ; if it is a digit, stay at q3

    cmp     al, 'A'
    jb      invalid_string          ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'F'
    jna     state_q3                ; if character is upper case digit, stay at q3

    cmp     al, 'a'
    jb      invalid_string          ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'f'
    jna     state_q3                ; if character is upper case digit, stay at q3
    jmp     invalid_string

state_q5:
    mov     eax, 0
    jmp     return

state_q6_restore_prev:
    mov     al, BYTE [esi - 1]
    dec     edi

state_q6:
    cmp     al, 'o'
    je      convert_oct

    cmp     al, 'q'
    jne     not_oct

convert_oct:
    mov     cl, 3           ; pass the exponent to make proper number of shifts in order to multiply by 8
    jmp     convert_number  ; if it is octal system, convert number

not_oct:
    cmp     al, 'h'
    jne     not_hex
    mov     cl, 4           ; pass the exponent to make proper number of shifts in order to multiply by 16
    jmp     convert_number  ; if it is hexadecimal system, convert number

not_hex:
    cmp     al, 'b'
    jne     not_bin
    mov     cl, 1           ; pass the exponent to make proper number of shifts in order to multiply by 2
    jmp     convert_number  ; if it is binary system, convert number

not_bin:
    jmp     convert_decimal_number

invalid_string:
    mov     eax, 1

return:
    ; epilogue
    pop     edi
    pop     ebx
    pop     esi
    leave
    ret

convert_number:
    xor     eax, eax    ; clear accumulator, it will store the converted value
    xor     ebx, ebx    ; clear temporary register

next_digit:
    dec     edi
    shl     eax, cl                 ; multiply accumulator's value by adequate power of 2
    
    cmp     BYTE [edx], '9'
    jg      convert_not_decimal     ; if not decimal digit, check if upper or lower case letter

    sub     eax, 48                 ; substract value of ASCII code for '0' to get the proper value
    jmp     save_result

convert_not_decimal:
    cmp     BYTE [edx], 'F' 
    jg      not_upper_case  ; if not upper case letter, convert lower case letter

    sub     eax, 55         ; substract ASCII code 55 to get the proper value
    jmp     save_result

not_upper_case:
    sub     eax, 87     ; substract ASCII code 87 to get the proper value

save_result:
    mov     bl, BYTE [edx]
    add     eax, ebx
    inc     edx             ; increment buffer index

    test    edi, edi
    jnz     next_digit      ; if character counter is 0, return value

    jmp     return

convert_decimal_number:
    xor     eax, eax    ; clear accumulator, it will store the converted value
    xor     ebx, ebx    ; clear temporary register

next_digit_decimal:
    dec     edi
    imul    eax, 10
    sub     eax, 48             ; substract value of ASCII code for '0' to get the proper value

    mov     bl, BYTE [edx]
    add     eax, ebx
    inc     edx                 ; increment buffer index

    test    edi, edi
    jnz     next_digit_decimal  ; if character counter is 0, return value

    jmp     return