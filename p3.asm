STACK SEGMENT
DB 20 DUP(?)
STACK ENDS

DATA SEGMENT
INFO DB 'Please enter a number in hec form:',10,13,'$'
REPORT DB 'The number in dec form is:',10,13,'$'
STORED DB 5 DUP(?) 
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK
START:
XOR BX,BX
MOV AX,DATA
MOV DS,AX
MOV AX,STACK
MOV SS,AX ;���ϼ���ʵ�ֶԳ���ĳ�ʼ��
LEA DX,INFO
MOV AH,9
INT 21H ;������ʵ�����һ����ʾ��Ϣ

INPUT:
MOV AH,1
INT 21H
CMP AL,0DH ;����Ϊ�س�������תʮ����ģ��
JE CD
SUB AL,30H ;����SUB��ʵ�����ּ���Сд��ĸASCIIת��ֵ
CMP AL,09H ;����Ϊ0~9ֱ�ӽ���ת������ģ��
JBE CB
SUB AL,07H
CMP AL,0AH
JBE CB
SUB AL,20H ;�����Ĳ�������Ĵ�Сд��ĸת���ɶ�Ӧ����ֵ
CMP AL,0AH
JBE CB

CB:
MOV CL,4
SHL BX,CL ;��BX����4λʵ�ֳ�16
XOR AH,AH ;��ʼ��AH����֤���ʱֻ��AL
ADD BX,AX
PUSH BX ;�����Ӻ���ջ�����֪�����ջ��Ϊ����ֵ
JMP INPUT ;��������ģ�������λ��������

CD:
POP AX ;��ջ�����ݣ��������������ʵ��ֵȡ��
S:XOR DX,DX
MOV BX,10
DIV BX ;������10ȡ������ȡ�����λ��������DX��
MOV [STORED+SI],DL ;����������STORED��һ����
CMP AX,0
JE DISPLAY ;�����жϣ���0ʱ��Ӧ��������ѭ��
INC SI ;Ҫע��SI���жϺ���1���Ų���Ժ���ȡ�����Ӱ��
JMP S ;�ٶԸò�����������ȡ�࣬��ȡ�ôε�λ������ѭ��

DISPLAY:
LEA DX,REPORT
MOV AH,9
INT 21H ;�����ʾ��Ϣ
MOV CX,4
S1:MOV DL,[STORED+SI] ;��ʱSIָ������������λ,����ֱ�Ӳ���
ADD DL,30H
MOV AH,02H
INT 21H ;����ֵת��ΪASCII�벢���
MOV AX,SI
CMP AX,0
JE ENDD
DEC SI ;�Լ�1������θ�λ������ѭ��
JMP S1

ENDD:
MOV AH,4CH
INT 21H

CODE ENDS
END START