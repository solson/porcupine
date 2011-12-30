bits 32

section .text

;;;
;;; Ports
;;;

;;; outByte(port:UInt16, val:UInt8) 
global outByte
outByte:
   mov   eax, [esp+8]           ; val
   mov   edx, [esp+4]           ; port
   out   dx, al
   ret   

;;; inByte(port:UInt16) UInt8
global inByte
inByte:
   mov   edx, [esp+4]           ; port
   in    al, dx
   ret   

;;; outWord(port:UInt16, val:UInt16)
global outWord
outWord:
   mov   eax, [esp+8]           ; val
   mov   edx, [esp+4]           ; port
   out   dx, ax
   ret   

;;; inWord(port:UInt16) UInt16
global inWord
inWord:
   mov   edx, [esp+4]           ; port
   in    ax, dx
   ret   

;;; outLong(port:UInt16, val:UInt32)
global outLong
outLong:
   mov   eax, [esp+8]           ; val
   mov   edx, [esp+4]           ; port
   out   dx, eax
   ret   

;;; inLong(port:UInt16) UInt32
global inLong
inLong:
   mov   edx, [esp+4]           ; port
   in    eax, dx
   ret   
