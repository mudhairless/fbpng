#include once "png_image.bi"

'::::::::
' Purpose : PLTE to RGB16
' Return  : none
Sub pal_conv_rgb16 cdecl alias "pal_conv_rgb16" _
	( _
		byval PLTE       as png_RGB8_t Ptr, _
		byval out_pal    as any ptr _
	)


	For i As Integer = 0 To 255

		Cast( UShort Ptr, out_pal )[ i ] = RGB16( PLTE[ i ].r, PLTE[ i ].g, PLTE[ i ].b )

	Next

end sub

'::::::::
' Purpose : PLTE to RGB32
' Return  : none
Sub pal_conv_rgb32 cdecl alias "pal_conv_rgb32" _
	( _
		byval PLTE       as png_RGB8_t Ptr, _
		byval out_pal    as any ptr _
	)


	For i As Integer = 0 To 255

		Cast( uInteger Ptr, out_pal )[ i ] = RGB32( PLTE[ i ].r, PLTE[ i ].g, PLTE[ i ].b )

	Next

end sub

'::::::::
' Purpose : PLTE to ARGB32
' Return  : none
Sub pal_conv_argb32 cdecl alias "pal_conv_argb32" _
	( _
		byval PLTE       as png_RGB8_t Ptr, _
		byval out_pal    as any ptr _
	)


	For i As Integer = 0 To 255

		Cast( uInteger Ptr, out_pal )[ i ] = ARGB32( PNG_DEFAULT_ALPHA, PLTE[ i ].r, PLTE[ i ].g, PLTE[ i ].b )

	Next

end sub

'::::::::
' Purpose : PLTE to ABGR32
' Return  : none
Sub pal_conv_abgr32 cdecl alias "pal_conv_abgr32" _
	( _
		byval PLTE       as png_RGB8_t Ptr, _
		byval out_pal    as any Ptr _
	)


	For i As Integer = 0 To 255

		Cast( uInteger Ptr, out_pal )[ i ] = ABGR32( PNG_DEFAULT_ALPHA, PLTE[ i ].b, PLTE[ i ].g, PLTE[ i ].r )

	Next

end sub

