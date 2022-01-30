#include once "crt.bi"
#include once "png_image.bi"




'::::::::
' Purpose : filter the current row that uses method 1 or 2
sub png_image_filter_row_12 _
	( _
		byval pcb       as ubyte ptr, _ ' pointer to first byte of row to be filtered
		byval filter    as integer, _
		byval y         as integer, _
		byval scan_size as integer, _
		byval bpp       as integer _
	)

	dim as integer count = scan_size - 1
	dim as ubyte ptr src = any

	if filter = 1 then
		pcb += bpp ' ignore first pixel
		count -= bpp
		src = @pcb[-bpp]
	else
		if y <= 0 then exit sub
		src = @pcb[-scan_size]
	end if

	if count and 1 then
		pcb[0] += src[0]
		pcb += 1
		src += 1
	end if

	if count and 2 then
		pcb[0] += src[0]
		pcb[1] += src[1]
		pcb += 2
		src += 2
	end if

	count shr= 2

	for x as integer = count - 1 to 0 step -1
		pcb[0] += src[0]
		pcb[1] += src[1]
		pcb[2] += src[2]
		pcb[3] += src[3]
		pcb += 4
		src += 4
	next x

end sub

'::::::::
' Purpose : filter the current row that uses method 3
sub png_image_filter_row_3 _
	( _
		byval pcb       as ubyte ptr, _ ' pointer to first byte of row to be filtered
		byval filter    as integer, _
		byval y         as integer, _
		byval scan_size as integer, _
		byval bpp       as integer _
	)

	if y > 0 then
		for x as integer = bpp - 1 to 0 step - 1
			*pcb += pcb[-scan_size] shr 1
			pcb += 1
		next x

		dim as ubyte ptr srcA = @pcb[-bpp]
		dim as ubyte ptr srcB = @pcb[-scan_size]

		dim as integer count = (scan_size - 1) - bpp

		if count and 1 then
			pcb[0] += (srcA[0] + srcB[0]) shr 1
			pcb += 1
			srcA += 1
			srcB += 1
		end if

		if count and 2 then
			pcb[0] += (srcA[0] + srcB[0]) shr 1
			pcb[1] += (srcA[1] + srcB[1]) shr 1
			pcb += 2
			srcA += 2
			srcB += 2
		end if

		count shr= 2

		for x as integer = count - 1 to 0 step -1
			pcb[0] += (srcA[0] + srcB[0]) shr 1
			pcb[1] += (srcA[1] + srcB[1]) shr 1
			pcb[2] += (srcA[2] + srcB[2]) shr 1
			pcb[3] += (srcA[3] + srcB[3]) shr 1
			pcb += 4
			srcA += 4
			srcB += 4
		next x
	else
		pcb += bpp

		for x as integer = (scan_size - 2) - bpp to 0 step -1
			*pcb += pcb[-bpp] shr 1
			pcb += 1
		next x
	end if

end sub

'::::::::
' Purpose : filter the current row that uses method 4
sub png_image_filter_row_4 _
	( _
		byval pcb       as ubyte ptr, _ ' pointer to first byte of row to be filtered
		byval filter    as integer, _
		byval y         as integer, _
		byval scan_size as integer, _
		byval bpp       as integer _
	)

	if y > 0 then
		for x as integer = bpp - 1 to 0 step - 1
			*pcb += pcb[-scan_size]
			pcb += 1
		next x

		for x as integer = (scan_size - 2) - bpp to 0 step - 1
			dim as uinteger a      = any
			dim as uinteger b      = any
			dim as integer  p      = any
			dim as integer  pa     = any
			dim as integer  pb     = any
			dim as integer  pc     = any
			dim as uinteger amount = any
		
			a = pcb[-bpp]
			b = pcb[-scan_size]
			amount = pcb[-(scan_size + bpp)]

			' Paeth predictor
			p = a + b - amount
			pa = abs( p - a )
			pb = abs( p - b )
			pc = abs( p - amount )

			if (pa <= pb) and (pa <= pc) then
				amount = a
			elseif pb <= pc then
				amount = b
			end if
		
			*pcb += amount
			pcb += 1
		next x
	else
		pcb += bpp

		for x as integer = (scan_size - 2) - bpp to 0 step - 1
			*pcb += pcb[-bpp]
			pcb += 1
		next x
	end if

