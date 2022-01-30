#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


#Include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"
#include once "fbgfx.bi"


Const As UInteger	SCREEN_X	= 640
Const As UInteger	SCREEN_Y	= 480


'::::::::
function cmp_func Cdecl _
	( _
		byval s1 as const any ptr, _
		byval s2 as const any ptr _
	) as long

	if *cptr( string ptr, s1 ) < *cptr( string ptr, s2 ) then
		function = -1
	elseif *cptr( string ptr, s1 ) > *cptr( string ptr, s2 ) then
		function = 1
	else
		function = 0
	end if

end function

'::::::::

dim as string ptr file_list
dim as integer file_count
dim as string file_name
dim as integer i
Dim As Integer lb=-1
Dim As UInteger	SCREEN_BPP

	Print "Bit depth:"
	Print " 1 - 8-bpp Indexed"
	Print " 2 - 16-bpp RGB"
	Print " 3 - 32-bpp ARGB"
	Print " else - exit"
	SCREEN_BPP = Val( Input( 1 ) )

	Select Case SCREEN_BPP
		Case 1 : SCREEN_BPP = 8
		Case 2 : SCREEN_BPP = 16
		Case 3 : SCREEN_BPP = 32
		Case Else : End
	End Select

	chdir( exepath( ) )
	file_name = dir( "png/*.png" )
	while file_name <> ""
		file_count += 1
		file_list = reallocate( file_list, file_count * sizeof( string ) )
		memset( @file_list[file_count - 1], 0, sizeof( string ) )
		file_list[file_count - 1] = file_name
		file_name = dir( )
	wend

	qsort( file_list, file_count, sizeof( string ), @cmp_func )

	ScreenRes SCREEN_X, SCREEN_Y, SCREEN_BPP

	for i = 0 to file_count - 1
		
		dim as FB.IMAGE Ptr	img1
		dim as uinteger		pal( 0 To 255 )
		dim as double		t1 = Any

		For index As Integer = 0 To 255
			pal( index ) = &Hdeadbeef
		Next

		/'
			This next line the the same as this:
			
				img1 = png_load( png/" & file_list[i], PNG_TARGET_FBNEW )
				If( img1 )Then
			
			There is one other addition - it also returns a palette from
			indexed/greyscale pngs as the last arguement.
		'/
		t1 = timer( )
		If( png_load2( "png/" & file_list[i], img1, SCREEN_BPP, GFXLIB2_NEW_CB, @pal( 0 ) ) = 0 )then 
			t1 = timer( ) - t1
			
			
			Dim As UInteger fg = -1, bg = 0
			
			
			If( SCREEN_BPP = 8 )Then
				Dim As UInteger fc, bc
				fc = 0
				bc = -1
				
				For index As Integer = 0 To 1 Shl SCREEN_BPP - 1
					pal( index ) And= &HFCFCFCFC
					pal( index ) Shr= 2
					Palette index, pal( index )
					Dim As uInteger t = _
						Cast( UByte Ptr, @pal( index ) )[ 0 ] + _
						Cast( UByte Ptr, @pal( index ) )[ 1 ] + _
						Cast( UByte Ptr, @pal( index ) )[ 2 ] + _
						Cast( UByte Ptr, @pal( index ) )[ 3 ]
					If t > fc Then
						fg = index
						fc = t
					EndIf
					If t < bc Then
						bg = index
						bc = t
					EndIf
				Next
			End If
			
			
			Dim As Integer w = img1->width
			Dim As Integer h = img1->height
			Dim As Integer b = img1->bpp Shl 3
			
			
			Color fg, bg
			Line( 0, 0 )-( SCREEN_X, SCREEN_Y ), bg, bf
			Line( 0, 0 )-( w+7, h+7 ), fg, bf
			If( b < 16 )Then
				Put( 4, 4 ), img1, PSet
			Else
				Put( 4, 4 ), img1, Alpha
			End If
			Locate 3+h\8, 1 
			Print "-------------"
			Print " file      : " & file_list[i]
			Print " width     : " & w
			Print " height    : " & h
			Print " bpp       : " & b,
			For i As Integer = 0 To 3
				Print Hex( pal( i ), 8 ); " ";
			Next
			Print
			Print " time (s)  : " & int(t1)
			Print " time (ms) : " & int(t1 * 1000)
			Print " time (us) : " & int(t1 * 1000000)
			Dim As Any Ptr pixels = img1+1
			For i As Integer = 0 To IIf( w < 8, w - 1, 7 )
				If( b = 8 )Then
					Print Hex( Cast( UByte Ptr, pixels )[ i ], 2 );
				ElseIf( b = 16 )Then
					Print Hex( Cast( UShort Ptr, pixels )[ i ], 4 );
				ElseIf( b = 32 )Then
					Print Hex( Cast( UInteger Ptr, pixels )[ i ], 8 );
				EndIf
				Print " ";
			Next
			Print
			png_destroy( img1 )
			Sleep
			'Screen 0
		End if
		file_list[i] = ""
	next i

	deallocate( file_list )
