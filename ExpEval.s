	AREA	ExpEval, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start

	MOV R4, #0		;	result = 0 
	MOV R5, #0		; 	finalAns = 0 
	MOV R6,#10		;
	MOV R10, #0		;	addFirstNum = 0 	
	MOV R11, #0		; 	subFirstNum = 0 
	MOV R12, #0		; 	mulFirstNum = 0 
	MOV R7, #0		;   powerFirstNum =0
	
read				;	start of while loop 	
	
	BL	getkey		; 	read key from console
	CMP R0,#0x30	;	if ( key >= '0') 
	BLO notNum		; 	{ 
	CMP R0,#0x39	;	if (key <= '9') 
	BHI notNum 		;	{ 	
	
	BL	sendchar	;   echo key back to console
	
	MUL R4,R6,R4 	;	result = result *10; 
	SUB R0,R0,#0x30 ; 	convert Ascii to number 
	ADD R4, R0, R4	; 	Result = result + value 

 B read				; 	}
 
notNum				;	else {
 	CMP	R0, #0x0D  	; 	if (key == ENTER)
	BEQ	endRead		; 	{
	
	CMP R0, #0x08	; 	else if( key == BACKSPACE) 
	BEQ backspace	; 	{
	
	CMP R0, #0x2B	; 	else if( key == '+') 
	BEQ addchar		; 	{
	
	CMP R0, #0x2D	; 	else if( key == '-') 
	BEQ subchar		; 	{
	
	CMP R0, #0x2A	; 	else if( key == '*') 
	BEQ mulchar		; 	{
	
	CMP R0, #0x5e	; 	else if( key == '^') 
	BEQ powerchar	; 	{
	B read			; 	}


backspace 			; 	undo inputed value  
	BL	sendchar	; 	echo key back to console
	
	SUB R0,R0,#0x30 ; 	convert Ascii to number 
	SUB R4, R4, R0  ; 	Result = result - value 
 B  devideby10		; 	Result = Result / 10; 	
	
devideby10			; 
	LDR R9, = 0		; 	Quotient = 0 
	MOV R8, R4		; 	remainder = a 
while	
	CMP R8, R6		; 	while( remainder >= 10) 
	BLO	endwh		; 	{ 
	ADD R9,R9,#1	; 	Quotient = Quotient + 1 
	SUB R8, R8, R6 	; 	Remainder = remainder - 10 
	B while			;	}
endwh	
	SUB R9,R9,#4 	; 	To prevent a error with Quotient 
	MOV R4, R9		; 	sets result = Quotient
	
	 B	read		; 	}	
	 
addchar
	MOV R10, R4		;	addFirstNum = result  
	MOV R4, #0		; 	reset input
	BL	sendchar	;   echo key back to console
	B	read		;	}	
	 
subchar
	MOV R11, R4		; 	SubFirstNum = result 
	MOV R4, #0		; 	reset input
	BL	sendchar	;   echo key back to console
	B	read		; 	}	
	
mulchar
	MOV R12, R4		;	mulFirstNum = result 
	MOV R4, #0		; 	reset input
	BL	sendchar	;   echo key back to console
	B	read		; 	}	

powerchar
	MOV R7, R4		;	powerFirstNum = result 
	MOV R4, #0		; 	reset input
	BL	sendchar	;   echo key back to console
	B	read		;	 }	
	
	
endRead				; 
	CMP R10, #0		; 	if ( addFirstNum != 0)
	BEQ notadd		; 	{ 	
	ADD R5,R10, R4	; 	finalAns = addFirstNum + result
	B endCompute	;
notadd

	CMP R11, #0		; 	else if ( subFirstNum != 0)
	BEQ notsub		; 	{ 	
	SUB R5,R11,R4	;	finalAns = subFirstNum - result
	B endCompute	;
notsub

	CMP R12, #0		; 	else if ( mulFirstNum != 0)
	BEQ notmul		; 	{ 	
	MUL R5,R12,R4	; 	finalAns = mulFirstNum * result
	B endCompute	;
notmul

	CMP R7, #0		; 	else if ( powerFirstNum != 0)
	BEQ notpower	; 	{ 
	MOV R6, #1		; 	powerStore =1	
powerwhile 			; 
	CMP R4, #0		; 	while( result !=0 ) 
	BEQ endpowerwh	; 	{ 
	MUL R6,R7,R6	; 	powerStore = powerFirstNum * powerStore
	SUB R4, R4, #1	; 	result = result -1 
	b 	powerwhile 	; 	} 
endpowerwh
	MOV R5, R6		; 	finalAns = powerStore
notpower
endCompute

stop	B	stop

	END	