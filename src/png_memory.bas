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

	if size = 0 then
		return NULL
	end if

	const ALIGNMENT as ubyte = 16

	dim as ubyte ptr result = any
	dim as ulong real_size = any

	real_size = size + &HF

	result = callocate( real_size )
	
	if result <> NULL then
		dim as uinteger remainder_ = cuint(result) MOD ALIGNMENT
		dim as ubyte offset = ALIGNMENT - remainder_
		dim as any ptr orig_p = result
		result = orig_p + offset
		*(result - 1) = offset
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

	dim as ubyte offset = *(cast(ubyte ptr, buffer) - 1)
	if(offset > 16) then
		offset = 16
	end if

	' Due to the alignment for SSE, the real pointer to be free'd is actually just before the buffer
	deallocate( cast(ubyte ptr, buffer) - offset )

end sub

#EndIf
