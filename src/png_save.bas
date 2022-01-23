#include "png_image.bi"


#ifndef	PNG_NO_OLD_API


'::::::::
' This should be a lot cleaner....
function png_save cdecl alias "png_save" _
	( _
		byref filename as string, _
		byval img        as any ptr, _
		byval source     as png_target_e _
	) as integer

	dim as FILE ptr		hfile	= Any
	Dim As UInteger		blen	= Any
	Dim As Any ptr		buffer	= Any

	if (img = NULL) or (filename = "") Then return 1

	buffer = png_save_mem( blen, img, source )
	if( buffer = NULL )then return 1

	hfile = fopen( strptr( filename ), "wb" )
	if hfile = NULL Then
		deallocate( buffer )
		DEBUGPRINT( "Could not open file for write" ) 
		return 1
	end if	

	if fwrite( buffer, 1, blen, hfile ) <> blen then
		fclose( hfile )
		deallocate( buffer )
		DEBUGPRINT( "Write failure" ) 
		return 1
	end if

	fclose( hfile )
	deallocate( buffer )

end Function 

'::::::::
' Purpose : One of the main visible functions, save PNG from a buffer to memory
' Return  : Pointer to a memory buffer on success, NULL on failure
function png_save_mem cdecl alias "png_save_mem" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
		ByVal source     as png_target_e _
	) as any ptr

        dim as png_cb           cb

        function = NULL

        select case source
        	case    PNG_TARGET_FBNEW		: cb = GFXLIB2_NEW_CB
        	case    PNG_TARGET_FBOLD		: cb = GFXLIB2_OLD_CB
        	case    PNG_TARGET_OPENGL		: cb = OPENGL_CB
        	case	else
        		DEBUGPRINT( "Invalid image format" )
        		exit function
        end select

	Function = png_image_store( buffer_len, img, cb )

End function


#endif
