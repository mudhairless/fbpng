#ifdef	PNG_NO_OLD_API
	#Error This test must be built with access to the "Version 1" API. 
#endif


'Note: these structures are nowhere near complete.
#include "GL/gl.bi"
#include "GL/glu.bi"
#include "GL/glext.bi"
#include "fbgfx.bi"
#include "fbpng.bi"


type DisplayMode
    W       as uinteger
    H       as uinteger
    BPP     as uinteger
    D_BITS  as uinteger
    S_BITS  as uinteger
    MODE    as uinteger
    GlVer   as zstring ptr
    FOV     as single
    Aspect  as single
    zNear   as single
    zFar    as single
end type


type Vec4f
    as single x,y,z,w
end type


declare sub Set_Ortho( byref Display as DisplayMode )
declare sub Drop_Ortho( byref Display as DisplayMode )
declare function Load_Texture( byref Texture as Gluint, byref Filename as string ) as integer
declare sub Open_GL_Window( byval W as integer, byval H as integer, byval BPP as integer, byval Num_buffers as integer, byval Num_Samples as integer, byval Fullscreen as integer )
declare sub Gather_Extensions()
declare function Init_Shader( File_Name as string, Shader_Type as integer )as GlHandleARB



'for framebuffers
common shared _framebuffer_                    as integer
common shared glGenFramebuffersEXT             as PFNglGenFramebuffersEXTPROC
common shared glDeleteFramebuffersEXT          as PFNglDeleteFramebuffersEXTPROC
common shared glBindFramebufferEXT             as PFNglBindFramebufferEXTPROC
common shared glFramebufferTexture2DEXT        as PFNglFramebufferTexture2DEXTPROC
common shared glFramebufferRenderbufferEXT     as PFNglFramebufferRenderbufferEXTPROC
common shared glGenRenderbuffersEXT            as PFNglGenRenderbuffersEXTPROC
common shared glBindRenderbufferEXT            as PFNglBindRenderbufferEXTPROC
common shared glRenderbufferStorageEXT         as PFNglRenderbufferStorageEXTPROC

'for multitexture
common shared _multitexture_                    as integer
common shared maxTexelUnits                     as Gluint
common shared glMultiTexCoord2fARB              as PFNglMultiTexCoord2fARBPROC
common shared glActiveTextureARB                as PFNGlActiveTextureARBPROC
common shared glClientActiveTextureARB          as PFNglClientActiveTextureARBPROC
common shared glGenerateMipmapEXT               as PFNglGenerateMipmapEXTPROC

'For shaders
common shared _shader100_                      as integer
common shared glCreateShaderObjectARB          as PFNglCreateShaderObjectARBPROC
common shared glShaderSourceARB                as PFNglShaderSourceARBPROC
common shared glGetShaderSourceARB             as PFNglGetShaderSourceARBPROC
common shared glCompileShaderARB               as PFNglCompileShaderARBPROC
common shared glDeleteObjectARB                as PFNglDeleteObjectARBPROC
common shared glCreateProgramObjectARB         as PFNglCreateProgramObjectARBPROC
common shared glAttachObjectARB                as PFNglAttachObjectARBPROC
common shared glUseProgramObjectARB            as PFNglUseProgramObjectARBPROC
common shared glLinkProgramARB                 as PFNglLinkProgramARBPROC
common shared glValidateProgramARB             as PFNglValidateProgramARBPROC
common shared glGetObjectParameterivARB        as PFNglGetObjectParameterivARBPROC
common shared glGetInfoLogARB                  as PFNglGetInfoLogARBPROC
common shared glGetUniformLocationARB          as PFNglGetUniformLocationARBPROC
common shared glUniform1iARB                   as PFNglUniform1iARBPROC
common shared glUniform1fARB                   as PFNglUniform1fARBPROC
common shared glUniform2fvARB                  as PFNglUniform2fvARBPROC
common shared glUniform3fvARB                  as PFNglUniform3fvARBPROC

chdir exepath

dim shared as DisplayMode Display
dim shared as integer errlog
dim as glUint Texture(1), Quad, Shader_Compile_Success
dim as glHandleARB Vertex_Shader, Fragment_Shader, Shader_Program
dim as Vec4f lightpos = type<vec4f>(-50,0,0,1)

'these will be the handles to the variable names in the shader.
dim as GLINT sdr_Texture, sdr_Time, sdr_Stretch
dim as integer use_shader = -1

