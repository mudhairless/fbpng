#ifndef _PNG_OPENGL_BI_
#define _PNG_OPENGL_BI_


declare function opengl_cb_create cdecl alias "opengl_cb_create" _
	( _
		ByRef img	As Any Ptr, _
		ByVal w		As long, _
		ByVal h		As long, _
		ByRef bpp       As long, _
		ByVal ct        As long, _
		ByVal bd        As long _
	) as Integer

declare sub opengl_cb_destroy cdecl alias "opengl_cb_destroy" _
	( _
		ByVal img	As Any Ptr _
	)

declare function opengl_cb_img_width cdecl alias "opengl_cb_img_width" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

declare function opengl_cb_img_height cdecl alias "opengl_cb_img_height" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

declare function opengl_cb_img_bpp cdecl alias "opengl_cb_img_bpp" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

declare function opengl_cb_img_format cdecl alias "opengl_cb_img_format" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

Declare function opengl_cb_img_row cdecl alias "opengl_cb_img_row" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As Any Ptr, _
		ByVal row	As long _
	) As Integer

declare function opengl_cb_palette_format cdecl alias "opengl_cb_palette_format" _
	( _
		ByRef result	As long _
	) As Integer


#endif '_PNG_opengl_BI_
