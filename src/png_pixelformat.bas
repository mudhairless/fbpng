#include once "crt.bi"
#include once "png_image.bi"

sub png_pixelformat cdecl alias "png_pixelformat" _
	( _
		byref filename  as string, _
		byref colortype as uinteger, _
		byref bitdepth  as uinteger _
	)
	
	dim as integer i = any
	dim as FILE ptr hfile = fopen( strptr( filename ), "rb" )
	dim as ubyte sig(0 to 7)
	dim as uinteger tmp1, tmp2

	colortype = 0
	bitdepth = 0

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

	if fseek( hfile, &H18, SEEK_SET ) <> 0 then
		fclose( hfile )
		exit sub
	end if

	if fread( @tmp2, 1, 1, hfile ) <> 1 then
		fclose( hfile )
		exit sub
	end if

	if fread( @tmp1, 1, 1, hfile ) <> 1 then
		fclose( hfile )
		exit sub
	end if

	colortype = tmp1
	bitdepth = tmp2

	fclose( hfile )

end sub

sub png_pixelformat_mem cdecl alias "png_pixelformat_mem" _
	( _
		byref buffer    as any ptr, _
		byref colortype as uinteger, _
		byref bitdepth  As uinteger _
	)

	dim as integer i = any
	dim as ubyte ptr p = buffer

	colortype = 0
	bitdepth = 0

	for i = 0 to 7
		if p[i] <> png_sig(i) then
			exit sub
		end if
	next i

	Var bd = p[&H18]
	Var ct = p[&H19]
	
	colortype = ct
	bitdepth  = bd

end sub
