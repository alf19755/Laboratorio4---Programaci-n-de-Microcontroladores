# Laboratorio4---Programaci-n-de-Microcontroladores
PRELAB
Pre Lab (20%) - FísicoSe debe entregar antes del inicio del laboratorio. Se sube en canvas en formato *.zip con el
nombre prelab.
Implemente un contador binario de 4 bits utilizando dos (2) pushbuttons y cuatro (4)
LEDs. Los pushbuttons deberán utilizar las interrupciones on-change del PORTB (IOCB,
sección 3.4.3 del Datasheet) y también deberán utilizar los pull-ups internos (WPUB,
sección 3.4.2). Uno de los pushbuttons debe incrementar el contador y el otro
pushbutton deberá decrementarlo.


Lab (30%) - FísicoSe entrega durante el tiempo del laboratorio. Deberá mostrarlo al catedrático o auxiliar para tener
una nota.
Implemente un segundo contador de 4 bits utilizando una interrupción del TMR0. La
interrupción del TMR0 deberá ser entre 5 y 20ms, pero el contador deberá cambiar cada
1000ms.
Consideraciones
- Ambos contadores deben funcionar simultáneamente
- Sólo necesita una (1) subrutina de interrupción para AMBAS fuentes de
interrupción (RBIF y T0IF)
- El vector de interrupción se encuentra en la localidad 0004h de la memoria de
programa
- El POP se hace después de revisar TODAS sus banderas

Post Lab (40%) – Simulado / Físico
Se entrega después del tiempo de laboratorio según el portal. Deberá subir los entregables en
formato *.zip con el nombre entregables.
Muestre el contador con el TMR0 en un display de 7 segmentos, de manera que se
muestre el conteo en segundos.
Cada vez que el contador con el TMR0 llegue a 10 deberá de resetearlo e incrementar
otro contador en un segundo display de 7 segmentos, de manera que se muestren las
decenas de segundos.
Consideraciones
- Cuando éste llegue a 60s deberá de reiniciar ambos contadores.
- Los display de 7 segmentos deben estar en distintos puertos.

