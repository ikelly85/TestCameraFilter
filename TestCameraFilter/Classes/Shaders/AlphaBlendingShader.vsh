attribute vec4 position;

attribute vec4 inputTextureCoordinate;

varying vec2 textureCoordinate;
varying vec2 textureCoordinate2;


void main()
{
    gl_Position = position;
    textureCoordinate = inputTextureCoordinate.xy;
    textureCoordinate2 = inputTextureCoordinate.xy;
}