errlog = freefile
Open_GL_Window( 640, 480,32, 1, 0, 0 )
open cons for output as #errlog
Gather_Extensions()

if Load_Texture( Texture(0), "lava.png" ) = 0 then
    print #errlog, "texture not found"
    sleep 1000, 1
    end
end if
print #errlog, "lava texture (0) loaded"

if Load_Texture( Texture(1), "lava.png" ) = 0 then
    print #errlog, "texture not found"
    sleep 1000, 1
    end
end if
print #errlog, "lava texture (1) loaded"

if _shader100_ <> 0 then
    Vertex_Shader   = Init_Shader( "shaders/wobble.vert", GL_VERTEX_SHADER_ARB )
    Fragment_Shader = Init_Shader( "shaders/wobble.frag", GL_FRAGMENT_SHADER_ARB )
    
    Shader_Program = glCreateProgramObjectARB()
    glAttachObjectARB( Shader_Program, Vertex_Shader )
    glAttachObjectARB( Shader_Program, Fragment_Shader )
    glLinkProgramARB( Shader_Program )
    
    glValidateProgramARB( Shader_Program )
    glGetObjectParameterivARB( Shader_Program, GL_OBJECT_VALIDATE_STATUS_ARB, @Shader_Compile_Success )
    if Shader_Compile_Success = 0 then
        print #errlog, "ARGHHHH!!!! GLSL program failed to compile."
        sleep 1000, 1
        close #errlog
        end
    end if
    
    'This gets the memory location of variable("name"), so that we can send data to the gpu at the correct address.
    sdr_Texture     = glGetUniformLocationARB( Shader_Program, strptr("Texture") )
    sdr_Time        = glGetUniformLocationARB( Shader_Program, strptr("Time") )
    sdr_Stretch     = glGetUniformLocationARB( Shader_Program, strptr("Stretch") )
    print #errlog, "Location of Texture variable in shader:" & sdr_Texture
    print #errlog, "Location of Timer variable in shader:" & sdr_Time
    print #errlog, "Location of Stretch variable in shader:" & sdr_Stretch
else    
    print #errlog, "OpenGL Shader Language is not supported on this card."
    print #errlog, "This demo will not work as expected."
end if

Quad = glGenLists(1)
glNewList( Quad, GL_COMPILE )
glBegin( GL_QUADS )
glTexCoord2D( 1,0 )
glNormal3F(0,0,-1)
glVertex3F( .5, -.5, 0 )

glTexCoord2D( 1,1 )
glVertex3F( .5, .5, 0 )

glTexCoord2D( 0,1 )
glVertex3F( -.5, .5, 0 )

glTexCoord2D( 0,0 )
glVertex3F( -.5, -.5, 0 )
glEnd()
GlEndList()

if GlIsList( Quad ) = GL_FALSE then
    print #errlog, "Display list got borked somehow."
    sleep 1000, 1
    close #errlog
    end
end if

glEnable( GL_LIGHTING )
glEnable( GL_LIGHT0 )
glLightfv( GL_POSITION, GL_LIGHT0, @lightpos.x )

'main
do  
    
    if multikey(FB.SC_SPACE) then
        use_shader = not use_shader
        do
            ScreenControl FB.POLL_EVENTS
        loop until multikey(FB.SC_SPACE) = 0
    end if
    
    dim as single lTime = timer*5
    
    glDisable( GL_CULL_FACE )
    glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT )
    
    glMatrixMode( GL_MODELVIEW )
    glLoadIdentity()
    
    glTranslateF( 0,0,-10)
    glRotateD( 45*sin(timer/2), 0,1,0)
    
    glBindTexture(GL_TEXTURE_2D, Texture(0))
    
    
    for y as integer = -1 to 1
        for x as integer = -1 to 1
            
            if _shader100_ then
                if use_shader then
                    glUseProgramObjectARB( Shader_Program )
                    glUniform1iARB( sdr_Texture, 0 )
                    glUniform1fARB( sdr_Time, lTime )
                    glUniform1fARB( sdr_Stretch, 16+15*sin(timer) )
                else
                    glUseProgramObjectARB( 0 )
                end if
            end if
            
            
            glPushMatrix()
            glTranslateF(x,y,0)
            glCallList( Quad )
            glPopMatrix()
        next
    next
    
    glPopMatrix()
    
    flip
    sleep 1,1
