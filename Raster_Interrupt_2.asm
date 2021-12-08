/**********************************************
 Raster Interrupt demo v.12
 josip.kalebic@gmail.com
 Zadar, 2021
***********************************************/
BasicUpstart2(mainProg)

//----------------------------------------------------
// 			Main Program
//----------------------------------------------------
*=$c000

mainProg: {		

	sei                           // disable interrupts

	lda #$7f                      // turn off the cia interrupts
	sta $dc0d
	sta $dd0d

	lda $d01a                     // Interrupt control register
	ora #$01					  // enable raster irq
	sta $d01a

			                      // clear high bit of raster line
	lda $d011                     // Screen control register
	and #$7f					  // %01111111
	sta $d011

	lda position                  // line number to go off at
	sta $d012                     // low byte of raster line

	//Execution address of interrupt service routine.
	lda #<intcode                 // get low byte of target routine
	sta $0314                       // put into interrupt vector
	lda #>intcode                 // do the same with the high byte
	sta $0315

	cli                           // re-enable interrupts
	rts                           // return to caller
}

intcode: {

	//inc $d020                     // change border colour

	ldx #1
	stx $d020                     // change border colour

	lda $d012
	adc #$15
ddt3:
	cmp $d012
	bne ddt3

	ldx #0
	stx $d020                     // change border colour

	lda $d019                     // clear source of interrupts
	sta $d019					  // Acknowledge raster interrupt	

	inc position
	ldy position                  // reset line number to go off at
	sty $d012

	jmp $ea31                     // exit back to rom // sys IRQ handler

	rts
}

position: .byte $20
