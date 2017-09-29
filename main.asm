;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:
	bis.b	#((1<<6)|(1<<0)), P1DIR

main_loop:
	call #DELAY

	bis.b	#((1<<6)|(1<<0)), P1OUT

	call #DELAY

	bic.b	#((1<<6)|(1<<0)), P1OUT
	jmp main_loop
                                            

;Simple Delay
	.def DELAY
	.text
	.retain
	.retainrefs
	.asmfunc
DELAY_N	.set 40000
DELAY:
	mov.w #DELAY_N, r15
$l0:
	dec.w	r15
	tst.w	r15
	jnz $l0
	ret
	.endasmfunc

;COM A ISR
	.def COMA_ISR
	.text
	.retain
	.retainrefs
COMA_ISR:
	reti
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
 ; MSP430 RESET Vector
	.intvec ".reset", RESET
	.intvec ".int11", COMA_ISR

            .end
