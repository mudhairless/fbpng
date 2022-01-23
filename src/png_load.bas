#include once "file_to_buffer.bi"
#include once "png_image.bi"


#ifndef	PNG_NO_OLD_API


'::::::::
' Purpose : One of the main visible functions, load PNG from file, to a buffer that matches target
' Return  : Pointer to an image buffer on success, NULL on failure
function png_load cdecl alias "png_load" _
	( _
		byref filename as string, _
		byval target   as png_target_e _
	) as any ptr

	dim as any ptr buffer     = any
	dim as integer buffer_len = any

	DEBUGPRINT( "Loading PNG image " & filename)

	buffer = file_to_buffer( strptr( filename ), buffer_len )

	if buffer <> NULL then
		function = png_load_mem( buffer, buffer_len, target )
		deallocate( buffer )
	end if

end function 

'::::::::
' Purpose : One of the main visible functions, load PNG from memory, to a buffer that matches target
' Return  : Pointer to an image buffer on success, NULL on failure
function png_load_mem cdecl alias "png_load_mem" _
	( _
		byval buffer     as any ptr, _
		byval buffer_len as integer, _
		byval target     as png_target_e _
	) as any ptr

	dim as png_image_t      img
        dim as any ptr          outbuffer
        dim as png_cb           cb

        function = NULL

	if (buffer = NULL) or (buffer_len < 49) then ' 49/50 is the bare minimum
		exit function
	end if

        select case target
        	case    PNG_TARGET_FBNEW		: cb = GFXLIB2_NEW_CB
        	case    PNG_TARGET_FBOLD		: cb = GFXLIB2_OLD_CB
        	case    PNG_TARGET_OPENGL		: cb = OPENGL_CB
        	case	else
        		DEBUGPRINT( "Invalid image format" )
        		exit function
        end select

	png_image_init( img, buffer, buffer_len )
	If( png_image_prepare( img ) = 0 )Then
		if( png_image_convert( img, 32, outbuffer, NULL, cb ) = 0 )then function = outbuffer
	End If
	png_image_deinit( img )

end function


#endif