loop until multikey(FB.SC_ESCAPE)

for i as integer = 0 to ubound(texture)
    glDeleteTextures( 1, @texture(i) )
next

glDeleteLists( Quad, 1 )

if _shader100_ then
    glDeleteObjectArb( Vertex_Shader )
    glDeleteObjectArb( Fragment_Shader )
    glDeleteObjectArb( Shader_Program )
end if
print #errlog, "Exit was okay! :)"
sleep 1000,1
close #errlog



sub Gather_Extensions()
    
    dim extensions as string
    ScreenControl FB.GET_GL_EXTENSIONS, extensions
    
    if (instr(extensions, "GL_EXT_framebuffer_object") <> 0) then
        print #errlog, "GL_EXT_framebuffer_object is supported"
        _framebuffer_ = 1
        glGenFramebuffersEXT            = ScreenGLProc("glGenFramebuffersEXT")
        glDeleteFramebuffersEXT         = ScreenGLProc("glDeleteFramebuffersEXT")
        glBindFramebufferEXT            = ScreenGLProc("glBindFramebufferEXT")
        glFramebufferTexture2DEXT       = ScreenGLProc("glFramebufferTexture2DEXT")       
        glFramebufferRenderbufferEXT    = ScreenGLProc("glFramebufferRenderbufferEXT")
        glGenRenderbuffersEXT           = ScreenGLProc("glGenRenderbuffersEXT")
        glBindRenderbufferEXT           = ScreenGLProc("glBindRenderbufferEXT")
        glRenderbufferStorageEXT        = ScreenGLProc("glRenderbufferStorageEXT")
    else
        print #errlog, "GL_EXT_framebuffer_object is NOT supported"
    end if
    
    
    if (instr(extensions, "GL_ARB_multitexture") <> 0) then
        print #errlog, "GL_ARB_multitexture is supported"
        _multitexture_ = 1
        glMultiTexCoord2fARB            = ScreenGLProc("glMultiTexCoord2fARB")
        glActiveTextureARB              = ScreenGLProc("glActiveTextureARB")
        glClientActiveTextureARB        = ScreenGLProc("glClientActiveTextureARB")
        glGetIntegerv(GL_MAX_TEXTURE_UNITS_ARB, @maxTexelUnits)
    else
        print #errlog, "GL_ARB_multitexture is NOT supported"
    end if
    
    
    if (instr(extensions, "GL_ARB_shading_language_100") <> 0) then
        print #errlog, "GL_ARB_shading_language_100 is supported"
        _shader100_ = 1
        glCreateShaderObjectARB     = ScreenGLProc("glCreateShaderObjectARB")
        glShaderSourceARB           = ScreenGLProc("glShaderSourceARB")
        glGetShaderSourceARB        = ScreenGLProc("glGetShaderSourceARB")
        glCompileShaderARB          = ScreenGLProc("glCompileShaderARB")
        glDeleteObjectARB           = ScreenGLProc("glDeleteObjectARB")
        glCreateProgramObjectARB    = ScreenGLProc("glCreateProgramObjectARB")
        glAttachObjectARB           = ScreenGLProc("glAttachObjectARB")
        glUseProgramObjectARB       = ScreenGLProc("glUseProgramObjectARB")
        glLinkProgramARB            = ScreenGLProc("glLinkProgramARB")
        glValidateProgramARB        = ScreenGLProc("glValidateProgramARB")
        glGetInfoLogARB             = ScreenGLProc("glGetInfoLogARB")
        glGetObjectParameterivARB   = ScreenGLProc("glGetObjectParameterivARB")
        glGetUniformLocationARB     = ScreenGLProc("glGetUniformLocationARB")
        glUniform1iARB              = ScreenGLProc("glUniform1iARB")
        glUniform1fARB              = ScreenGLProc("glUniform1fARB")
        glUniform2fvARB             = ScreenGLProc("glUniform2fvARB")
        glUniform3fvARB             = ScreenGLProc("glUniform3fvARB")
    else
        print #errlog, "GL_ARB_shading_language_100 is NOT supported"
    end if
    
    print #errlog, " "
end sub


