varying highp vec2 textureCoordinate;

uniform sampler2D backgroundFrame;

void main()
{
    gl_FragColor = texture2D(backgroundFrame, textureCoordinate);
}
