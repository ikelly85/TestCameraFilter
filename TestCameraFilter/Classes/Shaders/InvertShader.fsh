#version 100

varying highp vec2 textureCoordinate;
uniform sampler2D backgroundFrame;

void main()
{
    lowp vec4 textureColor = texture2D(backgroundFrame, textureCoordinate.st);
    lowp vec4 invertColor = vec4(vec3(1.0) - textureColor.rgb, textureColor.a);
    gl_FragColor = invertColor;
}
