' Note: In this file, I have included the declarations for the
'       gfxlib headers, and the zlib functions.  This was because
'       of the problems involved in being 0.16 and 0.17 compatible

#ifndef _PNG_IMAGE_BI_
#define _PNG_IMAGE_BI_

#include "fbpng.bi"
#include "crt.bi"
#include "png_row_conv.bi"
#include "png_pal_conv.bi"

#ifndef NULL
#define NULL cptr( any ptr, 0 )
#endif

#define PNG_DEFAULT_ALPHA 255


#Define RGB16( _r, _g, _b )		(                                     ( ( _r and &b11111000 ) shl  8 ) or ( ( _g and &b11111100 ) shl  3 ) or ( ( _b and &b11111000 ) shr  3 ) )
#Define RGB32( _r, _g, _b )		( (          &hFF000000          ) or ( ( _r and &b11111111 ) shl 16 ) or ( ( _g and &b11111111 ) shl  8 ) or ( ( _b and &b11111111 ) shr  0 ) )
#Define ARGB32( _a, _r, _g, _b )	( ( ( _a and &b11111111 ) shl 24 ) or ( ( _r and &b11111111 ) shl 16 ) or ( ( _g and &b11111111 ) shl  8 ) or ( ( _b and &b11111111 ) shr  0 ) )
#Define ABGR32( _a, _b, _g, _r )	( ( ( _a and &b11111111 ) shl 24 ) or ( ( _b and &b11111111 ) shl 16 ) or ( ( _g and &b11111111 ) shl  8 ) or ( ( _r and &b11111111 ) shr  0 ) )


#define get_u32(p) (((culng( cptr( ubyte ptr, p )[0] ) ) shl 24) _
                 or ((culng( cptr( ubyte ptr, p )[1] ) ) shl 16) _
                 or ((culng( cptr( ubyte ptr, p )[2] ) ) shl 8) _
                 or  (culng( cptr( ubyte ptr, p )[3] ) ))

#define get_u16(p) (((cushort( cptr( ubyte ptr, p )[0] ) ) shl 8) _
                 or  (cushort( cptr( ubyte ptr, p )[1] ) ))

#define IS_CHUNK_TYPE(t,s) (*cptr( ulong ptr, @(t) ) = *cptr( ulong ptr, (s) ))

#ifdef PNG_DEBUG
#define DEBUGPRINT(msg) puts( msg )
#else
#define DEBUGPRINT(msg)
#endif

enum bool_e
	FALSE = 0
	TRUE = not FALSE
end enum

type OLD_HEADER field = 1
	bpp   : 3  as ushort
	width : 13 as ushort
	height     as ushort
end type

type NEW_HEADER field = 1
	union
		old  as OLD_HEADER
		type as ulong
	end union
	bpp                as long
	width              as ulong
	height             as ulong
	pitch              as ulong
	_reserved(1 to 12) as ubyte
end type

type png_chunk_t
	length as ulong
	type   as zstring * 4
	data   as ubyte ptr
	crc32  as ulong
end type

type png_RGB8_t
	r as ubyte
	g as ubyte
	b as ubyte
end type

type png_image_t
' IHDR
	width                   as ulong
	height                  as ulong
	bitdepth                as ubyte
	colortype               as ubyte
	compressionmethod       as ubyte
	filtermethod            as ubyte
	interlacemethod         as ubyte
' PLTE
	PLTE(0 to 255)          as png_RGB8_t
	PLTE_count              as ulong
' IDAT
	IDAT                    as ubyte ptr
	IDAT_len                as ulong
' tRNS
	has_tRNS                as bool_e
	tRNS_3(0 to 255)        as ubyte
	tRNS_0                  as ushort
	tRNS_2r                 as ushort
	tRNS_2g                 as ushort
	tRNS_2b                 as ushort
' Other
	buffer                  as ubyte ptr
	buffer_len              as ulong
	buffer_pos              as ulong
	bpp                     as ulong
	chunk                   as png_chunk_t ptr ptr
	chunk_count             as ulong
	initialized             as bool_e
	prepared                as bool_e
end type 

declare sub png_image_init _
	( _
		byref png_image  as png_image_t, _
		byval buffer     as any ptr, _
		byval buffer_len as uinteger _
	)

declare sub png_image_deinit _
	( _
		byref png_image as png_image_t _
	)

declare Function png_image_prepare _
	( _
		byref png_image as png_image_t _
	) as integer

declare function png_image_convert _
	( _
		byref png_image  as png_image_t, _
		ByVal outbpp     As long, _
		byref outbuffer  as any ptr, _
		byval outpal     as any ptr, _
		byref cb         as png_cb   _
	) as integer

Declare function chunk_find _
	( _
		byref png_image as png_image_t, _
		byval _type_    as zstring ptr, _
		byval start_pos as integer _
	) as integer

declare function calc_scan_size _
	( _
		byref png_image as png_image_t, _
		byval pass      as integer _
	) as integer

declare function png_image_store cdecl alias "png_image_store" _
	( _
		byref buffer_len as integer, _
		byval img        as any ptr, _
		byref cb         as png_cb _
	) as Any ptr


#Ifndef PNG_DEBUG
declare function callocate_aligned cdecl alias "callocate_aligned" _
	( _
		byval size as ulong _
	) as any ptr

declare Sub deallocate_aligned cdecl alias "deallocate_aligned" _
	( _
		byval buffer as any ptr _
	)
#EndIf


Extern as long tb_wfac(1 To 7)
extern as long tb_hfac(1 to 7)
extern as long tb_xoff(1 to 7)
extern as long tb_yoff(1 to 7)
extern as ubyte png_sig(0 to 7)

Extern As sub Cdecl _
	( _
		byref png_image  as png_image_t, _
		byval out_row    as any ptr, _
		byval p          as ubyte ptr, _
		byval x1         as long, _
		byval wfactor    as long, _
		byval scan_size  as long _
	)       conv_row_function( COLORTYPE_0 To COLORTYPE_6, FORMAT_FIRST To FORMAT_LAST + 1 )


Extern As sub Cdecl _
	( _
		byval PLTE       as png_RGB8_t ptr, _
		byval out_pal    as any ptr _
	)       conv_pal_function( FORMAT_FIRST To FORMAT_LAST + 1 )


Type uInt as ulong
type Bytef as Byte
type charf as byte
type intf as long
type uIntf as uInt
type uLongf as uLong
type voidpc as any ptr
type voidpf as any ptr
type voidp as any ptr

extern "c"
declare function compress (byval dest as Bytef ptr, byval destLen as uLongf ptr, byval source as Bytef ptr, byval sourceLen As uLong) as integer
declare function compress2 (byval dest as Bytef ptr, byval destLen as uLongf ptr, byval source as Bytef ptr, byval sourceLen as uLong, byval level as integer) as integer
declare function compressBound (byval sourceLen as uLong) as uLong
declare function uncompress (byval dest as Bytef ptr, byval destLen as uLongf ptr, byval source as Bytef ptr, byval sourceLen as uLong) as integer
declare function crc32 (byval crc as uLong, byval buf as Bytef ptr, byval len as uInt) as uLong
end extern

#endif '_PNG_IMAGE_BI_
