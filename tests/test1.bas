#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API.
#endif


#Include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"

const as integer scr_width = 600
const as integer scr_height = 350

'::::::::
function cmp_func cdecl _
	( _
		byval s1 as any ptr, _
		byval s2 as any ptr _
	) as integer

	if *cptr( string ptr, s1 ) < *cptr( string ptr, s2 ) then
		function = -1
	elseif *cptr( string ptr, s1 ) > *cptr( string ptr, s2 ) then
		function = 1
	else
		function = 0
	end if

end function

'::::::::
function strip_ext _
	( _
		byref s as string _
	) as string

	dim as integer i = any

	function = s

	for i = len( s ) - 1 to 0 step -1
		if s[i] = asc( "." ) then
			function = left( s, i )
			exit for
		end if
	next i

end function

'::::::::

dim as string ptr file_list
dim as integer file_count
dim as string file_name
dim as integer i, x, y

	screenres scr_width, scr_height, 32

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

	puts( file_count & " files found (should be 157)" )
	puts( "DIR() on 0.16 linux was broken, that will not find all files" )
	puts( "BLOAD on 0.20 used a different alpha method which will cause many images to report a problem, however the png library itself is not affected, only this test program" )
	puts( "3 files should fail to load, they are broken images for testing" )

	for i = 0 to file_count - 1
		dim as any ptr img1 = png_load( "png/" & file_list[i], PNG_TARGET_FBOLD )
		dim as integer compare_failed = 0
		screenlock( )
			line(0, 0)-(scr_width - 1, scr_height - 1), &hFFFFFF, BF
			if img1 <> NULL then
				dim as uinteger w
				dim as uinteger h
				dim as uinteger ct
				dim as uinteger bd
				png_dimensions( "png/" & file_list[i], w, h )
				png_pixelformat( "png/" & file_list[i], ct, bd )
				dim as any ptr img2 = imagecreate( w, h )
				if img2 = NULL then
					puts( "imagecreate failed" )
					end
				end if
				bload "bmp/" & strip_ext( file_list[i] ) & ".bmp", img2
				locate 2, 1
				print " file     : " & file_list[i]
				print " width    : " & w
				print " height   : " & h
				print " colorType: " & ct
				print " bitDepth : " & bd
				png_save( "out/" & file_list[i], img1 )
				put(32, 64), img1, Alpha
				put(32 + w, 64), img2, Alpha
				for y = 0 to h - 1
					for x = 0 to w - 1
						if point( x, y, img1 ) <> point( x, y, img2 ) then
							compare_failed = 1
						end if
					next x
				next y
				png_destroy( img1 )
				imagedestroy( img2 )
			else
				puts( "Fail (load): " & file_list[i] )
			end if
		screenunlock( )
		if compare_failed = 1 then
			puts( "Fail (compare): " & file_list[i] )
			sleep 500, 1
		end if
		file_list[i] = ""
		sleep 25, 1
	next i

	deallocate( file_list )
