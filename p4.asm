STACK SEGMENT
DW 300 DUP(?)
STACK ENDS

DATA SEGMENT
INFO1 DB 'Please enter the first number in dec form:',10,13,'$'
INFO2 DB 'Please enter the second number in dec form:',10,13,'$'
INFO3 DB 10,13,'The result is:',10,13,10,13,'$'
BUF1 DB 300 DUP(?)
BUF2 DB 300 DUP(?)
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK
START:
XOR BX,BX
MOV AX,DATA
MOV DS,AX
MOV AX,STACK
MOV SS,AX
LEA DX,INFO1
MOV AH,9H
INT 21H ;�Գ�����ɳ�ʼ���ú������ʾ
CALL FIRSTNUM ;������ĵ�һ�������д洢
LEA DX,INFO2
MOV AH,9H
INT 21H
CALL SECNUM ;������ĵڶ��������д洢
LEA DX,INFO3
MOV AH,9H
INT 21H
CALL SUM ;������������ȫ����ԭ����Ӳ���ʾ
MOV AH,4CH
INT 21H

FIRSTNUM PROC NEAR
N1:MOV AH,1
INT 21H
CMP AL,0DH
JE QUIT1 ;��Ϊ�س���������룬����������
SUB AL,30H
MOV [BUF1+SI],AL ;��ASCIIתΪ��ֵ����BUF1����
INC SI
JMP N1;�ظ����벢�洢
QUIT1: 
DEC SI ;֮���Լ�1����Ϊ������ָ���һ�����ĸ�λ
RET
FIRSTNUM ENDP

SECNUM PROC NEAR
N2:MOV AH,1
INT 21H
CMP AL,0DH
JE QUIT2
SUB AL,30H
MOV [BUF2+DI],AL ;��FIRSTNUM�������ڴ���BUF2���飬ָ��ΪDI
INC DI
JMP N2
QUIT2: 
DEC DI
RET
SECNUM ENDP

SUM PROC NEAR
MOV AX,0FFFH ;����һ���б��Ƿ���ɼӷ��ı�־
PUSH AX
XOR AX,AX ;��ʼ��AX
NEXTSUM:
MOV AL,BYTE PTR [SI+BUF1]
ADD AH,BYTE PTR [DI+BUF2] ;ʹ��ADD�Ա������Ե�λ�Ľ�λ
ADD AL,AH ;����ͬȨλ�����Ե�λ�Ľ�λ���
CMP AL,10
JGE OVER ;�ж��Ƿ���Ҫ��λ

CMP SI,0 ;SI�Ƿ���ָ���һ���������λ���Ƿ�Ϊ0��
JE IGN1
DEC SI ;δָ�����λ��ָ���һλ
CMP DI,0 ;DI�Ƿ���ָ���һ���������λ���Ƿ�Ϊ0��
JE IGN2
IGN3:
DEC DI ;δָ�����λ��ָ���һλ
JMP IGN4
IGN2:
MOV [DI+BUF2],0 ;�ϴμӷ�����DI����ָ�����λ�������λ��0����ֹӰ���������
IGN4:XOR AH,AH
PUSH AX
JMP NEXTSUM ;��ʱ�޽�λ��ֱ�ӽ���λ��ӽ����ջ
IGN1:
MOV [SI+BUF1],0 ;����ͬ��
CMP DI,0
JNE IGN3
XOR AH,AH
PUSH AX
JMP DISPLAY ;�������λ�����������޽�λ����ջ��ǰλ����������ʾ����

OVER:
CMP SI,0
JE IGNORE1
DEC SI
CMP DI,0
JE IGNORE2
IGNORE3:
DEC DI
JMP IGNORE4
IGNORE2:
MOV [DI+BUF2],0 ;��OVER��־���ˣ���(AL)<10���ʱǰ���еĲ�����ͬ
IGNORE4:XOR AH,AH
SUB AL,0AH
PUSH AX
MOV AH,01H
JMP NEXTSUM ;ֻҪSI��DI����һ����Ϊ0����ὫAL�е�����10����ջ��AH��1�����λ��������һλ�Ĵ���
IGNORE1:
MOV [SI+BUF1],0
CMP DI,0
JNE IGNORE3 ;SIΪ0��DI��0ʱ����SI���λ��0
SUB AL,0AH
XOR AH,AH
PUSH AX
MOV AX,0001H
PUSH AX ;�������λ�����������н�λ����ջ��ǰλ������ٽ�0001��ջ��������ʾ����

DISPLAY:
NEXDIS:POP DX
CMP DX,0FFFH
JE QUIT5 ;ÿһλ�����ջ��ֱ������������־ֹͣ
ADD DL,30H ;ʵ����ֵתASCII
MOV AH,02H
INT 21H
JMP NEXDIS ;��ʾ��һλ������һλ����ʾ
QUIT5:RET
SUM ENDP

CODE ENDS
END START