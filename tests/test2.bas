#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


#include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"

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

dim as string ptr file_list
dim as integer file_count
dim as string file_name
dim as integer i

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

	for i = 0 to file_count - 1
		dim as double t1 = timer( )
		dim as any ptr img1 = png_load( "png/" & file_list[i], PNG_TARGET_FBOLD )
		t1 = timer( ) - t1
		screenlock( )
			if img1 <> NULL then
				dim as integer w = cptr( OLD_HEADER ptr, img1 )->width
				dim as integer h = cptr( OLD_HEADER ptr, img1 )->height
				print "-------------"
				print " file      : " & file_list[i]
				print " width     : " & w
				print " height    : " & h
				print " time (s)  : " & int(t1)
				print " time (ms) : " & int(t1 * 1000)
				print " time (us) : " & int(t1 * 1000000)
				png_destroy( img1 )
			end if
		screenunlock( )
		file_list[i] = ""
	next i

	deallocate( file_list )
