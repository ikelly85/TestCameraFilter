varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D backgroundFrame;
uniform sampler2D alphaBlendFrame;

void main()
{
    lowp vec4 color = texture2D(backgroundFrame, textureCoordinate);
    lowp vec4 color2 = texture2D(alphaBlendFrame, textureCoordinate2);
    gl_FragColor = vec4(mix(color.rgb, color2.rgb, color2.a * 0.5), color.a);
}
