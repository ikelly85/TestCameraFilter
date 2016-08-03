attribute vec4 position;
attribute vec4 inputTextureCoordinate;

uniform vec2 inputTextureSize;
varying vec2 textureCoordinate;

void main()
{
    gl_Position = position;
    
    textureCoordinate = inputTextureCoordinate.xy;
}