precision highp float;

varying vec2 textureCoordinate;
varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;

uniform sampler2D backgroundFrame;
uniform float edgeStrength;

void main()
{
    float bottomLeftIntensity = texture2D(backgroundFrame, bottomLeftTextureCoordinate).r;
    float topRightIntensity = texture2D(backgroundFrame, topRightTextureCoordinate).r;
    float topLeftIntensity = texture2D(backgroundFrame, topLeftTextureCoordinate).r;
    float bottomRightIntensity = texture2D(backgroundFrame, bottomRightTextureCoordinate).r;
    float leftIntensity = texture2D(backgroundFrame, leftTextureCoordinate).r;
    float rightIntensity = texture2D(backgroundFrame, rightTextureCoordinate).r;
    float bottomIntensity = texture2D(backgroundFrame, bottomTextureCoordinate).r;
    float topIntensity = texture2D(backgroundFrame, topTextureCoordinate).r;
    float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
    float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
    
    float mag = length(vec2(h, v)) * edgeStrength;
    
    lowp vec4 color = vec4(vec3(mag), 1.0);
    //lowp vec4 invertColor = vec4(vec3(1.0) - color.rgb, color.a);
    gl_FragColor = color;
}