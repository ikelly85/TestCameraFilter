#version 100

varying highp vec2 textureCoordinate;
uniform sampler2D backgroundFrame;

void main()
{
    lowp vec4 color = texture2D(backgroundFrame, textureCoordinate.st);
    
    gl_FragColor = vec4(color.r * 0.393 + color.g * 0.769 + color.b * 0.189, color.r * 0.349 + color.g * 0.686 + color.b * 0.168, color.r * 0.272 + color.g * 0.534 + color.b * 0.131, color.a);
}
