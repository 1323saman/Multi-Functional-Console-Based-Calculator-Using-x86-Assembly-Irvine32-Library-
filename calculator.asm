
INCLUDE Irvine32.inc

.data
msgMenu BYTE "Calculator",0Dh,0Ah,
        "1. Addition",0Dh,0Ah,
        "2. Subtraction",0Dh,0Ah,
        "3. Multiplication",0Dh,0Ah,
        "4. Division",0Dh,0Ah,
        "5. Factorial",0Dh,0Ah,
        "6. Modulus",0Dh,0Ah,
        "7. Power",0Dh,0Ah,
        "8. Prime Check",0Dh,0Ah,
        "9. Palindrome Check",0Dh,0Ah,
        "10. Exit",0Dh,0Ah,
        "Choose option: ",0

msgWrong      BYTE "Wrong number selected!",0Dh,0Ah,0
msgA          BYTE "Enter first number: ",0
msgB          BYTE "Enter second number: ",0
msgF          BYTE "Enter number for factorial: ",0
msgPowerPrompt BYTE "Enter power number: ",0
msgResult     BYTE "Result = ",0
msgDot        BYTE ".",0
msgDivZero    BYTE "Error: Division by zero!",0Dh,0Ah,0
msgFactErr    BYTE "Error: Factorial of negative number!",0Dh,0Ah,0
msgPowerErr   BYTE "Error: Negative exponent not supported!",0Dh,0Ah,0
msgPrimeYes   BYTE "The number is Prime.",0Dh,0Ah,0
msgPrimeNo    BYTE "The number is NOT Prime.",0Dh,0Ah,0
msgPalindromeYes BYTE "The number is a Palindrome.",0Dh,0Ah,0
msgPalindromeNo  BYTE "The number is NOT a Palindrome.",0Dh,0Ah,0
msgPalindromePrompt BYTE "Enter number to check for palindrome: ",0

choice     DWORD ?
num1       SDWORD ?
num2       SDWORD ?
result     SDWORD ?
quotient   SDWORD ?
decimal    DWORD ?

.code
main PROC

menu:
    mov edx, OFFSET msgMenu
    call WriteString
    call ReadInt
    mov choice, eax

    cmp choice, 1
    je doAdd
    cmp choice, 2
    je doSub
    cmp choice, 3
    je doMul
    cmp choice, 4
    je doDiv
    cmp choice, 5
    je doFact
    cmp choice, 6
    je doMod
    cmp choice, 7
    je doPower
    cmp choice, 8
    je doPrime
    cmp choice, 9
    je doPalindrome
    cmp choice, 10
    je exitProg

    jmp invalidChoice

; ===============================
doAdd:
    call GetNumbers
    call AddNums
    jmp showIntResult

doSub:
    call GetNumbers
    call SubNums
    jmp showIntResult

doMul:
    call GetNumbers
    call MulNums
    jmp showIntResult

doDiv:
    call GetNumbers
    cmp num2, 0
    je divError
    call DivNums
    jmp showDivResult

doFact:
    mov edx, OFFSET msgF
    call WriteString
    call ReadInt
    cmp eax, 0
    jl factError
    mov num1, eax
    call Factorial
    jmp showIntResult

doMod:
    call GetNumbers
    cmp num2, 0
    je divError
    call Modulus
    jmp showIntResult

doPower:
    mov edx, OFFSET msgA
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgPowerPrompt
    call WriteString
    call ReadInt
    mov num2, eax

    cmp num2, 0
    jl powerError
    call Power
    jmp showIntResult

doPrime:
    mov edx, OFFSET msgA
    call WriteString
    call ReadInt
    mov num1, eax
    call PrimeCheck
    cmp result, 1
    je primeYes
    jne primeNo

primeYes:
    mov edx, OFFSET msgPrimeYes
    call WriteString
    jmp menu

primeNo:
    mov edx, OFFSET msgPrimeNo
    call WriteString
    jmp menu

doPalindrome:
    mov edx, OFFSET msgPalindromePrompt
    call WriteString
    call ReadInt
    mov num1, eax
    call PalindromeCheck
    cmp result, 1
    je palindromeYes
    jne palindromeNo

palindromeYes:
    mov edx, OFFSET msgPalindromeYes
    call WriteString
    jmp menu

palindromeNo:
    mov edx, OFFSET msgPalindromeNo
    call WriteString
    jmp menu

