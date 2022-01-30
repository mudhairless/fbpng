#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API.
#endif


#Include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"

chdir( exepath( ) )

dim as any ptr img1 = png_load( "png/pngsuite_logo.png", PNG_TARGET_FBNEW )
dim as any ptr img2 = any
dim as ulong w1, w2, h1, h2, x, y, compare_failed

if img1 = NULL then
	print "The test image failed to load"
	end 1
end if

if png_save2( "test_out.png", img1, GFXLIB2_NEW_CB, NULL ) then
	print "The test image failed to save"
	end 1
end if

img2 = png_load( "test_out.png", PNG_TARGET_FBNEW )

if img2 = NULL then
	print "The saved test image failed to load"
	end 1
end if

png_dimensions( "png/pngsuite_logo.png", w1, h1 )
png_dimensions( "test_out.png", w2, h2 )

if (w1 <> w2) or (h1 <> h2) then
	print "The image dimensions did not match"
	end 1
end if

for y = 0 to h1 - 1
	for x = 0 to w1 - 1
		if point( x, y, img1 ) <> point( x, y, img2 ) then
			compare_failed = 1
		end if
	next x
next y

png_destroy( img1 )
png_destroy( img2 )

if compare_failed then
	print "The comparison failed"
	end 1
end if

print "The save test has passed."
