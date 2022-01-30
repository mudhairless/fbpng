#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


#include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"

chdir( exepath( ) )

dim as any ptr img1 = png_load( "png/pngsuite_logo.png", PNG_TARGET_FBNEW )

if img1 <> NULL then
	if (cast( uinteger, img1 ) mod 16 = 0) then
		print "The image is correctly aligned to a 16 byte address"
	else
		print "The alignment has failed"
	end if
	png_destroy( img1 )
else
	print "The test image failed to load"
end if