; ===============================
invalidChoice:
    mov edx, OFFSET msgWrong
    call WriteString
    call Crlf
    jmp menu

divError:
    mov edx, OFFSET msgDivZero
    call WriteString
    call Crlf
    jmp menu

factError:
    mov edx, OFFSET msgFactErr
    call WriteString
    call Crlf
    jmp menu

powerError:
    mov edx, OFFSET msgPowerErr
    call WriteString
    call Crlf
    jmp menu

; ===============================
; DISPLAY RESULTS
; ===============================

showIntResult:
    mov edx, OFFSET msgResult
    call WriteString
    mov eax, result
    call PrintSigned
    call Crlf
    call Crlf
    jmp menu

showDivResult:
    mov edx, OFFSET msgResult
    call WriteString

    mov eax, quotient
    call PrintSigned

    mov edx, OFFSET msgDot
    call WriteString

    mov eax, decimal
    cmp eax, 9
    jg noZero
    mov eax, 0
    call WriteDec
    mov eax, decimal
noZero:
    call WriteDec

    call Crlf
    call Crlf
    jmp menu

exitProg:
    exit
main ENDP

; ===============================
; INPUT (USES IRVINE)
; ===============================
GetNumbers PROC
    mov edx, OFFSET msgA
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgB
    call WriteString
    call ReadInt
    mov num2, eax
    ret
GetNumbers ENDP

; ===============================
; ARITHMETIC (NO IRVINE)
; ===============================
AddNums PROC
    mov eax, num1
    add eax, num2
    mov result, eax
    ret
AddNums ENDP

SubNums PROC
    mov eax, num1
    sub eax, num2
    mov result, eax
    ret
SubNums ENDP

MulNums PROC
    mov eax, num1
    imul num2
    mov result, eax
    ret
MulNums ENDP

DivNums PROC
    mov eax, num1
    cdq
    idiv num2
    mov quotient, eax

    mov eax, edx
    imul eax, 100
    cdq
    idiv num2
    cmp eax, 0
    jge okDec
    neg eax
okDec:
    mov decimal, eax
    ret
DivNums ENDP

Factorial PROC
    mov eax, 1
    mov ecx, num1
factLoop:
    cmp ecx, 1
    jl doneFact
    imul eax, ecx
    dec ecx
    jmp factLoop
doneFact:
    mov result, eax
    ret
Factorial ENDP

Modulus PROC
    mov eax, num1
    cdq
    idiv num2
    mov eax, edx
    cmp eax, 0
    jge modDone
    cmp num2, 0
    jl modDone
    add eax, num2
modDone:
    mov result, eax
    ret
Modulus ENDP

Power PROC
    mov eax, 1
    mov ecx, num2
    mov ebx, num1
powLoop:
    cmp ecx, 0
    je powDone
    imul eax, ebx
    dec ecx
    jmp powLoop
powDone:
    mov result, eax
    ret
Power ENDP

; ===============================
; PRIME CHECK FUNCTION
; ===============================
PrimeCheck PROC
    mov eax, num1
    cmp eax, 2
    jb notPrime
    je isPrime

    mov ecx, 2              ; divisor
checkLoop:
    mov edx, 0
    mov ebx, eax
    div ecx                 ; eax / ecx
    cmp edx, 0
    je notPrime
    inc ecx
    cmp ecx, eax
    jl checkLoop
isPrime:
    mov result, 1
    ret
notPrime:
    mov result, 0
    ret
PrimeCheck ENDP

; ===============================
; PALINDROME CHECK FUNCTION
; ===============================
PalindromeCheck PROC
    mov eax, num1
    mov ebx, eax        ; store original number
    mov ecx, 0          ; reversed number

revLoop:
    cmp eax, 0
    je revDone
    mov edx, 0
    mov edi, 10
    div edi             ; eax/10 -> quotient in eax, remainder in edx
    imul ecx, 10
    add ecx, edx
    jmp revLoop

revDone:
    cmp ecx, ebx
    je isPalindrome
    mov result, 0
    ret

isPalindrome:
    mov result, 1
    ret
PalindromeCheck ENDP

; ===============================
; SIGNED NUMBER PRINT
; ===============================
PrintSigned PROC
    push eax
    cmp eax, 0
    jge PrintPositive
    neg eax
    mov ebx, eax
    mov al, '-'
    call WriteChar
    mov eax, ebx
PrintPositive:
    call WriteDec
    pop eax
    ret
PrintSigned ENDP

END main
