  FreeBASIC PNG Library (v3.2.z)
  =

  Copyright (C) 2007-2010 Simon Nash/Eric Cowles
  
  Copyright (C) 2022 Ebben Feagan

  zlib code (C) 1995-2017 Jean-loup Gailly and Mark Adler

  See license.txt and zlib/zlib.h for more information.

  This library provides easy to use functions for using PNG images in your FreeBASIC
  programs.  The functions provide a way to load PNG images to old or new style PUT buffers
  and also in a format ready for use with OpenGL.  Images can be loaded from file, or 
  memory buffer.




  Compiling
  ==

  In order to compile you need GNU make, FreeBASIC 0.20 or newer, and GCC if you wish to
  compile in the zlib.  Just type 'make' in the main directory to make the default build.
  
  Options:
  ```
	'STATICZ=1'		Include static zlib
	'DEBUG=1'		Include memory leak detector
	'PROFILE=1'		Profile library
	'EXX=1'			Full debug support
	'PNG_NO_OLD_API=1'	No "version 1" api
	'PNG_NO_PALETTE_8=1'	No 8-bit palette target
	'PNG_NO_RGB_16=1'	No 16-bit rgb target
	'PNG_NO_RGB_32=1'	No 32-bit rgb target
	'PNG_NO_ARGB_32=1'	No 32-bit argb target
	'PNG_NO_ABGR_32=1'	No 32-bit abgr target
```

  Notes for users of previous versions (before and including v3.2.z)
  ==

  The changes for this version are as follows:
  1)  64-bit and modern FreeBASIC compiler (1.07+ tested) support



  Notes for users of previous versions (before and including v3.2.q)
  ==

  The changes for this version are as follows:
  1)  Added memory save function to save to a memory image (png_save_mem creates and returns a memory pointer).
  2)  Added pixel format functions to return the color type and bit depth of a png.
  3)  Added "version 2" load, save functions which are more low-level and can be used by any graphics library
      via the use of callbacks.
  4)  Updated conversion code to make conversion from any png to (almost) any image format possible. Total
      output pixel formats include PALETTE_8, RGB_16, RGB_32, ARGB_32, ABGR_32.  "Version 1" functions
      only support ARGB_32 and ABGR_32.
  5)  Internal function tables are used to streamline the decode sequence resulting in a 20% speed increase.




  Notes for users of previous versions (before and including v1.9.3)
  ==

  The changes for this version are as follows:
  1)  The prebuilt windows static zlib version was bugged in v1.9.3 due to a misbuild.  That is now rectified.
  2)  Static versions of the library are now built under a new name, 'libfbpngs.a'.  This will mean you can keep
      both in your FreeBASIC lib/ directory without having any clashes as it takes precedence.  Hopefully this
      will help stop a lot of the problems people had using the static version.
  3)  A lot of code has been changed in png_image_convert.bas in order to improve it's efficiency.  I am seeing
      around 40% faster times on my machine.




  Notes for users of previous versions (before and including v1.9.2)
  ==

  The changes for this version are as follows:
  1)  A bug was found, and fixed in the PNG dimensions code thanks to user dreamerman.  This bug affected
      users who called png_dimensions many times.
  2)  Some new logic has been added to set the default image type based on the FB version has been added
      thanks to 1000101.  It now detects if you are using <= 0.17, and will use the old image format,
      otherwise it will use the new image format.  This means that for most users who will be using 0.20 FBC
      the default has changed.  It won't effect many people though I hope, as most of those will be using
      the new image format anyway, and it's only people who do more low level stuff with the buffer who will
      be negatively affected.  If you find your program misbehaves with the new version of FBPNG, then try
      specifying PNG_TARGET_FBOLD in your png_load calls.




  Notes for users of previous versions (before and including v1.9.1)
  ==

  fbpng has now been modified, so that it will work with the version of ImageDestroy that
  that comes with FB 0.21. However, YOU SHOULD NOT USE IMAGEDESTROY.  This addition is
  partly a compatibility patch to help people out, you should be using png_destroy instead
  in order to be as future-proof as possible.  This change means that you cannot use ImageDestroy
  anymore if you are using FB 0.20.  You should either update your code to use png_destroy, or
  just carry on using your old version of fbpng.  Also, if you plan to use the STATICZ version
  you should do;
  
	#define PNG_STATICZ 1
	#include "fbpng.bi"
	
  in your program, as otherwise it will still try to link to a dynamic version of zlib.  Thank
  you to Z!re for making me aware of this.
  
  The major change for this version of fbpng, is that buffers created by fbpng will now be
  aligned in memory to a multiple of 16 bytes, this is to match the change in the FB 0.21 
  ImageCreate/Destroy functions, which now also do the same, and allows users who know SSE to
  be able to use it more effectively.  Thanks to {1000101} for helping me out with the method
  that this uses, and to counting_pine, whose patch I modified and incorperated.




  Notes for users of previous versions (before and including v1.9.0)
  ==

  Since version 0.21.0 of FreeBASIC you can no longer use ImageDestroy to free the
  memory used by a png image, you should now use the new png_destroy() sub for this
  purpose.




  Notes for users of previous versions (before v1.8.4)
  ==

  The librarys interface has changed, due to the new target parameter, and the old
  redundant target depth has been removed, the library always returns a 32 bit image.
  There is also now no error global variable, however if you compile with make DEBUG=1
  then much debugging info will be printed to the console.




  Usage
  ==

  Once compiled you will need two files, 'build/libfbpng.a' and 'inc/fbpng.bi'.  These
  should be placed either in your projects directory, or in the lib/ and inc/ dirs of your
  FreeBASIC installation, along with the other libary and header files.  On Linux the
  correct directories are likely to be /usr/include/freebasic/ and /usr/lib/freebasic/linux/

  There are 13 functions for users, details are given here:

  ------------------------------------------------------

  For those functions that accept a target, the following are the allowed values

  For an old style FreeBASIC buffer, as used in older versions of FB
	PNG_TARGET_FBOLD

  For a new style FreeBASIC buffer, as used in the newer versions of FB
	PNG_TARGET_FBNEW

  For a buffer that is ready to be used with OpenGL
	PNG_TARGET_OPENGL

  For a buffer that is suitable for the version of FB in use.
	PNG_TARGET_DEFAULT

  ------------------------------------------------------

	declare function png_load cdecl alias "png_load" _
		( _
			byref filename as string, _
			byval target   as png_target_e = PNG_TARGET_DEFAULT _
		) as any ptr

  The filename parameter should be obvious, something like "foo.png"
  The target parameter is one of the values listed above, ie PNG_TARGET_FBOLD

  The return value will be a pointer to a buffer that contains the image in the format
  specified by target.  The returned buffer will always be a 32-bit image.

  If the function fails, then the return will be NULL

  It is the users responsibity to free the returned image when finished with, using
  the normal DEALLOCATE/free

  Example

	dim as any ptr img
	screenres 640, 480, 32
	img = png_load( "test.png" )
	if img <> NULL then
		put( 0, 0 ), img
		png_destroy( img )
	else
		print "Failed to load"
	end if

  ------------------------------------------------------

	declare function png_load_mem cdecl alias "png_load_mem" _
		( _
			byval buffer     as any ptr, _
			byval buffer_len as integer, _
			byval target     as png_target_e = PNG_TARGET_DEFAULT _
		) as any ptr

  The buffer parameter is a pointer to a memory location that holds a PNG image
  The buffer_len parameter is the size of this buffer, ie the files size
  The target parameter is one of the values listed above, ie PNG_TARGET_FBOLD

  The return value will be a pointer to a buffer that contains the image in the format
  specified by target.  The returned buffer will always be a 32-bit image.

  If the function fails, then the return will be NULL

  It is the users responsibity to free the returned image when finished with, using
  png_destroy

  ------------------------------------------------------

	declare function png_save cdecl alias "png_save" _
		( _
			byref filename as string, _
			byval img      as any ptr, _
			byval source   as png_target_e = PNG_TARGET_DEFAULT _
		) as integer

  The filename parameter should be obvious, something like "foo.png"
  The img parameter is a pointer to either a new or old style FreeBASIC buffer,
  it must be in ARGB_32 format.
  The source parameter tells the library what the img format it, the default depends
  on what version of fbc you are using, either PNG_TARGET_FBOLD for 0.17 or older and
  PNG_TARGET_FBNEW for newer.

  The return value will be 0 (zero) on success, and non zero otherwise

  ------------------------------------------------------

	declare function png_save_mem cdecl alias "png_save_mem" _
		( _
			byref buffer_len as integer, _
			byval img        as any ptr, _
			byval source     as png_target_e = PNG_TARGET_DEFAULT _
		) as any ptr

  The buffer_len parameter is the size of the return buffer, note byref
  The img parameter is a pointer to either a new or old style FreeBASIC buffer,
  it must be in ARGB_32 format.
  The source parameter tells the library what the img format it, the default depends
  on what version of fbc you are using, either PNG_TARGET_FBOLD for 0.17 or older and
  PNG_TARGET_FBNEW for newer.

  The return value will be a valid pointer on success, and zero otherwise

  ------------------------------------------------------

	declare sub png_dimensions cdecl alias "png_dimensions" _
		( _
			byref filename as string, _
			byref w        as uinteger, _
			byref h        as uinteger _
		)

  The filename parameter should be obvious, something like "foo.png"
  The w and h parameters (note the byref) are how the dimensions are returned

  If the sub fails, then then w and h will be zero

  Example

	dim as uinteger w, h
	png_dimensions( "test.png", w, h )
	print w, h

  ------------------------------------------------------

	declare sub png_dimensions_mem cdecl alias "png_dimensions_mem" _
		( _
			byval buffer as any ptr, _
			byref w      as uinteger, _
			byref h      as uinteger _
		)

  The buffer parameter is a pointer to a memory location that holds a PNG image
  The w and h parameters (note the byref) are how the dimensions are returned

  If the sub fails, then then w and h will be zero

  ------------------------------------------------------

	declare sub png_destroy cdecl alias "png_destroy" _
		( _
			byval buffer as any ptr _
		)

  The buffer parameter is a pointer to a memory location that holds a PNG image

  This sub should be used to deallocate the memory allocated by png_load or
  png_load_mem

  ------------------------------------------------------

	declare sub png_pixelformat cdecl alias "png_pixelformat" _
		( _
			byref filename  as string, _
			byref colortype as uinteger, _
			byref bitdepth  as uinteger _
		)

  The filename parameter should be obvious, something like "foo.png"
  The colortype and bitdepth parameters (note the byref) are how the dimensions are
  returned

  If the sub fails, then then colortype and bitdepth will be zero

  ------------------------------------------------------

	declare sub png_pixelformat_mem cdecl alias "png_pixelformat_mem" _
		( _
			byref buffer    as any ptr, _
			byref colortype as uinteger, _
			byref bitdepth  as uinteger _
		)

  The buffer parameter is a pointer to a memory location that holds a PNG image
  The colortype and bitdepth parameters (note the byref) are how the dimensions are
  returned

  If the sub fails, then then colortype and bitdepth will be zero

  ------------------------------------------------------

	declare function png_load2 cdecl alias "png_load2" _
		( _
			byref filename as string,  _
			byref img      as any ptr, _
			byval img_bpp  as integer, _
			byref cb       as png_cb,  _
			byval outpal   as any ptr  _
		) as integer

  The filename parameter should be obvious, something like "foo.png"
  The img parameter is pointer to be filled with the png image, it is created and
  validated by cb.create. Note, you can pass an already valid image and cb.create should
  validate it without creating a new image.
  The img_bpp perameter is the images bits per pixel, valid values are graphics library
  dependant.  Typical values are 0 (do not force bit depth), 8, 16, 32
  The cb parameter are the callbacks to use for loading the png, png_cb is explained
  later in this document.
  The outpal parameter is an optional pointer to a palette, this pointer must be large
  enough to hold the entire palette for the png.  Palettes are only returned for indexed
  and greyscale images.

  The return value will be 0 (zero) on success, and non zero otherwise

  It is the users responsibity to free the returned image when finished with, this
  should be done using the graphics libraries function to free images and not png_destroy

  Example

	dim as any ptr img
	screenres 640, 480, 32
	img = png_load2( "test.png", img, 32, GFXLIB2_NEW_CB )
	if img <> NULL then
		put( 0, 0 ), img
		imagedestroy( img )
	else
		print "Failed to load"
	end if

  ------------------------------------------------------

	declare function png_load2_mem cdecl alias "png_load2_mem" _
		( _
			byval buffer     as any ptr, _
			byval buffer_len as integer, _
			byref img        as any ptr, _
			byval img_bpp    as integer, _
			byref cb         as png_cb,  _
			byval outpal     as any ptr  _
		) as integer

  The buffer parameter is a pointer to a memory location that holds a PNG image
  The buffer_len parameter is the size of this buffer, ie the files size
  The img parameter is pointer to be filled with the png image, it is created and
  validated by cb.create. Note, you can pass an already valid image and cb.create should
  validate it without creating a new image.
  The img_bpp perameter is the images bits per pixel, valid values are graphics library
  dependant.  Typical values are 0 (do not force bit depth), 8, 16, 32
  The cb parameter are the callbacks to use for loading the png, png_cb is explained
  later in this document.
  The outpal parameter is an optional pointer to a palette, this pointer must be large
  enough to hold the entire palette for the png.  Palettes are only returned for indexed
  and greyscale images.

  The return value will be 0 (zero) on success, and non zero otherwise

  It is the users responsibity to free the returned image when finished with, this
  should be done using the graphics libraries function to free images and not png_destroy

  ------------------------------------------------------

	declare function png_save2 cdecl alias "png_save2" _
		( _
			byref filename as string, _
			byval img      as any ptr, _
			byref cb       as png_cb,  _
			byval outpal   as any ptr  _
		) as integer

  The filename parameter should be obvious, something like "foo.png"
  The img parameter is a pointer to a valid image, it must be in ARGB_32 format.
  The cb parameter are the callbacks to use for saving the png, png_cb is explained
  later in this document.
  The outpal parameter is an optional pointer to a palette, this is for future use
  and must be NULL

  The return value will be 0 (zero) on success, and non zero otherwise

  ------------------------------------------------------

	declare function png_save2_mem cdecl alias "png_save2_mem" _
		( _
			byref buffer_len as integer, _
			byval img        as any ptr, _
			byref cb         as png_cb,  _
			byval outpal     as any ptr  _
		) as any ptr

  The buffer_len parameter is the size of the return buffer, note byref
  The img parameter is a pointer to a valid image, it must be in ARGB_32 format.
  The cb parameter are the callbacks to use for saving the png, png_cb is explained
  later in this document.
  The outpal parameter is an optional pointer to a palette, this is for future use
  and must be NULL

  The return value will be a valid pointer on success, and zero otherwise




  Notes for advanced users
  ==

  This section covers advanced topics for using fbpng with any graphics library through
  the use of a callback structure.  The library can used in it's full form or be rebuilt
  with a few definitions for any graphics library.

  If you choose to rebuild the library with a different set of output targets it is very
  important to update png_image_convert.bas  This contains the tables used to choosing
  the image decoders.  At this time fbc (0.20b) does not support preprocessor statements
  in the generation of static tables.  If this changes in the future then you will not have
  to modify the library source.

  ------------------------------------------------------

	#define	PNG_STATICZ
	#include "fbpng.bi"

  This will include the static zlib build of fbpng.  This removes the dependency
  on an external dynamic library for your program.

  ------------------------------------------------------

	#define	PNG_DEBUG
	#include "fbpng.bi"

  This will use a memory leak detector which will aid in the debugging and management
  of images and other user allocated memory resources.

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#include "fbpng.bi"

  This completely disables access to fbpng "version 1" and earlier load and store
  API functions.

  Invalidates:
	png_load, png_load_mem, png_save, png_save_mem, png_destroy
	GFXLIB2_NEW_CB, GFXLIB2_OLD_CB, OPENGL_CB

  Validates:
	PNG_NO_PALETTE_8, PNG_NO_RGB_16, PNG_NO_RGB_32, PNG_NO_ARGB_32, PNG_NO_ABGR_32

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#define	PNG_NO_PALETTE_8
	#include "fbpng.bi"

  Forces the exclusion of 8-bit paletted targets.
  Requires fbpng rebuilt with same settings.
  

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#define	PNG_NO_RGB_16
	#include "fbpng.bi"

  Forces the exclusion of 16-bit RGB targets.
  Requires fbpng rebuilt with same settings.

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#define	PNG_NO_RGB_32
	#include "fbpng.bi"

  Forces the exclusion of 32-bit RGB targets.
  Requires fbpng rebuilt with same settings.

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#define	PNG_NO_ARGB_32
	#include "fbpng.bi"

  Forces the exclusion of 32-bit ARGB targets.
  Requires fbpng rebuilt with same settings.

  ------------------------------------------------------

	#define	PNG_NO_OLD_API
	#define	PNG_NO_ABGR_32
	#include "fbpng.bi"

  Forces the exclusion of 32-bit ABGR targets.
  Requires fbpng rebuilt with same settings.




  png_cb
  ===

	type png_cb
		
		/'
			All functions return the output in "result".  The functions themselves return pass/fail.
			If the function passes (0) the result is valid.  All callbacks must conform to this
			convention.
		'/
		
		as function cdecl _
			( _
				 byref img	as any ptr, _
				 byval w	as integer, _
				 byval h	as integer, _
				 byref bpp	as integer, _
				 byval ct	as integer, _
				 byval bd	as integer _
			) as integer		create
		
		as sub cdecl _
			( _
				byval img	as any ptr _
			)			destroy
		
		as function cdecl _
			( _
				byval img	as any ptr, _
				byref result	as integer _
			) as integer		img_width
		
		as function cdecl _
			( _
				byval img	as any ptr, _
				byref result	as integer _
			) as integer		img_height
		
		as function cdecl _
			( _
				byval img	as any ptr, _
				byref result	as integer _
			) as integer		img_bpp
		
		as function cdecl _
			( _
				byval img	as any ptr, _
				byref result	as integer _
			) as integer		img_format
		
		as function cdecl _
			( _
				byval img	as any ptr, _
				byref result	as any ptr, _
				byval row	as integer _
			) as integer		img_row
		
		as function cdecl _
			( _
				byref result	as integer _
			) as integer		palette_format
		
	end type

  See png_gfxlib2.bas and png_opengl.bas

  ------------------------------------------------------

	declare function png_cb_create cdecl alias "png_cb_create" _
		( _
			 byref img	as any ptr, _
			 byval w	as integer, _
			 byval h	as integer, _
			 byref bpp	as integer, _
			 byval ct	as integer, _
			 byval bd	as integer _
		) as integer

  The img parameter is a pointer to an image, this function will either validate
  a pointer passed or on NULL create a valid pointer
  The w and h parameters are the width and height of the png
  The bpp parameter is the requested image bit depth, if it is non-zero then the
  image should be validated to be that bit depth or created with that bit depth.
  The ct and bd parameters are the png colortype and bit depth, these can be used
  if the bpp parameter is zero (0) and the img parameter is NULL to decide what
  bit depth and format to create the return image.

  This function will return zero (0) and valid values for img and result on success
  or non zero on failure

  ------------------------------------------------------

	declare sub png_cb_destroy cdecl alias "png_cb_destroy" _
		( _
			byval img	as any ptr _
		)

  The img parameter is a pointer to a valid image to be free'd, if the image is valid
  then this function shall free the resources for the image

  ------------------------------------------------------

	declare function png_cb_img_width cdecl alias "png_cb_img_width" _
		( _
			byval img	as any ptr, _
			byref result	as integer _
		) as integer

  The img parameter is a pointer to a valid image
  The result parameter will return a valid width in pixels of the image
  
  This function will return zero (0) and valid values for result on success
  or non zero on failure

  ------------------------------------------------------

	declare function png_cb_img_height cdecl alias "png_cb_img_height" _
		( _
			byval img	as any ptr, _
			byref result	as integer _
		) as integer

  The img parameter is a pointer to a valid image
  The result parameter will return a valid height in rows of the image
  
  This function will return zero (0) and valid values for resulton success  and
  or non zero on failure

  ------------------------------------------------------

	declare function png_cb_img_bpp cdecl alias "png_cb_img_bpp" _
		( _
			byval img	as any ptr, _
			byref result	as integer _
		) as integer

  The img parameter is a pointer to a valid image
  The result parameter will return the valid bit depth of the image, valid values are
  8, 16 and 32
  
  This function will return zero (0) and valid values for result on success
  or non zero on failure

  ------------------------------------------------------

	declare function png_cb_img_format cdecl alias "png_cb_img_format" _
		( _
			byval img	as any ptr, _
			byref result	as integer _
		) as integer

  The img parameter is a pointer to a valid image
  The result parameter will return the valid pixel format of the image, valid values
  are PALETTE_8, RGB_16, RGB_32, ARGB_32, ABGR_32
  
  This function will return zero (0) and valid values for result on success
  or non zero on failure

  ------------------------------------------------------

	declare function png_cb_img_row cdecl alias "png_cb_img_row" _
		( _
			byval img	as any ptr, _
			byref result	as any ptr, _
			byval row	as integer _
		) as integer

  The img parameter is a pointer to a valid image
  The result parameter will return a valid pointer to the first pixel of the row in
  the image
  
  This function will return zero (0) and valid values for result on success
  or non zero on failure

  ------------------------------------------------------

	declare function png_cb_palette_format cdecl alias "png_cb_palette_format" _
		( _
			byref result	as integer _
		) as integer

  The result parameter will return the valid palette format, valid values
  are RGB_16, RGB_32, ARGB_32, ABGR_32
  
  This function will return zero (0) and valid values for result on success
  or non zero on failure

  ------------------------------------------------------

	#define GFXLIB2_NEW_CB	Type<png_cb>( @gfxlib2_cb_create_new, @gfxlib2_cb_destroy, @gfxlib2_cb_img_width, @gfxlib2_cb_img_height, @gfxlib2_cb_img_bpp, @gfxlib2_cb_img_format, @gfxlib2_cb_img_row, @gfxlib2_cb_palette_format )

  This is a simple type definition for simple access to the internal gfxlib2 callbacks
  for the fbc 0.17 and newer image format.  It is intended to be used with "version 2"
  load and store functions and used internally by the library.

  ------------------------------------------------------

	#define GFXLIB2_OLD_CB	Type<png_cb>( @gfxlib2_cb_create_old, @gfxlib2_cb_destroy, @gfxlib2_cb_img_width, @gfxlib2_cb_img_height, @gfxlib2_cb_img_bpp, @gfxlib2_cb_img_format, @gfxlib2_cb_img_row, @gfxlib2_cb_palette_format )

  This is a simple type definition for simple access to the internal gfxlib2 callbacks
  for the fbc 0.16 and older image format.  It is intended to be used with "version 2"
  load and store functions and used internally by the library.

  ------------------------------------------------------

	#define OPENGL_CB	Type<png_cb>( @opengl_cb_create     , @opengl_cb_destroy , @opengl_cb_img_width , @opengl_cb_img_height , @opengl_cb_img_bpp , @opengl_cb_img_format , @opengl_cb_img_row , @opengl_cb_palette_format  )

  This is a simple type definition for simple access to the internal opengl callbacks
  It is intended to be used with "version 2" load and store functions and used internally
  by the library.
  
  The opengl create function (and png_load[_mem]) creates a buffer with the following
  structure:

	base_pointer	= cptr( any ptr ptr, img )[ -1 ]
	width		= cptr( integer ptr, img )[ -2 ]
	height		= cptr( integer ptr, img )[ -3 ]
	abgr_pixels	= cptr( integer ptr, img )[ 0... ]




  Credits
  ==

  Technical credits:

    victor for the FreeBASIC compiler, and the rest of the team for their work on it.
  
    The creators of the PNG format, and the RFC that was very useful for me.
    Willem van Schaik for the pngsuite of testing images.

    The creators of zlib, for the compression, and decompression routines.
  
    counting_pine, for one line of code that has since been eliminated, but was
      very helpful at the time, and also for the base FB code I modified for the SSE
      patch to fbpng.  It's my modified version, so if anyone finds any bug in that part
      don't hassle him about it. :P

    DrV for the memory leak detector

    Coderjeff and others for the Wiki manual

    The makers of all the other tools I use, especially GDB, valgrind, gcc, fasm, make

    cha0s, nkk and sir_mud for building the windows prebuilt version in some versions of fbpng

    1000101 for default image format logic, and the work on 3.2.q

    Dr_D for the OpenGL test program.

    Other bug reporters.

  General greetings:

    All FreeBASIC users, especially those who are on the IRC channel and the forum, in
    particular (but in no particular order)
      mr_cha0s, stylin, {1000101}, voodooattack, {Nathan}, spaz, pritchard,
      shadowwolf, insomninja, ijjekw, DJ Peters, relsoft, Dr_D, Mysoft, nkk,
      mindless, hexdude




  Notes on the zlib usage
  ==

  The source files for zlib are just taken directly from an official zlib distribution
  I haven't modified them in any way
