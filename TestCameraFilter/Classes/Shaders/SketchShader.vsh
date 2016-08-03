attribute vec4 position;
attribute vec4 inputTextureCoordinate;

uniform highp float imageWidthFactor;
uniform highp float imageHeightFactor;

varying vec2 textureCoordinate;
varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;

void main()
{
    gl_Position = position;
    
    vec2 widthStep = vec2(imageWidthFactor, 0.0);
    vec2 heightStep = vec2(0.0, imageHeightFactor);
    vec2 widthHeightStep = vec2(imageWidthFactor, imageHeightFactor);
    vec2 widthNegativeHeightStep = vec2(imageWidthFactor, -imageHeightFactor);
    
    textureCoordinate = inputTextureCoordinate.xy;
    leftTextureCoordinate = inputTextureCoordinate.xy - widthStep;
    rightTextureCoordinate = inputTextureCoordinate.xy + widthStep;
    
    topTextureCoordinate = inputTextureCoordinate.xy + heightStep;
    topLeftTextureCoordinate = inputTextureCoordinate.xy - widthNegativeHeightStep;
    topRightTextureCoordinate = inputTextureCoordinate.xy + widthHeightStep;
    
    bottomTextureCoordinate = inputTextureCoordinate.xy - heightStep;
    bottomLeftTextureCoordinate = inputTextureCoordinate.xy - widthHeightStep;
    bottomRightTextureCoordinate = inputTextureCoordinate.xy + widthNegativeHeightStep;
}