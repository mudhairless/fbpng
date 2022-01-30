#include once "png_image.bi"


#ifndef	PNG_NO_ABGR_32


'::::::::
' Purpose : colortype 0 to abgr 32
' Return  : none
sub row_conv_c0_to_abgr32 Cdecl Alias "row_conv_c0_to_abgr32" _
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
		dim as ubyte    alpha  = any

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth <> 16 then

				for i = 0 to max

					alpha  = PNG_DEFAULT_ALPHA
					
					if x1 < .width then
						c = (*p shr ((max - i) * .bitdepth)) and mask

						if .has_tRNS and (c = .tRNS_0) then
							alpha = 0
						end if

                                                c *= grey
						Alpha  = PNG_DEFAULT_ALPHA

						cast( ulong ptr, out_row )[ x1 ] = ABGR32( alpha, c, c, c )
					end if

					x1 += wfactor
				next i

			else

				c = get_u16( @p[-1] )
				if .has_tRNS and (c = .tRNS_0) then
					alpha = 0
				end if
				c shr= 8

				cast( ulong ptr, out_row )[ x1 ] = ABGR32( alpha, c, c, c )

				x1 += wfactor
			end if

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 2 to abgr 32
' Return  : none
sub row_conv_c2_to_abgr32 Cdecl Alias "row_conv_c2_to_abgr32" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as ubyte    alpha  = any
		dim as ushort   r2     = any
		dim as ushort   g2     = any
		dim as ushort   b2     = any

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			alpha  = PNG_DEFAULT_ALPHA

			if .bitdepth = 8 then
				if .has_tRNS = TRUE then
					if (p[-2] = .tRNS_2r) and (p[-1] = .tRNS_2g) and (p[0] = .tRNS_2b) then
						alpha = 0
					end if
				end if
				cast( ulong ptr, out_row )[ x1 ] = ABGR32( alpha, p[-0], p[-1], p[-2] )
			else
				r2 = get_u16( @p[-5] )
				g2 = get_u16( @p[-3] )
				b2 = get_u16( @p[-1] )
				if .has_tRNS = TRUE then
					if (r2 = .tRNS_2r) and (g2 = .tRNS_2g) and (b2 = .tRNS_2b) then
						alpha = 0
					end if
				end if
				cast( ulong ptr, out_row )[ x1 ] = ABGR32( alpha, b2 shr 8, g2 shr 8, r2 shr 8 )
			end if

			x1 += wfactor
		next __x

	End With

end sub

'::::::::
' Purpose : colortype 3 to abgr 32
' Return  : none
sub row_conv_c3_to_abgr32 Cdecl Alias "row_conv_c3_to_abgr32" _
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
						c = ABGR32( alpha, .b, .g, .r )
					end with
					cast( ulong ptr, out_row )[ x1 ] = c
				End if

				x1 += wfactor
			next i

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 4 to abgr 32
' Return  : none
sub row_conv_c4_to_abgr32 Cdecl Alias "row_conv_c4_to_abgr32"_
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

			cast( ulong ptr, out_row )[ x1 ] = ABGR32( alpha, c, c, c )

			x1 += wfactor
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 6 to abgr 32
' Return  : none
sub row_conv_c6_to_abgr32 Cdecl Alias "row_conv_c6_to_abgr32" _
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
				cast( ulong ptr, out_row )[ x1 ] = ABGR32( p[0], p[-1], p[-2], p[-3] )
			else
				cast( ulong ptr, out_row )[ x1 ] = ABGR32( p[-1], p[-3], p[-5], p[-7] )
			end if

			x1 += wfactor
		next __x

	End with

end sub


#endif
