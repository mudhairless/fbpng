#include once "file_to_buffer.bi"
#include once "png_image.bi"

'::::::::
' Purpose : One of the main visible functions, load PNG from file, to a buffer that matches target
' Return  : Pointer to an image buffer on success, NULL on failure
function png_load2 cdecl alias "png_load2" _
	( _
		byref filename   As string,  _
		byref target     as any Ptr, _
		byval target_bpp as integer, _
                byref cb         As png_cb,  _
                byval outpal     as any ptr  _
	) as integer

	dim as any ptr buffer     = any
	dim as integer buffer_len = any

	function = -1

	DEBUGPRINT( "Load2ing PNG image " & filename)

	buffer = file_to_buffer( strptr( filename ), buffer_len )

	if buffer <> NULL then
		function = png_load2_mem( buffer, buffer_len, target, target_bpp, cb, outpal )
		deallocate( buffer )
	end if

end function 

'::::::::
' Purpose : One of the main visible functions, load PNG from memory, to a buffer that matches target
' Return  : Pointer to an image buffer on success, NULL on failure
function png_load2_mem cdecl alias "png_load2_mem" _
	( _
		byval buffer     as any ptr, _
		byval buffer_len as integer, _
		byref target     as any ptr, _
		byval target_bpp as integer, _
                byref cb         as png_cb,  _
                byval outpal     as any ptr  _
	) as integer

	dim as png_image_t img

	function        = -1

        if (buffer = NULL) or (buffer_len < 49) then ' 49/50 is the bare minimum
		exit function
	end if

	png_image_init( img, buffer, buffer_len )
	If( png_image_prepare( img ) = 0 )Then
		function = png_image_convert( img, target_bpp, target, outpal, cb )
	End If
	png_image_deinit( img )


end function
