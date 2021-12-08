/**********************************************
 CIA 2, Timer A, NMI Interrupt demo v.14
 josip.kalebic@gmail.com
 Zadar, 2021
***********************************************/
BasicUpstart2(mainProg)

//----------------------------------------------------
// 			Main Program
//----------------------------------------------------
//sys49152
*=$c000


mainProg: {		


	sei                           // disable interrupts

//---------------------------------------
   
   lda #<timer1
   sta $0318 
   lda #>timer1
   sta $0319 

   // set NMI timers
   lda #$c7
   sta $dd04  //Low Byte

   lda #$4c   
   sta $dd05  //High Byze


   lda #$83   // set NMI timer ready
   sta $dd0d

   lda #1      // Start NMI A timer
   sta $dd0e   

	cli                        // re-enable interrupts
	rts                           // return to caller                       
			
}


timer1:

        pha
        txa
        pha
        tya
        pha

ldx #4
stx $d020                     // change border colour

ldx #$90             
pause: 
dex
bne pause

ldx #0
stx $d020                     // change border colour

/*
inc $dd04
lda #$83   // set NMI timer ready
sta $dd0d
*/
lda $dd0d   // look what timer it was

        pla
        tay  
        pla
        tax 
        pla     

rti             // Return from interrupt

