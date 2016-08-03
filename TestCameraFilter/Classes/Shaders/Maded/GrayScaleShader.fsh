#version 100

varying highp vec2 textureCoordinate;
uniform sampler2D backgroundFrame;

void main()
{
    lowp vec4 textureColor = texture2D(backgroundFrame, textureCoordinate.st);
    lowp float gray = dot(textureColor, vec4(0.299, 0.587, 0.114, 0.0));
    
    gl_FragColor = vec4(gray, gray, gray, textureColor.a);
}
