DATA SEGMENT
STRING_A DB 10,13,'The School of Information and Engineering Shandong University',10,13,'$'
INFO DB 'Press 1 to display in positive order,and press 2 to display in reverse order',10,13,'$'
DATA ENDS

EXT SEGMENT
STRING_B DB 100 DUP('$')
EXT ENDS

STACKS SEGMENT
DB 100 DUP(?)
STACKS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATA,SS:STACKS,ES:EXT
START:
MOV AX,DATA
MOV DS,AX
MOV AX,EXT
MOV ES,AX ;�ԶμĴ�����ʼ��
LEA SI,STRING_A
LEA DI,STRING_B ;SIָ��Դ�ڴ浥Ԫ��DIָ��Ŀ���ڴ浥Ԫ
CALL COPY ;ʵ���ַ�������
LEA DX,INFO
MOV AH,09
INT 21H
MOV AH,07
INT 21H
CMP AL,31H
JE POSITIVE ;ʵ�ַ�֧������1��ʾ���򣬷�����ʾ����
JMP REVERSE
QUIT2:
MOV AH,4CH
INT 21H

COPY PROC NEAR
NEXT1:
MOV AL,DS:[SI]
MOV ES:[DI],AL ;Ӳ��ԭ���Ͻ���ָ��һ��ָ����뾭��CPU�еļĴ���������ֱ�������ڴ�֮�䴫��
INC SI
INC DI
MOV AL,DS:[SI]
CMP AL,24H
JE QUIT1 ;�Ѹ���λ����һλΪ'$'������ɸ��ƣ������˳��ӳ���
JMP NEXT1 ;�������������һλ
QUIT1:
RET
COPY ENDP

POSITIVE:
LEA DI,STRING_B
ADD DI,2 ;Ϊ����һ��ʼ�����10��13
NEXT2:
MOV DL,ES:[DI]
MOV AH,02H
INT 21H ;ʵ�ֶԵ�ǰ��ָ�ַ�����ʾ
INC DI
MOV AL,ES:[DI]
CMP AL,24H
JE QUIT2 ;����ʾλ����һλΪ'$'���������ʾ�������˳�
JMP NEXT2

REVERSE:
SUB DI,2
NEXT3:
DEC DI ;Ϊ����ĩβ��10,13,'$'
MOV DL,ES:[DI]
MOV AH,02H
INT 21H ;��ʾ��ǰλ
CMP DI,0
JE QUIT2 ;�ѵ���ǰ���˳�
JMP NEXT3
CODES ENDS
END START