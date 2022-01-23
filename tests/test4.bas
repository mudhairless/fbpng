#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


#include once "crt.bi"
#include once "fbpng.bi"
#include once "png_image.bi"

print "This program will crash if your current ImageDestroy function is incompatible with fbpng."
print "Remember, you should always use png_destroy anyway, this is just for some backwards compatibility."
print "Due to using the wrong deallocation function on purpose, this test will also report a leak with fbmld, this can be ignored."

chdir( exepath( ) )

dim as any ptr img1 = png_load( "png/pngsuite_logo.png", PNG_TARGET_FBNEW )

imagedestroy( img1 )

print "The test has passed."
