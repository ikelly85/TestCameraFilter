varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D backgroundFrame;
uniform sampler2D alphaBlendFrame;
uniform sampler2D filterFrame;

void main()
{
    highp vec4 color = texture2D(backgroundFrame, textureCoordinate);
    highp vec4 alphaColor = texture2D(alphaBlendFrame, textureCoordinate2);
    
    highp float intensity = 1.0;
    highp float blueColor = color.b * 63.0;
    
    highp vec2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    
    highp vec2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    
    highp vec2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * color.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * color.g);
    
    highp vec2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * color.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * color.g);
    
    highp vec4 newColor1 = texture2D(filterFrame, texPos1);
    highp vec4 newColor2 = texture2D(filterFrame, texPos2);
    
    highp vec4 newColor = mix(newColor1, newColor2, fract(blueColor));
    highp vec4 filteredTextureColor = mix(color, vec4(newColor.rgb, color.w), intensity);
    //gl_FragColor = color2;
    
    highp vec4 alphaBlendFrameWithFilter = vec4(mix(filteredTextureColor.rgb, alphaColor.rgb, alphaColor.a * 0.5), filteredTextureColor.a);
    
    gl_FragColor = alphaBlendFrameWithFilter;
}
