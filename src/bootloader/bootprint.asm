[BITS 16]                   ;이 프로그램이 16비트 단위로 데이터를 처리하는 프로그램이라는 뜻
[ORG 0x7C00]

mov		ax, 0xb800
mov		es, ax              ;ax를 통해 es를 0xb800으로 초기화, 0xb800: 텍스트 출력용 메모리
mov		ax, 0x00            ;ax에 다시 0
mov		bx, 0               ;bx를 0으로
call    EraseScreen

mov     bx, 0
mov     SI, HelloString
call    PrintString         ;'Hello, SungJun' 출력

add     bx, 2               
mov     al, 0x27
mov     [es:bx], ax         ; '(작은 따옴표) 출력

mov     SI, WorldString 
call    PrintString         ;'s World' 출력 
jmp     $

; 함수, 변수
EraseScreen:                ;화면 지우기 함수
mov		cx, 80*25*2         ;화면의 크기가 (가로: 80) x (세로: 25) x (글자크기: 2바이트)
CLS:                        ;cx 만큼 반복
    mov		[es:bx], ax     ;화면을 계속 0이라는 값으로 채워주기
    add		bx, 1           ;bx 1씩 증가
loop 	CLS                 ;CLS 루프를 cx(카운터 레지스터) 만큼 돌리기 
ret

PrintCharacter:             ;ax 출력 함수
    mov     ah, 0x07        ;ah는 bios teletype
    add     bx, 2           ;bx 2씩 증가
    mov     [es:bx], ax     ;2바이트 마다 글자 찍기
ret

PrintString:                    ;SI에 있는 문자열  출력 함수
    next_character:
        mov     al, [SI]        ;ax의 글자 부분인 al에 SI에 저장되어 있는 문자 저장
        inc     si              ;아마 SI 문자열의 index를 하나 증가하는 부분 같음
        or      al, al          ;SI 문자열의 마지막인지 검사하는거 같음
            jz      exit_function   ;문자열이 끝이면 exit_function 으로
        call    PrintCharacter  ;아니면 PrintCharacter 호출
        jmp     next_character  ;다시 반복
    exit_function:
ret

HelloString db 'Hello, SungJun', 0
WorldString db 's World', 0

times 510-($-$$) db 0x00        ; $: 현재주소, SS: 세그먼트의 시작주소, 현재부터 510번째 까지 1바이트씩 0으로 채움
dw 0xaa55                       ; dw: 2바이트씩, 55aa로 끝나야하는데 리틀엔디안이라는 방식, 실제로 0xaa55 해야 55aa로 저장됨
