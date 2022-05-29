section .bss ; объявление не инициализированных переменных
    a resd 1 ; объявление не инициализированного пространства
    b resd 1
    c resd 1
    d resd 1
    array resb 32 ; резервирование 32 байт

section .data ; объявление иниц данных и конст
    chi dd 0x001133FF
    mack dd 0x000000FF
    count1 dd 0
    count2 dd 0
    e dd 0
    f dd 0
    i dd 0 ; 4
    j dd 0
    msg db " ", 0ah ; 1

section .text
    global _start ; необходимо для линкера ld

_start: ; сообщает линкеру стартову точку
    ; Начало вывода chi
    mov eax, [chi]
    mov ebx, 2
    mov ecx, 0
    lp11:
        div ebx
        mov [array+ecx], edx
        inc ecx ; +1
        mov edx, 0
        sub eax, 0 ; вычитание
        jnz lp11 ; переход, если содерж != 0
    dec ecx ; -1
    lp12:
        mov [f], ecx
        mov eax, [array+ecx]
        add eax, 48 ; сложение
        mov [e], eax
        mov rax, 1
        mov rdi, 1
        mov rsi, e
        mov rdx, 1
        syscall
        mov ecx, [f]
        dec ecx
        cmp ecx, -1
        jnz lp12
    mov dword [e], 0
    mov dword [f], 0
    ; Конец вывода chi

    jmp for11 ; прыжок
for12:
    mov eax, [i]
    inc eax
    mov [j], eax
    jmp for21
for22:
    ; Находим с
    mov eax, 3; кладем в eax 3
    sub eax, [i]; вычетаем из 3 знач i
    sal eax, 3; Умножение eax на 3
    mov edx, [mack]; Кладем в edx маску
    mov ecx, eax
    sal edx, cl; сдвигаем маску, куда надо
    mov eax, edx
    and eax, [chi]; Проходим маской по числу
    mov [c], eax; Результат в с

    ; Аналогично находим d
    mov eax, 3
    sub eax, [j]
    sal eax, 3
    mov edx, [mack]
    mov ecx, eax
    sal edx, cl
    mov eax, edx
    and eax, [chi]
    mov [d], eax

    mov eax, [c]; a = c
    mov [a], eax
    mov eax, [d]; b = d
    mov [b], eax

    ; Считаем кол-во единиц
    jmp c1; Прыг на с1 для проверки условия
w1:
    add DWORD[count1], 1
    mov eax, [a]
    sub eax, 1
    and [a], eax
c1:
    cmp DWORD[a], 0
    jne w1; Если а - не 0, прыг на w1

    ; тоже самое с b
    jmp c2
w2:
    add DWORD[count2], 1
    mov eax, [b]
    sub eax, 1
    and DWORD [b], eax
c2:
    cmp DWORD[b], 0
    jne w2

    ; Сравниваем count1 и count2
    mov eax, [count2]
    cmp eax, [count1]
    jbe else; если c2 < c1, прыгаем на иначе

    ; Убираем из chi два байта
    mov eax, [chi]
    sub eax, [d]
    sub eax, [c]
    mov [chi], eax

    ; сдвиг с
    mov eax, [j]
    sub eax, [i]
    sal eax, 3
    mov ecx, eax
    shr DWORD [c], cl

    ; сдвиг d
    mov eax, [j]
    sub eax, [i]
    sal eax, 3
    mov ecx, eax
    sal DWORD [d], cl

    ; добавляем в chi два байта
    mov edx,[chi]
    mov eax,[d]
    add edx, eax
    mov eax, DWORD [c]
    add eax, edx
    mov DWORD [chi], eax
else:
    mov DWORD [count1], 0
    mov DWORD [count2], 0
    add DWORD [j], 1
for21:
    cmp DWORD [j], 3
    jle for22; если j <= 3, прыг обратно
    inc DWORD [i]
for11:
    cmp DWORD [i], 2
    jle for12; если i <= 2, прыг обратно

; вывод пробела
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 2
syscall

; Начало вывода chi
mov eax, [chi]
mov ebx, 2
mov ecx, 0
mov rdx, 0
lp21:
    div ebx
    mov [array+ecx], edx
    inc ecx
    mov edx, 0
    sub eax, 0
    jnz lp21
    dec ecx
lp22:
    mov [f], ecx
    mov eax, [array+ecx]
    add eax, 48
    mov [e], eax
    mov rax, 1
    mov rdi, 1
    mov rsi, e
    mov rdx, 1
syscall
    mov ecx, [f]
    dec ecx
    cmp ecx, -1
    jnz lp22
    mov rax, 60
    mov rdi, 0
syscall
; Конец вывода
