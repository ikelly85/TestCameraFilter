precision mediump float;

uniform sampler2D backgroundFrame;

varying vec2 textureCoordinate;
varying vec2 blurTexCoords[14];

void main()
{
    gl_FragColor = vec4(0.0);
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 0])*0.0044299121055113265;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 1])*0.00895781211794;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 2])*0.0215963866053;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 3])*0.0443683338718;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 4])*0.0776744219933;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 5])*0.115876621105;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 6])*0.147308056121;
    gl_FragColor += texture2D(backgroundFrame, textureCoordinate         )*0.159576912161;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 7])*0.147308056121;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 8])*0.115876621105;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[ 9])*0.0776744219933;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[10])*0.0443683338718;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[11])*0.0215963866053;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[12])*0.00895781211794;
    gl_FragColor += texture2D(backgroundFrame, blurTexCoords[13])*0.0044299121055113265;
}