function Load_Texture( byref Texture as Gluint, byref Filename as string ) as integer
    
    dim as integer ret_val
    glGenTextures( 1, @Texture )
    glBindTexture(GL_TEXTURE_2D, Texture )
    glEnable( GL_TEXTURE_2D )
    
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT )
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT )
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_LINEAR )
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR )
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
    
    dim SprWidth as ulong
    dim SprHeight as ulong
    png_dimensions( filename, SprWidth, SprHeight )
    dim as ubyte ptr buffer = png_load( filename, PNG_TARGET_OPENGL )
    
    if buffer = 0 then 
        return 0
    else
        ret_val = 1
    end if
    
    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, SprWidth, SprHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer )
    gluBuild2DMipmaps( GL_TEXTURE_2D, GL_RGBA, SprWidth, SprHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer )
    
    png_destroy( buffer )
    return ret_val
end function

sub Set_Ortho( byref Display as DisplayMode )
    glmatrixmode( Gl_Projection )
    glpushmatrix 
    glloadidentity 
    glmatrixmode( Gl_Modelview )
    glpushmatrix
    glloadidentity
    GlOrtho( 0, Display.W, 0, Display.H, -1, 1 )
end sub

sub Drop_Ortho( byref Display as DisplayMode )
    glmatrixmode( Gl_Projection )
    glpopmatrix
    glmatrixmode( Gl_Modelview )
    glpopmatrix
end sub



sub Open_GL_Window( byval W as integer, byval H as integer, byval BPP as integer, byval Num_buffers as integer, byval Num_Samples as integer, byval Fullscreen as integer )
    
    dim Flags as integer = FB.GFX_OPENGL or FB.GFX_HIGH_PRIORITY
    if FullScreen then
        Flags or = FB.GFX_FULLSCREEN
    end if
    ScreenControl FB.SET_GL_COLOR_BITS, BPP
    ScreenControl FB.SET_GL_DEPTH_BITS, 24
    if Num_Samples>0 then 
        ScreenControl FB.SET_GL_NUM_SAMPLES, Num_Samples
        Flags or = FB.GFX_MULTISAMPLE
    end if
    screenres W, H, BPP, Num_Buffers, Flags
    
    glViewport( 0, 0, W, H )
    glMatrixMode( GL_PROJECTION )
    glLoadIdentity()
    Display.W = W
    Display.H = H
    Display.BPP = BPP
    Display.FOV = 45.0
    Display.Aspect = W/H
    Display.znear = 1
    Display.zfar = 100
    gluPerspective( Display.FOV, Display.Aspect, Display.zNear, Display.zFar )
    
    glShadeModel( GL_SMOOTH )
    glClearColor( 0.0, 0.0, 0.0, 1.0 )
    glClearDepth( 1.0 )
    glEnable( GL_DEPTH_TEST )
    glDepthFunc( GL_LEQUAL )
    glEnable( GL_COLOR_MATERIAL )
    
    glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST )
    glPolygonMode( GL_FRONT_AND_BACK, GL_FILL )
    glEnable( GL_CULL_FACE )
    glMatrixMode( GL_MODELVIEW )
end sub


function Init_Shader( File_Name as string, Shader_Type as integer )as GlHandleARB
    dim as integer i
    dim as integer Line_Cnt
    dim as string Shader_Text, tString
    dim as Gluint Shader_Compile_Success
    dim as GlHandleARB Shader
    dim as uinteger FileNum = freefile
    
    open File_Name for binary as #FileNum
    do while not eof(FileNum)
        line input #FileNum, tString
        Shader_Text += tString + chr( 13, 10 )
    loop
    close #FileNum
    
    dim as GLcharARB ptr table(0) => { strptr( Shader_Text ) }
    Shader = glCreateShaderObjectARB( Shader_Type )
    glShaderSourceARB( Shader, 1, @table(0), 0 )
    glCompileShaderARB( Shader )
    
    glGetObjectParameterivARB( Shader, GL_OBJECT_COMPILE_STATUS_ARB, @Shader_Compile_Success )
    if Shader_Compile_Success = 0 then
        dim as Gluint infologsize
        glGetObjectParameterivARB( Shader, GL_OBJECT_INFO_LOG_LENGTH_ARB, @infoLogSize)
        dim as GlByte infolog(InfoLogSize)
        glGetInfoLogARB( Shader, InfoLogSize, 0, @infoLog(0))
        tString=""
        for i = 0 to InfoLogSize-1
            tString+=chr(InfoLog(i))
        next
        print #errlog, "Shader Infolog error message:"
        print #errlog, tString
        return 0
    else
        return Shader
    end if
end function
