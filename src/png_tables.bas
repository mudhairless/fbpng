#include once "png_image.bi"


/'
        Color Type to output buffer format conversion function table
        This table must be modified (comment out or add to) to handle
        more/less/other output formats.  One day when fbc properly
        handles preprocessor statements in tables all will be handled
        through definitions in the main include without this need.
'/
Dim Shared As sub Cdecl _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as integer, _
		byval wfactor    as integer, _
		byval scan_size  as integer _
	)       conv_row_function( COLORTYPE_0 To COLORTYPE_6, FORMAT_FIRST To FORMAT_LAST + 1 ) = _
        { _
        /' ct'/ _
        /' 0 '/ { _
        	/' PALETTE_8	'/ @row_conv_c0_to_p8		, _
        	/' RGB_16	'/ @row_conv_c0_to_rgb16	, _
        	/' RGB_32	'/ @row_conv_c0_to_rgb32	, _
        	/' ARGB_32	'/ @row_conv_c0_to_argb32	, _
        	/' ABGR_32	'/ @row_conv_c0_to_abgr32	, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 1 '/ { _
        	/' PALETTE_8	'/ NULL				, _
        	/' RGB_16	'/ NULL				, _
        	/' RGB_32	'/ NULL				, _
        	/' ARGB_32	'/ NULL				, _
        	/' ABGR_32	'/ NULL				, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 2 '/ { _
        	/' PALETTE_8	'/ NULL				, _
        	/' RGB_16	'/ @row_conv_c2_to_rgb16	, _
        	/' RGB_32	'/ @row_conv_c2_to_rgb32	, _
        	/' ARGB_32	'/ @row_conv_c2_to_argb32	, _
        	/' ABGR_32	'/ @row_conv_c2_to_abgr32	, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 3 '/ { _
        	/' PALETTE_8	'/ @row_conv_c3_to_p8		, _
        	/' RGB_16	'/ @row_conv_c3_to_rgb16	, _
        	/' RGB_32	'/ @row_conv_c3_to_rgb32	, _
        	/' ARGB_32	'/ @row_conv_c3_to_argb32	, _
        	/' ABGR_32	'/ @row_conv_c3_to_abgr32	, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 4 '/ { _
        	/' PALETTE_8	'/ @row_conv_c4_to_p8		, _
        	/' RGB_16	'/ @row_conv_c4_to_rgb16	, _
        	/' RGB_32	'/ @row_conv_c4_to_rgb32	, _
        	/' ARGB_32	'/ @row_conv_c4_to_argb32	, _
        	/' ABGR_32	'/ @row_conv_c4_to_abgr32	, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 5 '/ { _
        	/' PALETTE_8	'/ NULL				, _
        	/' RGB_16	'/ NULL				, _
        	/' RGB_32	'/ NULL				, _
        	/' ARGB_32	'/ NULL				, _
        	/' ABGR_32	'/ NULL				, _
        	/' NULL		'/ NULL				  _
        	}, _
        /' 6 '/ { _
        	/' PALETTE_8	'/ NULL				, _
        	/' RGB_16	'/ @row_conv_c6_to_rgb16	, _
        	/' RGB_32	'/ @row_conv_c6_to_rgb32	, _
        	/' ARGB_32	'/ @row_conv_c6_to_argb32	, _
        	/' ABGR_32	'/ @row_conv_c6_to_abgr32	, _
        	/' NULL		'/ NULL				  _
        	} _
        }


/'
        PLTE to output palette format conversion function table
'/
Dim Shared As sub Cdecl _
	( _
		byval PLTE       as png_RGB8_t ptr, _
		byval out_pal    as any ptr _
	)       conv_pal_function( FORMAT_FIRST To FORMAT_LAST + 1 ) = _
        { _
        /' PALETTE_8	'/ NULL			, _
        /' RGB_16	'/ @pal_conv_rgb16	, _
        /' RGB_32	'/ @pal_conv_rgb32	, _
        /' ARGB_32	'/ @pal_conv_argb32	, _
        /' ABGR_32	'/ @pal_conv_abgr32	, _
       	/' NULL		'/ NULL			  _
        }


