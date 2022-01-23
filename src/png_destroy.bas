#include once "crt.bi"
#include once "png_image.bi"

'::::::::
' Purpose : free the image buffer that came from png_load
' Return  : None
sub png_destroy cdecl alias "png_destroy" _
	( _
		byval buffer as any ptr _
	)

	if buffer = NULL then
		exit sub
	end if

	' Due to the alignment for SSE, the real pointer to be free'd is actually just before the buffer
	deallocate_aligned( buffer )

end Sub
