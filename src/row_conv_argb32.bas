#include once "png_image.bi"


#ifndef	PNG_NO_ARGB_32


'::::::::
' Purpose : colortype 0 to argb 32
' Return  : none
sub row_conv_c0_to_argb32 Cdecl Alias "row_conv_c0_to_argb32" _
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
		dim as ubyte    alpha  = any
		Dim As long  grey   = 255 \ mask

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth <> 16 then

				for i = 0 to max

					alpha  = PNG_DEFAULT_ALPHA

					if x1 < .width then
						c = (*p shr ((max - i) * .bitdepth)) and mask

						Alpha  = PNG_DEFAULT_ALPHA
						if .has_tRNS and (c = .tRNS_0) then
							alpha = 0
						end if

						c *= grey

						cast( ulong ptr, out_row )[ x1 ] = ARGB32( alpha, c, c, c )
					end if

					x1 += wfactor
				next i

			else

				alpha  = PNG_DEFAULT_ALPHA

				c = get_u16( @p[-1] )
				if .has_tRNS and (c = .tRNS_0) then
					alpha = 0
				end if
				c shr= 8

				cast( ulong ptr, out_row )[ x1 ] = ARGB32( alpha, c, c, c )

				x1 += wfactor
			end if

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 2 to argb 32
' Return  : none
Sub row_conv_c2_to_argb32 Cdecl Alias "row_conv_c2_to_argb32" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as ubyte    alpha  = Any
		Dim As ulong c      = Any
		dim as ushort   r2     = any
		dim as ushort   g2     = any
		dim as ushort   b2     = any

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			alpha  = PNG_DEFAULT_ALPHA

			if .bitdepth = 8 then
				if .has_tRNS = TRUE then
					If (p[-2] = .tRNS_2r) and (p[-1] = .tRNS_2g) and (p[0] = .tRNS_2b) then
						Alpha = 0
					End if
				end If
				c = ARGB32( Alpha, p[-2], p[-1], p[0] )
			Else
				r2 = get_u16( @p[-5] )
				g2 = get_u16( @p[-3] )
				b2 = get_u16( @p[-1] )
				If .has_tRNS = TRUE then
					If (r2 = .tRNS_2r) and (g2 = .tRNS_2g) and (b2 = .tRNS_2b) then
						Alpha = 0
					End if
				end If
				c = ARGB32( alpha, r2 shr 8, g2 shr 8, b2 shr 8 )
			end if

			Cast( ulong ptr, out_row )[ x1 ] = c

			x1 += wfactor
		next __x

	End With

End sub

'::::::::
' Purpose : colortype 3 to argb 32
' Return  : none
sub row_conv_c3_to_argb32 Cdecl Alias "row_conv_c3_to_argb32" _
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
		dim as ubyte    alpha  = any

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			for i = 0 to max

				if x1 < .width then
					c = (*p shr ((max - i) * .bitdepth)) and mask
					alpha = PNG_DEFAULT_ALPHA
					if .has_tRNS then
						alpha = .tRNS_3(c)
					end if
					with .PLTE(c)
						c = ARGB32( alpha, .r, .g, .b )
					end with
					cast( ulong ptr, out_row )[ x1 ] = c
						
				end if

				x1 += wfactor
			next i

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 4 to argb 32
' Return  : none
sub row_conv_c4_to_argb32 Cdecl Alias "row_conv_c4_to_argb32" _
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
		dim as ubyte    alpha  = any

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth = 8 then
				c = p[-1]
				alpha = p[0]
			else
				c = p[-3]
				alpha = p[-1]
			end if

			cast( ulong ptr, out_row )[ x1 ] = ARGB32( alpha, c, c, c )

			x1 += wfactor
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 6 to argb 32
' Return  : none
sub row_conv_c6_to_argb32 Cdecl Alias "row_conv_c6_to_argb32" _
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
				cast( ulong ptr, out_row )[ x1 ] = ARGB32( p[0], p[-3], p[-2], p[-1] )
			else
				cast( ulong ptr, out_row )[ x1 ] = ARGB32( p[-1], p[-7], p[-5], p[-3] )
			end if

			x1 += wfactor
		next __x

	End with

end sub


#endif
