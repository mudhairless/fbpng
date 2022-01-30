#include once "png_image.bi"


#ifndef	PNG_NO_PALETTE_8


'::::::::
' Purpose : colortype 0 to palette 8
' Return  : none
Sub row_conv_c0_to_p8 cdecl alias "row_conv_c0_to_p8" _
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
		'Dim As long  grey   = 255 \ mask

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			if .bitdepth <> 16 then

				for i = 0 to max

					if x1 < .width then
						c = (*p shr ((max - i) * .bitdepth)) and mask
						'c *= grey
						
						cast( ubyte ptr, out_row )[ x1 ] = c
					end if

					x1 += wfactor
				next i

			else

				cast( ubyte ptr, out_row )[ x1 ] = p[-1]

				x1 += wfactor
			end if
		
		next __x

	End with

end sub

'::::::::
' Purpose : colortype 3 to palette 8
' Return  : none
sub row_conv_c3_to_p8 Cdecl Alias "row_conv_c3_to_p8" _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)

	with png_image

		dim as long  i      = any
		dim as long  max    = (8 \ .bitdepth) - 1
		dim as long  mask   = (2 ^ .bitdepth) - 1

		p -= 1

		for __x as long = 0 to scan_size

			p += .bpp

			for i = 0 to max

				if x1 < .width then
					cast( ubyte ptr, out_row )[ x1 ] = (*p shr ((max - i) * .bitdepth)) and mask
				end if

				x1 += wfactor
			next i

		next __x

	End with

end sub

'::::::::
' Purpose : colortype 4 to palette 8
' Return  : none
sub row_conv_c4_to_p8 Cdecl Alias "row_conv_c4_to_p8" _
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

			cast( ubyte ptr, out_row )[ x1 ] = c

			x1 += wfactor
		next __x

	End with

end sub


#endif
