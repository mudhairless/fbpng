#ifndef _PNG_GFXLIB2_BI_
#define _PNG_GFXLIB2_BI_


declare function gfxlib2_cb_create_new cdecl alias "gfxlib2_cb_create_new" _
	( _
		byref img	as any ptr, _
		byval w		as integer, _
		byval h		as integer, _
		ByRef bpp	as integer, _
		byval ct	as integer, _
		byval bd	as integer _
	) as integer

declare function gfxlib2_cb_create_old cdecl alias "gfxlib2_cb_create_old" _
	( _
		byref img	as any ptr, _
		byval w		as integer, _
		byval h		as integer, _
		byref bpp	as integer, _
		byval ct	as integer, _
		byval bd	as integer _
	) as integer

Declare sub gfxlib2_cb_destroy cdecl alias "gfxlib2_cb_destroy" _
	( _
		byval img	as any ptr _
	)

declare function gfxlib2_cb_img_width cdecl alias "gfxlib2_cb_img_width" _
	( _
		byval img	as any ptr, _
		byref result	as integer _
	) as integer

declare function gfxlib2_cb_img_height cdecl alias "gfxlib2_cb_img_height" _
	( _
		byval img	as any ptr, _
		byref result	as integer _
	) as integer

declare function gfxlib2_cb_img_bpp cdecl alias "gfxlib2_cb_img_bpp" _
	( _
		byval img	as any ptr, _
		byref result	as integer _
	) as integer

declare function gfxlib2_cb_img_format cdecl alias "gfxlib2_cb_img_format" _
	( _
		byval img	as any ptr, _
		byref result	as integer _
	) as integer

Declare function gfxlib2_cb_img_row cdecl alias "gfxlib2_cb_img_row" _
	( _
		byval img	as any ptr, _
		byref result	as any ptr, _
		byval row	as integer _
	) as integer

declare function gfxlib2_cb_palette_format cdecl alias "gfxlib2_cb_palette_format" _
	( _
		byref result	as integer _
	) as integer


#endif '_PNG_GFXLIB2_BI_
