#include "png_image.bi"

'::::::::
' This should be a lot cleaner....
function png_save2 cdecl alias "png_save2" _
	( _
		byref filename as string, _
		byval img      as any ptr, _
                byref cb       as png_cb,  _
                byval outpal   as any ptr  _
	) as integer

	dim as FILE ptr		hfile	= Any
	Dim As UInteger		blen	= Any
	Dim As Any ptr		buffer	= Any

	if (img = NULL) or (filename = "") Then return 1
	if( outpal )then return 1 

	buffer = png_image_store( blen, img, cb )
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
function png_save2_mem cdecl alias "png_save2_mem" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
                byref cb         as png_cb,  _
                byval outpal     as any ptr  _
	) as any ptr

	function = NULL

	if( outpal )then exit function

	Function = png_image_store( buffer_len, img, cb )

End function
