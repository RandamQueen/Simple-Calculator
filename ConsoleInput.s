	AREA	ConsoleInput, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start

	MOV R4, #0		; result = 0
	MOV R6,#10		; 
	
read				; start of while loop 	
	
	BL	getkey		; read key from console
	CMP	R0, #0x0D  	; if (key != ENTER)
	BEQ	endRead		; { 
	
	CMP R0, #0x08	; if( key!= BACKSPACE) 
	BEQ backspace	; {
	
	BL	sendchar	;   echo key back to console
	
	MUL R4,R6,R4 	; result = result *10; 
	SUB R0,R0,#0x30 ; convert input from Ascii to Hex 
	ADD R4, R0, R4	; Result = result + value 

 B read				; }

backspace 			; else 
	BL	sendchar	;   echo key back to console
	
	SUB R0,R0,#0x30 ; convert Ascii to number 
	SUB R4, R4, R0  ; Result = result - value 
 B  devideby10		; Result = Result / 10; 	
	
devideby10
	LDR R9, = 0		; Quotient = 0 
	MOV R8, R4		; remainder = result 
while	
	CMP R8, R6		; while( remainder >= 10) 
	BLO	endwh		; { 
	ADD R9,R9,#1	; Quotient = Quotient + 1 
	SUB R8, R8, R6 	; Remainder = remainder - 10 
	B while			;}
endwh	
	SUB R9,R9,#4 	; To prevent a error with Quotient 
	MOV R4, R9		; sets result = Quotient
 B	read			; }	

endRead
stop	B	stop

	END	