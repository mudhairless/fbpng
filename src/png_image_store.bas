#include "png_image.bi"

#define make_u32(n) ((((n) and &h000000ff) shl 24) _
                  or (((n) and &h0000ff00) shl 8) _
                  or (((n) and &h00ff0000) shr 8) _
                  or (((n) and &hff000000) shr 24))

#define put_u32(p, n) *cptr( uinteger ptr, p ) = make_u32(n)

#macro	memwrite( _d, _do, _s, _b )
	memcpy cast( any ptr , ( ( _d ) + ( _do ) ) ), cast( any ptr, ( _s ) ), ( _b )
	_do += _b  
#endmacro

'::::::::
' Purpose : Create and return a memory buffer with a png image in it 
' Return  : Pointer to a memory buffer on success, NULL on failure
function png_image_store cdecl alias "png_image_store" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
		byref cb         as png_cb _
	) as Any ptr

	dim as any ptr          outbuffer
	dim as ulong		boffset
	dim as long		w = any
	dim as long		h = any
	dim as long		bpp = any

        function = NULL

	if( cb.img_width( img, w ) )then
		DEBUGPRINT( "cb.img_width failure" )
		exit function
	endif
	if( cb.img_height( img, h ) )then
		DEBUGPRINT( "cb.img_height failure" )
		exit function
	endif
	if( cb.img_bpp( img, bpp ) )then
		DEBUGPRINT( "cb.img_bpp failure" )
		exit function
	EndIf

	if bpp <> 32 Then
		DEBUGPRINT( "Only 32 bit images allowed" ) 
		exit function
	end if

	buffer_len = _
		/' png_sig '/	8 + _
		/' IHDR '/	25 + _
		/' IDAT '/	12 + _
		/' pixels '/	compressBound( ( ( ( w * 4 ) + 1 ) * h ) ) + _
		/' IEND '/	12

	outbuffer = Allocate( buffer_len )
	if( outbuffer = NULL )then
		DEBUGPRINT( "Allocation failure" ) 
		exit function
	end if
	boffset	= 0

	memwrite( outbuffer, boffset, @png_sig(0), 8 )

	Dim as ubyte IHDR(0 to 24) = {0, 0, 0, 0, asc( "I" ), asc( "H" ), asc( "D" ), asc( "R" )}

	put_u32( @IHDR(0), 13 ) ' Length of data

	put_u32( @IHDR(8), w )
	put_u32( @IHDR(12), h )
	IHDR(16) = 8 ' 8bpp
	IHDR(17) = 6 ' RGBA
	IHDR(18) = 0
	IHDR(19) = 0
	IHDR(20) = 0
	dim as uinteger crc = any
	crc = crc32( 0, @IHDR(4), 4 )
	crc = crc32( crc, @IHDR(8), 13 )
	put_u32( @IHDR(21), crc )

	memwrite( outbuffer, boffset, @IHDR(0), 25 )

	dim as ubyte ptr buffer = allocate( ((w * 4) + 1) * h )

	if buffer = NULL then
		deallocate( outbuffer )
		DEBUGPRINT( "Allocation failure" )
		exit function
	end if

	dim as integer x = 0
	dim as integer y = 0
	dim as ubyte ptr p1 = 0
	dim as ubyte ptr p2 = buffer

	for y = 0 to h - 1
		if( cb.img_row( img, p1, y ) )then
			deallocate( outbuffer )
			deallocate( buffer )
			DEBUGPRINT( "cb.img_row failure" )
			exit function
		endif
		*p2 = 0
		p2 += 1
		for x = 0 to w - 1
			dim as ubyte r, g, b, a
			b = p1[0]
			g = p1[1]
			r = p1[2]
			a = p1[3]
			p2[0] = r
			p2[1] = g
			p2[2] = b
			p2[3] = a
			p1 += 4
			p2 += 4
		next x
	next y
	
	dim as ulong sz = 0
	dim as any ptr cmp = 0

	sz = ((w * 4) + 1) * h
	cmp = Allocate( compressBound( sz ) )

	dim as ulong destlen = compressBound( sz )

	if compress( cmp, @destlen, buffer, sz ) <> 0 then
		deallocate( outbuffer )
		deallocate( buffer )
		deallocate( cmp )
		DEBUGPRINT( "Compress failure" ) 
		exit function
	end if

	deallocate( buffer )

	dim as ubyte IDAT( 0 to 7 ) = {0, 0, 0, 0, asc( "I" ), asc( "D" ), asc( "A" ), asc( "T" )}

	put_u32( @IDAT(0), destlen )

	memwrite( outbuffer, boffset, @IDAT(0), 8 )

	memwrite( outbuffer, boffset, cmp, destlen )

	crc = crc32( 0, @IDAT(4), 4 )
	crc = crc32( crc, cmp, destlen )

	deallocate( cmp )

	put_u32( @IDAT(0), crc )
	
	memwrite( outbuffer, boffset, @IDAT(0), 4 )

	dim as ubyte IEND( 0 to 7 ) = _
	        {0, 0, 0, 0, asc( "I" ), asc( "E" ), asc( "N" ), asc( "D" )}

	memwrite( outbuffer, boffset, @IEND(0), 8 )

	crc = crc32( 0, @IEND(4), 4 )

	put_u32( @IEND(0), crc )

	memwrite( outbuffer, boffset, @IEND(0), 4 )

	if( buffer_len < boffset )Then
		DEBUGPRINT( "ERROR: BUFFER NOT LARGE ENOUGH!  MEMORY CORRUPTION HAS PROBABLY OCCURED!" )
	EndIf
	if( buffer_len > boffset )Then buffer_len = boffset

	Function = outbuffer

End function
