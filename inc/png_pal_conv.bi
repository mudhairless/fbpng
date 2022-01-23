#Ifndef _png_pal_conv_bi
#Define _png_pal_conv_bi


Type png_RGB8_t_ As png_RGB8_t


Declare Sub pal_conv_rgb16 cdecl alias "pal_conv_rgb16" _
	( _
		byval PLTE       as png_RGB8_t_ Ptr, _
		byval out_pal    as any ptr _
	)


Declare Sub pal_conv_rgb32 cdecl alias "pal_conv_rgb32" _
	( _
		byval PLTE       as png_RGB8_t_ Ptr, _
		byval out_pal    as any ptr _
	)


Declare Sub pal_conv_argb32 cdecl alias "pal_conv_argb32" _
	( _
		byval PLTE       as png_RGB8_t_ Ptr, _
		byval out_pal    as any ptr _
	)


Declare Sub pal_conv_abgr32 cdecl alias "pal_conv_abgr32" _
	( _
		byval PLTE       as png_RGB8_t_ Ptr, _
		byval out_pal    as any Ptr _
	)


#EndIf
