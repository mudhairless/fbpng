//Simple wobble texture coordinates GLSL shader by Dave Stanley

uniform float Time;
uniform float Stretch;
uniform sampler2D Texture;

const float pi = 3.1415926;

vec2 tCoord;
vec2 fCoord;
float tStretch = 512.0/Stretch;

void main(void)
{

fCoord = gl_TexCoord[0].st;

tCoord.x = fCoord.x + cos( pi * fCoord.y * 2.0 + Time ) / tStretch;
tCoord.y = fCoord.y - sin( pi * fCoord.x * 2.0 + Time ) / tStretch;

gl_FragColor = texture2D( Texture, tCoord ) ;

}
