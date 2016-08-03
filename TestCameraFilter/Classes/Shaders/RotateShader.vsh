attribute vec4 position;
attribute vec4 inputTextureCoordinate;

uniform mat4 matrix;

varying vec2 textureCoordinate;

// */
void main()
{
    gl_Position = matrix * position;
    textureCoordinate = inputTextureCoordinate.xy;
}