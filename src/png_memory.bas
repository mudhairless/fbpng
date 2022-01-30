#include once "crt.bi"
#include once "png_image.bi"

#Ifndef PNG_DEBUG

'::::::::
' Purpose : allocate a special buffer, that is aligned to a multiple of 16, for SSE usage
' Return  : NULL if failed, non NULL pointer to memory on success
function callocate_aligned cdecl alias "callocate_aligned" _
	( _
		byval size as ulong _
	) as any ptr

	if size <= 0 then
		return NULL
	end if

	dim as any ptr result = any
	dim as ulong real_size = any

	real_size = size + sizeof( any ptr ) + &H1Ful

	result = callocate( real_size )
	
	if result <> NULL then
		dim as any ptr orig_p = result
		result += sizeof( any ptr ) + &H1Ful
		*(cast( uinteger ptr, @result )) = culng(*(cast( uinteger ptr, @result )) AND (not &HFul))
		cptr(any ptr ptr, result)[-1] = orig_p
	end if
	
	function = result

end function

'::::::::
' Purpose : free an aligned memory chunk
' Return  : None
sub deallocate_aligned cdecl alias "deallocate_aligned" _
	( _
		byval buffer as any ptr _
	)

	if buffer = NULL then
		exit sub
	end if

	' Due to the alignment for SSE, the real pointer to be free'd is actually just before the buffer
	deallocate( cptr( any ptr ptr, buffer )[-1] )

end sub

#EndIf
