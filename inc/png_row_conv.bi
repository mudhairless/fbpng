#Ifndef _png_row_conv_bi
#Define _png_row_conv_bi


Type png_image_t_ As png_image_t


Declare Sub row_conv_c0_to_p8 cdecl alias "row_conv_c0_to_p8" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c0_to_rgb16 cdecl alias "row_conv_c0_to_rgb16" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c0_to_rgb32 cdecl alias "row_conv_c0_to_rgb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c0_to_argb32 cdecl alias "row_conv_c0_to_argb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c0_to_abgr32 cdecl alias "row_conv_c0_to_abgr32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c2_to_rgb16 cdecl alias "row_conv_c2_to_rgb16" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c2_to_rgb32 cdecl alias "row_conv_c2_to_rgb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c2_to_argb32 cdecl alias "row_conv_c2_to_argb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c2_to_abgr32 cdecl alias "row_conv_c2_to_abgr32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c3_to_p8 cdecl alias "row_conv_c3_to_p8" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c3_to_rgb16 cdecl alias "row_conv_c3_to_rgb16" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c3_to_rgb32 cdecl alias "row_conv_c3_to_rgb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c3_to_argb32 cdecl alias "row_conv_c3_to_argb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c3_to_abgr32 cdecl alias "row_conv_c3_to_abgr32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c4_to_p8 cdecl alias "row_conv_c4_to_p8" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c4_to_rgb16 cdecl alias "row_conv_c4_to_rgb16" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c4_to_rgb32 cdecl alias "row_conv_c4_to_rgb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c4_to_argb32 cdecl alias "row_conv_c4_to_argb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c4_to_abgr32 cdecl alias "row_conv_c4_to_abgr32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c6_to_rgb16 cdecl alias "row_conv_c6_to_rgb16" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c6_to_rgb32 cdecl alias "row_conv_c6_to_rgb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c6_to_argb32 cdecl alias "row_conv_c6_to_argb32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


Declare Sub row_conv_c6_to_abgr32 cdecl alias "row_conv_c6_to_abgr32" _
	( _
		byref png_image  as png_image_t_, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)


#EndIf
