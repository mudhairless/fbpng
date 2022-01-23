#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


#Include once "fbgfx.bi"
#include once "fbpng.bi"

#define ITERS 10

chdir( exepath( ) )

dim as fb.image ptr img1
dim as double t

t = timer( )
for i as integer = 0 to ITERS - 1
	img1 = png_load( "orion-centre-large.png" )
	png_destroy( img1 )
next i
t = timer( ) - t

print "Time taken to load the image " & ITERS & " times: " & int( t * 1000 ) & "ms"

screenres 640, 480, 32

img1 = png_load( "orion-centre-large.png" )
Put(0, 0), img1
png_destroy( img1 )

getkey( )
