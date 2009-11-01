; program example cosc 2331
; author:  Andrew Plunk

; uninitialized data sectiom
 section .bss  
 readString1 resb 70
 string1Len resd 1
 readString2 resd 70
 string2Len resd 1

;section declaration for defined data (must be initialized)
 section .data     
 prompt_msg db "Enter something please... or else! ",10  ; the 10 is the newline(LineFeed)  
 promptlen equ $ - prompt_msg            ; length of the message
 echo_msg db "Here is what you entered",10; echoing user input
 echoLen equ $ - echo_msg            ; length of the message
 uc_msg db "Here is your message in all CAPS!",10 
 ucLen equ $ - uc_msg            ; length of the message
 lc_msg db "Here is your message in all lowercase!" 
 lcLen equ $ - lc_msg            ; length of the message

 newline db  10             ; our own string for a LineFeed(LF)

 section .text     ;  section declaration for instructions

 global _start ;loader. They conventionally recognize _start as their

 _start:

  ;write our hello world message (it includes lf)
    mov edx,promptlen             ;  message length
    mov ecx, prompt_msg       ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80       ; call kernel to perform the interrupt (output string)

b1:   
   ; now read the name   
    mov edx, 70            ; max chars to read
    mov ecx, readString1  ; where to store input value
    mov ebx, 2             ; where to read from (stdin)
    mov eax, 3             ; read 
    int 0x80        ; call kernel to perform the interrupt (input string)

    dec eax                ; don't count newline
    mov dword [string1Len], eax  

l1:
     mov edi, readString1  ;  loads address of myString into register edi (addresses are 32bits)
     mov ecx, [string1Len];  loads number of chars in myString (stored from the input) into ecx
 
     test ecx, ecx  ; check if ecx is 0 if so no chars to look at 
                ;;; same as cmp ecx, 0 but a bit more efficient
     je done_with_string
 
top_loop:  
     mov al, [edi]  ;  get the character pointed at by edi into al
     cmp al, 'a'     ;  
     jb  not_lower_case  ; if its smaller its not lower case
     cmp al, 'z'
     ja  not_lower_case ;  if its bigger its not lower case
     sub al, 32       ;  convert the char in al to uppercase
     mov  [readString2], al     ;; move the converted char in al back out to string

  ;write our hello world message (it includes lf)
    mov edx, string2Len             ;  message length !!!!!!!!!!!!!
    mov ecx, readString2       ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80       ; call kernel to perform the interrupt (output string)

not_lower_case:
     inc edi   ;  add 1 to edi so it points to next char in the string
     loop top_loop    ;  decrements ecx if not zero jmps to top_loop


done_with_string:

