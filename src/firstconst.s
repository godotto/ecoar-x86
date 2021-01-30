global firstconst

section .text

firstconst:
    ; prologue
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 8]  ; string's argument index
    
    ; state q0 - initial state
    mov     al, BYTE [esi]  ; load the character

    cmp     al, ' '
    je      state_q2        ; if character is space, go to state q2 (separator)

    cmp     al, 59
    je      state_q5        ; if character is a semicolon, it is a comment and go to q5 (final state)

    cmp     al, 0
    je      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

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

    cmp     al, 0
    je      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

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
    
state_q2:                   ; state q2 - separator
    inc     esi             ; move to the next character
    mov     al, BYTE [esi]  ; load the character

    cmp     al, 59
    je      state_q5        ; if character is a semicolon, it is a comment and go to q5 (final state)

    cmp     al, 0
    je      state_q5        ; if character is null terminator, it is the end of string and go to q5 (final state)

    cmp     al, ' '
    je      state_q2        ; if character is space, stay at state q2

    cmp     al, ']'
    je      state_q2        ; if character is a right square bracket, stay at q2

    cmp     al, '['
    je      state_q2        ; if character is a left square bracket, stay at q2

    cmp     al, '+'
    jb      invalid_string

    cmp     al, '-'
    jna     state_q2        ; if character is +, - or a comma stay at q2

    cmp     al, '0'
    jb      invalid_string  ; if it chatacter is less than any digit, it is invalid character

    cmp     al, '9'
    jna     state_q3        ; if it is a digit, go to q3 (number)

    cmp     al, 'A'
    jb      invalid_string  ; if character is below A, it is not a valid first character and automaton is stuck

    cmp     al, 'Z'
    jna     state_q1        ; if character is upper case letter, go to q1 (token)

    cmp     al, 'a'
    jb      invalid_string  ; if character is below a, it is not a valid first character and automaton is stuck

    cmp     al, 'z' 
    jna     state_q1        ; if character is lower case letter, go to q1 (token)
    jmp     invalid_string

state_q3:
   
state_q4:
   
state_q5:
   
state_q6:

invalid_string:

; end_while_loop:
;     cmp     BYTE [ebp - 4], 0
;     je      no_number           ; if there was no number in string, return 0
    
;     cmp     edx, 'h'
;     jne     not_hex             ; if suffix is not 'h', it is not a hexadecimal value

;     ; convert hexadecimal
;     lea     eax, [ebp - 19]     ; load the address of string buffer
;     push    eax                 ; pass the address of buffer to convert_number subroutine
;     push    4                   ; pass exponent of 2's power to convert_number subroutine
;     call    convert_number
;     add     esp, 8              ; pop arguments from the stack
;     jmp     return

; not_hex:
;     cmp     edx, 'q'
;     je      convert_oct
;     cmp     edx, 'o'
;     jne     not_oct             ; if suffix is not 'o' nor 'q', it is not an octal value

; convert_oct:
;     ; convert octal
;     lea     eax, [ebp - 19]     ; load the address of string buffer
;     push    eax                 ; pass the address of buffer to convert_number subroutine
;     push    3                   ; pass exponent of 2's power to convert_number subroutine
;     call    convert_number
;     add     esp, 8              ; pop arguments from the stack
;     jmp     return

; not_oct:
;     cmp     edx, 'b'            ; if suffix is not 'b', it is not a binary value
;     jne     not_bin

;     ; convert binary
;     lea     eax, [ebp - 19]     ; load the address of string buffer
;     push    eax                 ; pass the address of buffer to convert_number subroutine
;     push    1                   ; pass exponent of 2's power to convert_number subroutine
;     call    convert_number
;     add     esp, 8              ; pop arguments from the stack
;     jmp     return     

; not_bin:
;     ; convert decimal
;     lea     eax, [ebp - 19]     ; load the address of string buffer
;     push    eax                 ; pass the address of buffer to convert_decimal_number subroutine
;     call    convert_decimal_number
;     add     esp, 4              ; pop arguments from the stack
;     jmp     return

; no_number:
;     xor     eax, eax    ; if there was no number in string, return 0

return:
    ; epilogue
    pop     esi
    leave
    ret

convert_number:
    ; prologue
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 12]     ; set index on the beginning of buffer array

    xor     eax, eax            ; clear accumulator, it will store the converted value
    xor     edx, edx            ; clear temporary register
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

convert_decimal_number:
    ; prologue
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 8]     ; set index on the beginning of buffer array
    xor     eax, eax            ; clear accumulator, it will store the converted value

next_digit_decimal:
    imul    eax, 10
    sub     eax, 48             ; substract value of ASCII code for '0' to get the proper value

    mov     dl, BYTE [esi]
    ; add     al, BYTE [esi]    ; add digit's ASCII code to accumulator
    add     eax, edx
    inc     esi                 ; increment buffer index

    cmp     BYTE [esi], 0
    jne     next_digit_decimal  ; if character is '\0', finish subroutine

    ; epilogue
    pop     esi
    leave
    ret