end sub


'::::::::
' Purpose : Create an image buffer of requested target type, and unpack the IDAT
' Return  : NULL on failure, valid pointer to buffer on success
function png_image_convert _
	( _
		byref png_image  as png_image_t, _
		byval outbpp     as long, _
		byref outbuffer  as any ptr, _
		byval outpal     as any ptr, _
		byref cb         as png_cb   _
	) as integer

	dim as long      offset    = 0
	dim as long      data_read = 0
	dim as ubyte ptr    in_img    = any
	dim as long      pass_max  = 1
	dim as long      pass      = any
	
	Dim As long      scan_size = Any
	Dim As long      pixCount  = Any

        dim as long		outwidth	= any
        dim as long		outheight	= any
	dim as any ptr		outrow		= any
        dim as long		outformat	= any
        dim as long		palformat	= any


        dim as sub cdecl _
                ( _
                        byref png_image  as png_image_t, _
                        byval out_row    as any ptr, _
                        byval p          as ubyte ptr, _
                        byval x1         as long, _
                        byval wfactor    as long, _
                        byval scan_size  as long _
                )       	row_conv


	function = -1


	with png_image
	
		if .prepared = FALSE then
			DEBUGPRINT( "Not prepared" )
			exit function
		end if

		' Make a copy of the IDAT, because unfiltering will overwrite
		in_img = callocate( .IDAT_len )
		if in_img = NULL then
			DEBUGPRINT( "IDAT copy allocate failed" )
			exit function
		end if
		memcpy( in_img, .IDAT, .IDAT_len )

		' Create the target image buffer
                if( cb.create( outbuffer, .width, .height, outbpp, .colortype, .bitdepth ) )then
                        deallocate( in_img )
                        DEBUGPRINT( "cb.create failed" )
                        exit function
                end if

                ' Obtain buffer specifics
                if( cb.img_format( outbuffer, outformat ) )then
                        cb.destroy( outbuffer )
                        deallocate( in_img )
                        DEBUGPRINT( "cb.img_format failed" )
                        exit function
                end If

#ifndef	PNG_NO_PALETTE_8
                select case As Const .colortype
                	case    COLORTYPE_2, COLORTYPE_4, COLORTYPE_6
                                if( outformat = PALETTE_8 )then
                                        cb.destroy( outbuffer )
                                        deallocate( in_img )
                                        DEBUGPRINT( "Can not output RGB[A] image to PALETTE_8 buffer." )
                                        exit function
                                end If
                end select 
