#include once "png_image.bi"


#ifndef	PNG_NO_PALETTE_8


'::::::::
' Purpose : colortype 0 to rgb 16
' Return  : none
sub row_conv_c0_to_rgb16 Cdecl Alias "row_conv_c0_to_rgb16" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as ulong c      = any
		dim as long  i      = any
		dim as long  max    = (8 \ .bitdepth) - 1
		dim as long  mask   = (2 ^ .bitdepth) - 1
		Dim As long  grey   = 255 \ mask

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth <> 16 then

				for i = 0 to max

					if x1 < .width then
						c = (*p shr ((max - i) * .bitdepth)) and mask
						c *= grey

						cast( ushort ptr, out_row )[ x1 ] = RGB16( c, c, c )
					end if

					x1 += wfactor
				next i

			else

				c = get_u16( @p[-1] )
				c shr= 8

				cast( ushort ptr, out_row )[ x1 ] = RGB16( c, c, c )

				x1 += wfactor
			end if
		
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 2 to rgb 16
' Return  : none
sub row_conv_c2_to_rgb16 Cdecl Alias "row_conv_c2_to_rgb16" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth = 8 then
				cast( ushort ptr, out_row )[ x1 ] = RGB16( p[-2], p[-1], p[0] )
			else
				cast( UShort ptr, out_row )[ x1 ] = RGB16( p[-5], p[-3], p[-1] )
			end If

			x1 += wfactor
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 3 to rgb 16
' Return  : none
sub row_conv_c3_to_rgb16 Cdecl Alias "row_conv_c3_to_rgb16" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as ulong c      = any
		dim as long  i      = any
		dim as long  max    = (8 \ .bitdepth) - 1
		dim as long  mask   = (2 ^ .bitdepth) - 1

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			for i = 0 to max

				if x1 < .width then
					c = (*p shr ((max - i) * .bitdepth)) and mask
					with .PLTE(c)
						c = RGB16( .r, .g, .b )
					end with
					Cast( ushort ptr, out_row )[ x1 ] = c
						
				end if

				x1 += wfactor
			next i

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 4 to rgb 16
' Return  : none
sub row_conv_c4_to_rgb16 Cdecl Alias "row_conv_c4_to_rgb16" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as ulong c      = any
		dim as long  i      = any
		dim as long  max    = (8 \ .bitdepth) - 1
		dim as long  mask   = (2 ^ .bitdepth) - 1

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth = 8 then
				c = p[-1]
			else
				c = p[-3]
			end if

			cast( ushort ptr, out_row )[ x1 ] = RGB16( c, c, c )

			x1 += wfactor
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 6 to rgb 16
' Return  : none
sub row_conv_c6_to_rgb16 Cdecl Alias "row_conv_c6_to_rgb16" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth = 8 then
				cast( ushort ptr, out_row )[ x1 ] = RGB16( p[-3], p[-2], p[-1] )
			else
				cast( UShort ptr, out_row )[ x1 ] = RGB16( p[-7], p[-5], p[-3] )
			end if

			x1 += wfactor
		next __x

	End with

end sub


#endif
