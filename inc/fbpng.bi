#ifndef _PNG_LOAD_BI_
#define _PNG_LOAD_BI_


#ifndef	PNG_STATICZ
	#Inclib "fbpng"
	#Inclib "z"
#else
	#Inclib "fbpngs"
#endif


#ifdef	PNG_DEBUG
	#Include once "fbmld.bi"
#endif


#ifndef	PNG_NO_OLD_API


	#Include Once "fbpng_gfxlib2.bi"
	#Include Once "fbpng_opengl.bi"


	enum png_target_e
		PNG_TARGET_BAD
		PNG_TARGET_FBOLD
		PNG_TARGET_FBNEW
		PNG_TARGET_OPENGL
	#if __FB_MIN_VERSION__( 0, 17, 0 )
	        PNG_TARGET_DEFAULT = PNG_TARGET_FBNEW
	#else
		PNG_TARGET_DEFAULT = PNG_TARGET_FBOLD
	#endif
	end enum

#EndIf


Enum target_format

#ifndef	PNG_NO_PALETTE_8
	PALETTE_8
#elseif	not defined( PNG_NO_OLD_API )
	#Error PNG_NO_PALETTE_8 is only valid if PNG_NO_OLD_API is defined!
#endif

#ifndef	PNG_NO_RGB_16
	RGB_16
#elseif	not defined( PNG_NO_OLD_API )
	#Error PNG_NO_RGB_16 is only valid if PNG_NO_OLD_API is defined!
#endif

#ifndef	PNG_NO_RGB_32
	RGB_32
#elseif	not defined( PNG_NO_OLD_API )
	#Error PNG_NO_RGB_32 is only valid if PNG_NO_OLD_API is defined!
#endif

#ifndef	PNG_NO_ARGB_32
	ARGB_32
#elseif	not defined( PNG_NO_OLD_API )
	#Error PNG_NO_ARGB_32 is only valid if PNG_NO_OLD_API is defined!
#endif

#ifndef	PNG_NO_ABGR_32
	ABGR_32
#elseif	not defined( PNG_NO_OLD_API )
	#Error PNG_NO_ABGR_32 is only valid if PNG_NO_OLD_API is defined!
#endif

#if	defined( PALETTE_8 )
	FORMAT_FIRST	= PALETTE_8
#elseif defined( RGB_16 )
	FORMAT_FIRST	= RGB_16
#elseif defined( RGB_32 )
	FORMAT_FIRST	= RGB_32
#elseif defined( ARGB_32 )
	FORMAT_FIRST	= ARGB_32
#elseif defined( ABGR_32 )
	FORMAT_FIRST	= ABGR_32
#else
	#Error No output formats have been defined!
#endif


#if	defined( ABGR_32 )
	FORMAT_LAST	= ABGR_32
#elseif defined( ARGB_32 )
	FORMAT_LAST	= ARGB_32
#elseif defined( RGB_32 )
	FORMAT_LAST	= RGB_32
#elseif defined( RGB_16 )
	FORMAT_LAST	= RGB_16
#elseif defined( PALETTE_8 )
	FORMAT_LAST	= PALETTE_8
#else
	#Error No output formats have been defined!
#endif


End Enum


Enum png_colorType

	COLORTYPE_0
	COLORTYPE_2	= 2
	COLORTYPE_3
	COLORTYPE_4
	COLORTYPE_6	= 6

End Enum


Enum png_bitDepth

	BITDEPTH_1	= 1
	BITDEPTH_2	= 2
	BITDEPTH_4	= 4
	BITDEPTH_8	= 8 
	BITDEPTH_16	= 16

End Enum


type png_cb
	
	/'
		All functions return the output in "result".  The functions themselves return pass/fail.
		If the function passes (0) the result is valid.  All callbacks must conform to this
		convention.
	'/
	
	as function cdecl _
		( _
			 byref img	as any ptr, _
			 byval w	as long, _
			 byval h	as long, _
			 byref bpp	as long, _
			 byval ct	as long, _
			 byval bd	as long _
		) as integer		create
	
	as sub cdecl _
		( _
			byval img	as any ptr _
		) 			destroy
	
	as function cdecl _
		( _
			byval img	as any ptr, _
			byref result	as long _
		) as integer		img_width
	
	as function cdecl _
		( _
			byval img	as any ptr, _
			byref result	as long _
		) as integer		img_height
	
	as function cdecl _
		( _
			byval img	as any ptr, _
			byref result	as long _
		) as integer		img_bpp
	
	as function cdecl _
		( _
			byval img	as any ptr, _
			byref result	as long _
		) as integer		img_format
	
	as function cdecl _
		( _
			byval img	As any ptr, _
			byref result	as any ptr, _
			byval row	as long _
		) as integer		img_row
	
	as function cdecl _
		( _
			byref result	as long _
		) as integer		palette_format
	
