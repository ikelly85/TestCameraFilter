attribute vec4 position;
attribute vec2 inputTextureCoordinate;

varying vec2 textureCoordinate;
varying vec2 blurTexCoords[14];

void main()
{
    gl_Position = position;
    textureCoordinate = inputTextureCoordinate;
    blurTexCoords[ 0] = textureCoordinate + vec2(-0.028, 0.0);
    blurTexCoords[ 1] = textureCoordinate + vec2(-0.024, 0.0);
    blurTexCoords[ 2] = textureCoordinate + vec2(-0.020, 0.0);
    blurTexCoords[ 3] = textureCoordinate + vec2(-0.016, 0.0);
    blurTexCoords[ 4] = textureCoordinate + vec2(-0.012, 0.0);
    blurTexCoords[ 5] = textureCoordinate + vec2(-0.008, 0.0);
    blurTexCoords[ 6] = textureCoordinate + vec2(-0.004, 0.0);
    blurTexCoords[ 7] = textureCoordinate + vec2( 0.004, 0.0);
    blurTexCoords[ 8] = textureCoordinate + vec2( 0.008, 0.0);
    blurTexCoords[ 9] = textureCoordinate + vec2( 0.012, 0.0);
    blurTexCoords[10] = textureCoordinate + vec2( 0.016, 0.0);
    blurTexCoords[11] = textureCoordinate + vec2( 0.020, 0.0);
    blurTexCoords[12] = textureCoordinate + vec2( 0.024, 0.0);
    blurTexCoords[13] = textureCoordinate + vec2( 0.028, 0.0);
}