/**********************************************
 Raster Interrupt demo v.13
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

   
         lda #$7f	//Disable CIA IRQ's
         sta $dc0d
         sta $dd0d
            
//----------------------------------

	lda $d01a                     // enable raster irq
	ora #$01
	sta $d01a

	lda $d011                     // Screen control register
	and #$7f					         // %01111111
	sta $d011

	lda position                  // line number to go off at
	sta $d012                     // low byte of raster line

	lda #<intcode                 // get low byte of target routine
	sta $0314                       // put into interrupt vector
	lda #>intcode                 // do the same with the high byte
	sta $0315

//---------------------------------------

   lda #<timer1
   sta $0318 //$FFFA
   lda #>timer1
   sta $0319 //$FFFB


   lda #$4c   // set NMI timers
   sta $dd05
   //sta $dd07
   //clc
   lda #$c7
   //sbc #5
   sta $dd04
   //sbc #1
   //sta $dd06

   lda #$83   // set NMI timer ready
   sta $dd0d

   lda #1      // Start NMI A timer
   sta $dd0e	

	cli                           // re-enable interrupts
	rts                           // return to caller                       
			
}


timer1: {

   pha      // save A,X reg to stack
   txa
   pha
   lda $d020   // and BG color
   pha

	ldx #6
	stx $d020                     // change border colour

	ldx #$90             
	pause1: 
	dex
	bne pause1

//	ldx #0
//	stx $d020                     // change border colour

   inc $dd04

   lda $dd0d   // look what timer it was

   pla      // BG color before NMI back
   sta $d020
   pla
   tax
   pla
   rti

}


intcode: { 

   lda $d020   // and BG color
   pha

	ldx #1
	stx $d020                     // change border colour


       ldx #$90             
pause2: dex
       bne pause2


   pla      // BG color before NMI back
   sta $d020


	lda $d019                     // clear source of interrupts
	sta $d019

	inc position
	ldx position                  // reset line number to go off at
	stx $d012

	jmp $ea31                     // exit back to rom

	rts
}


position: .byte $10