end type


#ifndef	PNG_NO_OLD_API

#define GFXLIB2_NEW_CB	Type<png_cb>( @gfxlib2_cb_create_new, @gfxlib2_cb_destroy, @gfxlib2_cb_img_width, @gfxlib2_cb_img_height, @gfxlib2_cb_img_bpp, @gfxlib2_cb_img_format, @gfxlib2_cb_img_row, @gfxlib2_cb_palette_format )
#define GFXLIB2_OLD_CB	Type<png_cb>( @gfxlib2_cb_create_old, @gfxlib2_cb_destroy, @gfxlib2_cb_img_width, @gfxlib2_cb_img_height, @gfxlib2_cb_img_bpp, @gfxlib2_cb_img_format, @gfxlib2_cb_img_row, @gfxlib2_cb_palette_format )
#define OPENGL_CB	Type<png_cb>( @opengl_cb_create     , @opengl_cb_destroy , @opengl_cb_img_width , @opengl_cb_img_height , @opengl_cb_img_bpp , @opengl_cb_img_format , @opengl_cb_img_row , @opengl_cb_palette_format  )


declare Function png_load cdecl alias "png_load" _
	( _
		byref filename as string, _
		byval target   as png_target_e = PNG_TARGET_DEFAULT _
	) as any ptr

declare function png_load_mem cdecl alias "png_load_mem" _
	( _
		byval buffer     as any ptr, _
		byval buffer_len as integer, _
		byval target     as png_target_e = PNG_TARGET_DEFAULT _
	) as any ptr

declare function png_save cdecl alias "png_save" _
	( _
		byref filename as string, _
		byval img      as any ptr, _
		byval source   as png_target_e = PNG_TARGET_DEFAULT _
	) as integer

declare function png_save_mem cdecl alias "png_save_mem" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
		ByVal source     as png_target_e = PNG_TARGET_DEFAULT _
	) as any ptr

declare Sub png_destroy cdecl alias "png_destroy" _
	( _
		byval buffer as any ptr _
	)
#endif


declare sub png_dimensions cdecl alias "png_dimensions" _
	( _
		byref filename as string, _
		byref w        as ulong, _
		byref h        as ulong _
	)

declare sub png_dimensions_mem cdecl alias "png_dimensions_mem" _
	( _
		byval buffer as any ptr, _
		byref w      as ulong, _
		byref h      as ulong _
	)

declare sub png_pixelformat cdecl alias "png_pixelformat" _
	( _
		byref filename  as string, _
		byref colortype as ulong, _
		byref bitdepth  as ulong _
	)

declare sub png_pixelformat_mem cdecl alias "png_pixelformat_mem" _
	( _
		byref buffer    as any ptr, _
		byref colortype as ulong, _
		byref bitdepth  as ulong _
	)

declare function png_load2 cdecl alias "png_load2" _
	( _
		byref filename as string,  _
		byref img      as any ptr, _
		byval img_bpp  as integer, _
		byref cb       as png_cb,  _
		byval outpal   as any ptr  _
	) as integer

declare function png_load2_mem cdecl alias "png_load2_mem" _
	( _
		byval buffer     as any ptr, _
		byval buffer_len as integer, _
		byref img        as any ptr, _
		byval img_bpp    as integer, _
		byref cb         as png_cb,  _
		byval outpal     as any ptr  _
	) as integer

declare function png_save2 Cdecl alias "png_save2" _
	( _
		byref filename as string, _
		byval img      as any ptr, _
		byref cb       as png_cb,  _
		byval outpal   as any ptr  _
	) as integer

declare function png_save2_mem cdecl alias "png_save2_mem" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
		byref cb         as png_cb,  _
		byval outpal     as any ptr  _
	) as any ptr

#EndIf '_PNG_LOAD_BI_
