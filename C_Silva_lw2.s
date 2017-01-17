;Cristian Silva
;ID:006283655
; Assembly language LED Drive file...
; EECE 237 Fall 2015
;
;This is a template on which codes are to be added to complete the work.
;The template as is not final and expects revisions.
;Examin the structure of the program before adding codes.
;The area where student works are to be added is marked below.
 
	AREA   LED_Drive, CODE, READONLY
	ENTRY
	EXPORT   __main
__main  B  start
         
RCC_BASE 			EQU   	0x40021000	;This may change later
RCC_AHBENR_OFF  	EQU  	0x14
RCC_AHBENR_GPIOEEN  EQU  	0X200000
GPIOE_BASE			EQU		0X48001000     ;This may change later.
MODER_OFFSET 		EQU		0x00			
OTYPER_OFFSET		EQU		0x04	
OSPEEDR_OFFSET		EQU		0x08	
PUPDR_OFFSET		EQU		0x0C	
IDR_OFFSET		EQU		0x10	
ODR_OFFSET		EQU		0x14
BSRR_OFFSET		EQU		0x18	
AFRL_OFFSET		EQU		0x20 
AFRH_OFFSET		EQU		0x24 
BRR_OFFSET		EQU 	0x28	

            
start
	BL    config_gpioe	;Configure LED port
            
main_loop
	BL 	 led_on_all
	BL 	 delay
	BL	 led_on_even
	BL   delay
	BL	 led_on_odd
	BL   delay

	B	 main_loop	;Infinite loop
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
config_gpioe	
; Enable RCC GPIO Clock
	LDR   R0, =RCC_BASE ; load base address for RCC
	LDR   R1, =RCC_AHBENR_OFF ; load offset for AHBENR
	LDR   R2, =RCC_AHBENR_GPIOEEN ; load value for GPIO PortE enable
	LDR   R3, [R0, R1] ; Read current AHBENR value
	ORR   R2, R2, R3  ; Modify AHBENR value to enable E
	STR   R2, [R0, R1] ; Write new AHBENR value to register
	; Configure GPIO_E port (LED port)
	LDR	R0, =GPIOE_BASE				;
	LDR	R1, =0x55550000
	STR	R1, [R0, #MODER_OFFSET]		;STORE MODER=0X10
	LDR	R1, =0x0000
	STR	R1, [R0, #OTYPER_OFFSET]	; STORE OTYPER =0X00
	LDR	R1, =0x0000
	STR	R1, [R0, #OSPEEDR_OFFSET]	; STORE OSPEEDR=0X00
	LDR	R1, =0x0000
	STR	R1, [R0, #PUPDR_OFFSET]		; STORE PUPDR=0X00
	LDR	R1, =0x0000
	STR	R1, [R0, #BSRR_OFFSET]		; STORE BSRR=0X00
	LDR	R1, =0x0000
	STR	R1, [R0, #AFRH_OFFSET]		; STORE AFRH=-X00
	LDR	R1, =0x0000
	STR	R1, [R0, #AFRL_OFFSET]		; STORE AFRL=0X00

	B    exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           
delay
	MOV   R9, #0xAA78
	MOVT  R9, #0x0074
delay_loop
	SUBS R9, R9, #1
	CMP  R9, #0
	BNE  delay_loop
	
	B    exit
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Student work starts here ;;;;;;;;;;;;;;;;;;;;;;;;;;;          
led_on_all
;
;Creat a pattern and load the output register
;
	LDR R2, =0XFFFF
	STR R2, [R0,#ODR_OFFSET]
;
;
	B  exit
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          
led_on_even
;
;Creat a pattern and load the output register
;
	LDR R3, =0X5555
	STR R3, [R0,#ODR_OFFSET]
;
;
	B  exit	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          
led_on_odd
;
;Creat a pattern and load the output register
;
	LDR R4, =0XAAAA
	STR R4, [R0,#ODR_OFFSET]
;
;
	B  exit	
	
;;;;;;Student work ends here  ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
exit
	BX   lr          ; return
          
	END 
