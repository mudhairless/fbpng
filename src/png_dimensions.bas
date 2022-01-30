#include once "crt.bi"
#include once "png_image.bi"

sub png_dimensions cdecl alias "png_dimensions" _
	( _
		byref filename as string, _
		byref w        as ulong, _
		byref h        as ulong _
	)
	
	dim as integer i = any
	dim as FILE ptr hfile = fopen( strptr( filename ), "rb" )
	dim as ubyte sig(0 to 7)
	dim as ulong tmp1 = any, tmp2 = any

	w = 0
	h = 0

	if hfile = NULL then
		exit sub
	end if

	if fread( @sig(0), 1, 8, hfile ) <> 8 then
		fclose( hfile )
		exit sub
	end if

	for i = 0 to 7
		if sig(i) <> png_sig(i) then
			fclose( hfile )
			exit sub
		end if
	next i

	if fseek( hfile, &H10, SEEK_SET ) <> 0 then
		fclose( hfile )
		exit sub
	end if
	
	if fread( @tmp1, 1, 4, hfile ) <> 4 then
		fclose( hfile )
		exit sub
	end if

	if fread( @tmp2, 1, 4, hfile ) <> 4 then
		fclose( hfile )
		exit sub
	end if

	w = get_u32( @tmp1 )
	h = get_u32( @tmp2 )

	fclose( hfile )

end sub

sub png_dimensions_mem cdecl alias "png_dimensions_mem" _
	( _
		byval buffer as any ptr, _
		byref w      as ulong, _
		byref h      as ulong _
	)

	dim as integer i = any
	dim as ubyte ptr p = buffer

	w = 0
	h = 0

	for i = 0 to 7
		if p[i] <> png_sig(i) then
			exit sub
		end if
	next i

	w = get_u32( @p[&H10] )
	h = get_u32( @p[&H14] )

end sub
