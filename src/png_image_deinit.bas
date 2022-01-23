#include once "crt.bi"
#include once "png_image.bi"

'::::::::
' Purpose : Free up memory
' Return  : none
sub png_image_deinit _
	( _
		byref png_image as png_image_t _
	)

	dim as integer i = any

	with png_image
		if .chunk <> NULL then
			for i = 0 to .chunk_count - 1
				deallocate( .chunk[i] )
			next i
			deallocate( .chunk )
		end if
		if .IDAT <> NULL then deallocate( .IDAT )
	end with

end sub
