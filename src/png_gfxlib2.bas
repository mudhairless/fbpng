#include once "png_image.bi"
#include once "fbgfx.bi"


#ifndef	PNG_NO_OLD_API


function gfxlib2_cb_create_new cdecl alias "gfxlib2_cb_create_new" _
	( _
		ByRef img	As Any Ptr, _
		ByVal w		As long, _
		ByVal h		As long, _
		ByRef bpp       As long, _
		ByVal ct        As long, _
		ByVal bd        As long _
	) as Integer

	Dim As uInteger		pitch = Any

        function = -1

	If( img )Then Return 0

	''	Choose a suitable bit depth for the png colorType and BitDepth.
	If( bpp = 0 )Then
		Select case ct
			Case    COLORTYPE_0, COLORTYPE_3
		                bpp = 8
			case    COLORTYPE_2, COLORTYPE_4, COLORTYPE_6
	        	        bpp = 32
			case	Else
				DEBUGPRINT( "Invalid colorType in png" )
				Exit Function
		end Select
	End If

	pitch = ( ( ( bpp Shr 3 ) * w ) + &h1f ) And Not &H1f 

        img = callocate_aligned( SizeOf( FB.IMAGE ) + pitch * h )
        If( img = NULL )Then Exit Function 

	With *Cast( FB.IMAGE Ptr, img )

		.type		= FB.PUT_HEADER_NEW

		.bpp		= bpp Shr 3
		.width		= w
		.height		= h
		.pitch		= pitch

	End With

	function = 0

end function


function gfxlib2_cb_create_old cdecl alias "gfxlib2_cb_create_old" _
	( _
		ByRef img	As Any Ptr, _
		ByVal w		As long, _
		ByVal h		As long, _
		ByRef bpp       As long, _
		ByVal ct        As long, _
		ByVal bd        As long _
	) as Integer

        function = -1

	If( img )Then Return 0

	''	Choose a suitable bit depth for the png colorType and BitDepth.
	If( bpp = 0 )Then
		select case ct
			case    COLORTYPE_0, COLORTYPE_3
		                bpp = 8
			case    COLORTYPE_2, COLORTYPE_4, COLORTYPE_6
		                bpp = 32
			case	Else
				DEBUGPRINT( "Invalid colorType in png" )
				Exit Function
		end Select
	End if

        img = callocate_aligned( SizeOf( FB._OLD_HEADER ) + ( ( bpp Shr 3 ) * w ) * h )
        If( img = NULL )Then Exit Function 

	With *Cast( FB._OLD_HEADER Ptr, img )

		.bpp		= bpp Shr 3
		.width		= w
		.height		= h

	End With

	function = 0

end Function


Sub gfxlib2_cb_destroy cdecl alias "gfxlib2_cb_destroy" _
	( _
		ByVal img	As Any Ptr _
	)

	If( img )Then deallocate_aligned( img )

end sub


Function gfxlib2_cb_img_width cdecl alias "gfxlib2_cb_img_width" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        ImageInfo img, result

end function


function gfxlib2_cb_img_height cdecl alias "gfxlib2_cb_img_height" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        ImageInfo img, , result

end function


function gfxlib2_cb_img_bpp cdecl alias "gfxlib2_cb_img_bpp" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        function = 0

        ImageInfo img, , , result
        result shl= 3 ' <- bytes to bits

end function


function gfxlib2_cb_img_format cdecl alias "gfxlib2_cb_img_format" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As long _
	) As Integer

        dim as long  bpp

        function = 0

        ImageInfo img, , , bpp

        select case bpp
        	case    1       : result = PALETTE_8
        	case    2       : result = RGB_16
        	case    4       : result = ARGB_32
        	case	else	: result = -1 : Function = -1
        end select

end function


function gfxlib2_cb_img_row cdecl alias "gfxlib2_cb_img_row" _
	( _
		ByVal img	As Any Ptr, _
		ByRef result	As Any Ptr, _
		ByVal row	As long _
	) As Integer

        dim as long  height, pitch

        function = 0

        ImageInfo img, , height, , pitch, result
        if( row < 0 )OrElse( row >= height )then return -1

        result += pitch * row

end Function


function gfxlib2_cb_palette_format cdecl alias "gfxlib2_cb_palette_format" _
	( _
		ByRef result	As long _
	) As Integer

        function = 0

        result = ABGR_32

end function


#endif
