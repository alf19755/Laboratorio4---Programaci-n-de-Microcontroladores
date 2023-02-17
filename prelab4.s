;UNIVERSIDAD DEL VALLE DE GUATEMALA
;IE2023 Programación de Microcontroladores
;Autor:		Mónica Alfaro
;Compilador:	pic-as (v2.36), MPLABX (v6.00)
;
;Programa:	PreLaboratorio4 (Contador bonario de 4 bits con 2 botones de 
;			      incremento y decremento.		
;			      Los botones deben funcionar con interrupciones
;			      del PORTB Y estar configurados como PULL UPS int.
;				
;Dispositivo:	PIC16F887
;Hardware:	LEDs en el puerto A, botones en el puerto B
;
;Creado: 13 de febrero , 2023
;Última modificación:  13 de febrero , 2023


PROCESSOR 16F887
#include <xc.inc>
;configuration word 1
 CONFIG FOSC=INTRC_NOCLKOUT //OSCILADOR INTERNO SIN SALIDAS
 CONFIG WDTE=OFF //WDT DISEABLED (REINICIO REPETITIVO DEL PIC)
 CONFIG PWRTE=OFF //PWRT ENABLED (ESPERA DE 72ms AL INICIAR)
 CONFIG MCLRE=OFF //EL PIN DE MCLR SE UTILIZA COMO I/0
 CONFIG CP=OFF	//SIN PROTECCIÓN DE CÓDIGO
 CONFIG CPD=OFF	//SIN PROTECCIÓN DE DATOS
 
 CONFIG BOREN=OFF //SIN REINICIO CUÁNDO EL VOLTAJE DE ALIMENTACIÓN BAJA DE 4V
 CONFIG IESO=OFF //REINCIO SIN CAMBIO DE RELOJ DE INTERNO A EXTERNO
 CONFIG FCMEN=OFF //CAMBIO DE RELOJ EXTERNO A INTERNO EN CASO DE FALLO
 CONFIG LVP=OFF //PROGRAMACIÓN EN BAJO VOLTAJE PERMITIDA
 
;configuration word 2
 CONFIG WRT=OFF	//PROTECCIÓN DE AUTOESCRITURA POR EL PROGRAMA DESACTIVADA
 CONFIG BOR4V=BOR40V //REINICIO ABAJO DE 4V, (BOR21V=2.1V)

PSECT udata_bank0	; common memory

    
 PSECT udata
 W_TEMP:
    DS 1
 STATUS_TEMP:
    DS 1
    
PSECT resVect, class=code, abs, delta=2
;----------------------------------VECTOR RESET----------------------------
ORG 00h			    ;Posicion 0000h para el vector
resetVec:
    PAGESEL main
    goto main

PSECT code, delta=2, abs
ORG 100h		    ;Posicion para el codigo
 
;--------------------------VECTOR DE INTERRUPCIONES-----------------------------

PSECT code, delta=2, abs
 ORG 0x0004
PUSH:			    ;Parte de el código que menciona el datasheet.
    MOVWF W_TEMP
    SWAPF STATUS, W
    MOVWF STATUS_TEMP
    
IRBIF:
    btfss INTCON, 0	    ; Revisa si la bandera IRBIF está activada
    
    goto POP
    
revisarboton1:
    btfss PORTB, 0	    ; Revisa si el botón está presinoado (llegan 5v)
    goto revisarboton2
    incf PORTC, F	    ; Incrementa el contador en PORTC
    ;Antirebote
    btfss PORTB, 0
    goto  $-1
    
    bcf INTCON, 0	    ; S
    
revisarboton2:		    
    btfss PORTB, 1	    ; Revisa si el botón está presinoado (llegan 5v)
    goto POP
    decf PORTC, F	    ; Decrementa el contador en PORTC
    ;Antirebote
    btfss PORTB, 1
    goto  $-1
    bcf  INTCON, 0	    
    
POP:
    SWAPF STATUS_TEMP, W
    MOVWF STATUS
    SWAPF W_TEMP, F
    SWAPF W_TEMP, W
    RETFIE		    ;REGRESA DE LA INTERRUPCIÓN
;*******************************************************************************
;CÓDIGO PRINCIPAL
;*******************************************************************************
PSECT CODE, delta = 2, abs
 ORG 0x100
 
main:    

    call configuracion_inicial
    call config_clck
    call interrupcion_puertoB
    call interrupciones
   

    BANKSEL PORTC
    clrf PORTC
    clrf PORTB    
    
;*******************************************************************************
;LOOP INFINITO
;*******************************************************************************
    
loop: 
   goto loop
    
;*******************************************************************************
;CONFIGURACIONES
;*******************************************************************************
  
configuracion_inicial:
    
    banksel ANSEL	    ; Configuración de pines digitales
    clrf ANSEL		  
    clrf ANSELH		   
    
    banksel TRISC
    clrf TRISC
    clrf TRISB
    
    BANKSEL TRISB
    MOVLW 0b11110000	    ; 4 bits de salida para puerto c
    MOVWF TRISC
    MOVLW 0b00000011	    ; 2 bits de entrada para puerto b
    MOVWF TRISB
    
    RETURN
    
config_clck:
    
    banksel OSCCON	    ;Vamos al banco 1, donde está el OSCCON 
    bcf OSCCON, 4	    ;Los bits 5 y 6 del registro OSCCON son IRCF y 
    bsf OSCCON, 5	    ;la combinación de esos bits determina el FOSC
    bcf OSCCON, 6	    ;IRCF=010  250khZ --> verificar ircf en datasheet 
    bsf OSCCON, 0	    ;Selección de reloj interno con el bit 0 (SCS)
    return
    
    return
    
interrupciones:
    
    banksel INTCON
    clrf INTCON
    bsf INTCON, 6	    ; SE HABILITAN LAS INTERRUPCIONES PERIFÉRICAS PEIE
    bsf INTCON, 3	    ; SE HABILITA LA INTERRUPCIÓN RBIE
    bsf INTCON, 0	    ; SE HABILITA LA BANDERA DE RBIF
    bsf INTCON, 7	    ; SE HABILITAN LAS INTERRRUPCIONES GLOBALES GIE
    
    return
    
interrupcion_puertoB:
    
    BANKSEL IOCB
    BSF IOCB, 0
    BSF IOCB, 1		    ; HABILITANDO RB0 Y RB1 PARA LAS ISR DE RBIE
    
    BANKSEL OPTION_REG
    BCF OPTION_REG, 7	    ; HABILITANDO PULLUPS PUERTO B
    
    BSF WPUB, 0
    BSF WPUB, 1		    ; HABILITANDO LOS PULLUPS EN RB0 Y RB1
    
    RETURN
    
;*******************************************************************************
;Subrutinas
;*******************************************************************************

    
;*******************************************************************************
;FIN DEL CÓDIGO
;*******************************************************************************
    
END
 
