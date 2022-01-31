#include once "png_image.bi"
#include once "fbgfx.bi"


#Ifndef	PNG_NO_OLD_API


Function opengl_cb_create cdecl alias "opengl_cb_create" _
	( _
		ByRef img	As Any Ptr, _
		ByVal w		As long, _
		ByVal h		As long, _
		ByRef bpp       As long, _
		ByVal ct        As long, _
		ByVal bd        As long _
	) as Integer

        function = 0

	If( img )Then Return 0

	img = callocate_aligned( (sizeof(any ptr) * 2) + (w * h * 4) )
	if( img = NULL )then function = -1
	cast( long ptr, img )[-2] = w
	Cast( long ptr, img )[-3] = h

end function


sub opengl_cb_destroy cdecl Alias "opengl_cb_destroy" _
	( _
		ByVal img	As Any Ptr _
	)

        if( img )then deallocate_aligned( img )

end sub


function opengl_cb_img_width cdecl alias "opengl_cb_img_width" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        result = Cast( long ptr, img )[-2]

end function


function opengl_cb_img_height cdecl alias "opengl_cb_img_height" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        result = Cast( long ptr, img )[-3]

end function


function opengl_cb_img_bpp cdecl alias "opengl_cb_img_bpp" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        result = 32

end function


function opengl_cb_img_format cdecl alias "opengl_cb_img_format" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        result = ABGR_32

end function


function opengl_cb_img_row cdecl alias "opengl_cb_img_row" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As Any Ptr, _
		ByVal row	As long _
	) As Integer

        function = 0

        if( row < 0 )OrElse( row >= Cast( long ptr, img )[-3] )then Return -1

        result = img + ( cast( long ptr, img )[-3] - row - 1 ) * ( Cast( long ptr, img )[-2] * 4 )

End function


function opengl_cb_palette_format cdecl alias "opengl_cb_palette_format" _
	( _
		ByRef result	As long _
	) As Integer

        function = 0

        result = ABGR_32

end function


#endif
