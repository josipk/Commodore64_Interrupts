/**********************************************
 Raster Interrupt demo v.1
 josip.kalebic@gmail.com
 Zadar, 2021
***********************************************/

//sys4096
*=$1000 

	sei                           // disable interrupts

	lda #$7f                      // turn off the cia interrupts
	sta $dc0d

	lda $d01a                     // Interrupt control register
	ora #$01					  // enable raster irq
	sta $d01a

	// Screen control register	
	lda $d011                     // clear high bit of raster line
	and #$7f					  // %01111111
	sta $d011

	lda #$95                      // line number to go off at
	sta $d012                     // low byte of raster line

	//Execution address of interrupt service routine.
	lda #<intcode                 // get low byte of target routine
	sta $0314                       // put into interrupt vector
	lda #>intcode                 // do the same with the high byte
	sta $0315

	cli                           // re-enable interrupts
	rts                           // return to caller

intcode:

	ldx #1
	stx $d020                     // change border colour

//	lda $d012
//	adc #$15
	lda #$aa    //#$95 + #$15
ddt3:
	cmp $d012
	bne ddt3

	ldx #0
	stx $d020                     // change border colour
	
	lda $d019                     // clear source of interrupts
	sta $d019					  // Acknowledge raster interrupt

	jmp $ea31                     // exit back to rom // sys IRQ handler

	rts