#endif

                if( cb.img_bpp( outbuffer, outbpp ) )then
                        cb.destroy( outbuffer )
                        deallocate( in_img )
                        DEBUGPRINT( "cb.img_bpp failed" )
                        exit function
                end If

                if( cb.img_width( outbuffer, outwidth ) )then
                        cb.destroy( outbuffer )
                        deallocate( in_img )
                        DEBUGPRINT( "cb.img_width failed" )
                        exit function
                end if

                if( cb.img_height( outbuffer, outheight ) )then
                        cb.destroy( outbuffer )
                        deallocate( in_img )
                        DEBUGPRINT( "cb.img_height failed" )
                        exit Function
                end if

                ' Select row conversion function
                row_conv = conv_row_function( .colortype, outformat )
                if( row_conv = NULL )then
                        cb.destroy( outbuffer )
                        deallocate( in_img )
                        DEBUGPRINT( "Invalid colour space conversion" )
                        exit function
                end if

                ' Interlaced png?
		if .interlacemethod = 1 then
			pass_max = 7
		end if

		' Make a number of passes, 1 for non interlaced, 7 for interlaced
		for pass = 1 to pass_max

			dim as integer scan_size = calc_scan_size( png_image, pass )
			dim as long y1        = 0
			dim as long wfactor   = 1
			dim as long hfactor   = 1
			dim as long y_max     = .height - 1
			dim as long y         = any

			if .interlacemethod = 1 then
				dim as long iheight = any
				wfactor = tb_wfac(pass)
				hfactor = tb_hfac(pass)
				iheight = (.height + hfactor - tb_yoff(pass) - 1) \ hfactor
				y1 = tb_yoff(pass)
				y_max = iheight - 1
				' Force the y loop to not do anything if theres nothing to do this pass
				if .width <= tb_xoff(pass) then
					y_max = -1
				end if
			end if
			for y = 0 to y_max
				dim as long x1     = 0
				dim as ubyte   filter = in_img[offset]
				offset += 1 ' Jump past the filter byte
				if .interlacemethod = 1 then
					x1 = tb_xoff(pass)
				end if
				dim as any ptr _inp = @in_img[offset]

				select case as const filter
					case 0
						' No filtering
					case 1, 2
						png_image_filter_row_12( _inp, filter, y, scan_size, .bpp )
					case 3
						png_image_filter_row_3( _inp, filter, y, scan_size, .bpp )
					case 4
						png_image_filter_row_4( _inp, filter, y, scan_size, .bpp )
					case else
						cb.destroy( outbuffer )
						deallocate( in_img )
						DEBUGPRINT( "Bad filter byte" )
						exit function
				end select

				offset += scan_size - 1

				If( y1 < outheight )Then

                                	If( cb.img_row( outbuffer, outrow, y1 ) )then
                                        	cb.destroy( outbuffer )
                                        	deallocate( in_img )
                                        	DEBUGPRINT( "cb.img_row failed" )
                                        	Exit function
                                	End if

					pixCount = ( ( scan_size - 1) \ .bpp ) - 1
					pixCount = ( IIf( outwidth < pixCount * wfactor, outwidth \ wfactor - 1, pixCount ) )

                                	row_conv( png_image, outrow, _inp, x1, wfactor, pixCount )

				End If

				y1 += hfactor
			next y
		next pass

		' Were we passed a palette to fill?
		If( outpal )Then

	                if( cb.palette_format( palformat ) )then
	                        cb.destroy( outbuffer )
	                        deallocate( in_img )
	                        DEBUGPRINT( "cb.palette_format failed" )
	                        exit function
	                end if

			' Is it a valid colorType to return a palette?
			Select Case .colortype

				Case	COLORTYPE_3
					Dim As sub Cdecl _
						( _
							byval PLTE       as png_RGB8_t ptr, _
							byval out_pal    as any ptr _
						)       pal_conv = conv_pal_function( palformat )
			                if( pal_conv = NULL )then
			                        cb.destroy( outbuffer )
			                        deallocate( in_img )
			                        DEBUGPRINT( "Invalid palette format" )
			                        exit function
			                end If

			                pal_conv( @.PLTE( 0 ), outpal )

				Case	COLORTYPE_0, COLORTYPE_4
					Dim As sub Cdecl _
						( _
							byval PLTE       as png_RGB8_t ptr, _
							byval out_pal    as any ptr _
						)       pal_conv = conv_pal_function( palformat )
			                if( pal_conv = NULL )then
			                        cb.destroy( outbuffer )
			                        deallocate( in_img )
			                        DEBUGPRINT( "Invalid palette format" )
			                        exit function
			                end If

			                if( .bitdepth < 8 )Then
						dim as integer  mask   = (2 ^ .bitdepth) - 1
						Dim As Integer  grey   = 255 \ mask
			                	For i As Integer = 0 To mask
			                		.PLTE( i ).r = i * grey
			                		.PLTE( i ).g = .PLTE( i ).r
			                		.PLTE( i ).b = .PLTE( i ).r
			                	Next
			                Else
			                	For i As Integer = 0 To 255
			                		.PLTE( i ).r = i
			                		.PLTE( i ).g = .PLTE( i ).r
			                		.PLTE( i ).b = .PLTE( i ).r
			                	Next
			                EndIf

			                pal_conv( @.PLTE( 0 ), outpal )

			End Select
		EndIf

		deallocate( in_img )
	end with
	
	function = 0

end function 
