; header for autostart
                *= $0801
                .word (+),2005                          ; pointer, line number
                .null $9e,format("%4d", start)          ; will be sys 4096
+               .word 0                                 ; basic line end

; set vars
screen          := $0400
color           := $d800
kla_screen      := $3f40
kla_color       := $4328

; load data
                *= $2000
                .binary "multicolorbitmap.kla",2

; run code
                *= $1000

start
                lda $4710
                sta $d020
                sta $d021
                jsr set_graphics_memory_layout
                jsr set_multicolor_bitmap_mode
                ; load .kla image data into screen RAM
                ldx #$00
klaload
                ; load bitmap data
                lda kla_screen,x
                sta screen,x
                lda kla_screen+$100,x
                sta screen+$100,x
                lda kla_screen+$200,x
                sta screen+$200,x
                lda kla_screen+$2e8,x
                sta screen+$2e8,x

                ; load color data
                lda kla_color,x
                sta color,x
                lda kla_color+$100,x
                sta color+$100,x
                lda kla_color+$200,x
                sta color+$200,x
                lda kla_color+$2e8,x
                sta color+$2e8,x
                ; increment x and continue or break loop
                inx
                bne klaload
                rts

set_graphics_memory_layout
                ; from left, 4 bits to select bitmap color area
                ; 0001 = 1 = 1 * 14 = $0400
                ; from right, bit 3 indicates bitmap start address ($0 = cleared, $2000 = set)
	            lda #%00011000
	            sta $d018
	            rts

set_standard_bitmap_mode
                ; (bitmap mode) from right, bit 5 (BMM) set and bit 6 (ECM) cleared
                lda #%00111011
                sta $d011
                ; (standard) from right, bit 4 (MCM) cleared
                lda #%11001000
                sta $d016
                rts

set_multicolor_bitmap_mode
                ; (bitmap mode) from right, bit 5 (BMM) set and bit 6 (ECM) cleared
                lda #%00111011
                sta $d011
                ; (multicolor) from right, bit 4 (MCM) set
                lda #%11011000
                sta $d016
                rts
