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
MOV SS,AX ;以上几步实现对程序的初始化
LEA DX,INFO
MOV AH,9
INT 21H ;这三行实现输出一行提示信息

INPUT:
MOV AH,1
INT 21H
CMP AL,0DH ;输入为回车则跳到转十进制模块
JE CD
SUB AL,30H ;三个SUB，实现数字及大小写字母ASCII转数值
CMP AL,09H ;输入为0~9直接进入转二进制模块
JBE CB
SUB AL,07H
CMP AL,0AH
JBE CB
SUB AL,20H ;以上四步将键入的大小写字母转化成对应的数值
CMP AL,0AH
JBE CB

CB:
MOV CL,4
SHL BX,CL ;将BX左移4位实现乘16
XOR AH,AH ;初始化AH，保证相加时只加AL
ADD BX,AX
PUSH BX ;完成相加后入栈，则可知最后入栈的为最终值
JMP INPUT ;跳回输入模块进行下位数的输入

CD:
POP AX ;将栈顶数据，即键入数代表的实际值取出
S:XOR DX,DX
MOV BX,10
DIV BX ;对数除10取余数，取得最低位，余数在DX中
MOV [STORED+SI],DL ;将余数存入STORED这一数组
CMP AX,0
JE DISPLAY ;对商判断，商0时则应跳出除法循环
INC SI ;要注意SI在判断后增1，才不会对后续取出造成影响
JMP S ;再对该步的商做除法取余，以取得次低位，依次循环

DISPLAY:
LEA DX,REPORT
MOV AH,9
INT 21H ;输出提示信息
MOV CX,4
S1:MOV DL,[STORED+SI] ;此时SI指向的是数的最高位,，可直接操作
ADD DL,30H
MOV AH,02H
INT 21H ;将数值转换为ASCII码并输出
MOV AX,SI
CMP AX,0
JE ENDD
DEC SI ;自减1，输出次高位，依次循环
JMP S1

ENDD:
MOV AH,4CH
INT 21H

CODE ENDS
END START