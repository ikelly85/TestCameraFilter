varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D originalTexture;
uniform highp float opacity;

lowp vec2 rgb2hv(lowp vec3 c)
{
    lowp vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    highp vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    highp vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    highp float d = q.x - min(q.w, q.y);
    highp float e = 1.0e-10;
    lowp vec2 hv = vec2(abs(q.z + (q.w - q.y) / (6.0 * d + e)), q.x);
    
    return hv;
}

lowp float hv2opacity(lowp vec2 hv)
{
    if (hv.y < 0.2)
        return 0.0;
    else {
        lowp float op = 1.0;
        if (hv.y < 0.3)
            op = (hv.y - 0.2) / 0.1;
        
        if (hv.x >= 0.91 || hv.x <= 0.17)
            return op;
        else if (hv.x >= 0.88)
            return op * (hv.x - 0.88) / 0.03;
        else if (hv.x <= 0.2)
            return op * (0.2 - hv.x) / 0.03;
        else
            return 0.0;
    }
}

lowp float rgb2opacity(lowp vec3 c)
{
    lowp float length = length(c);
    if (length < 0.2 || c.x < c.y || c.x < c.z)
        return 0.0;
    else {
        if (length < 0.3)
            return (0.3 - length) / 0.1;
        else
            return 1.0;
    }
}

highp vec4 cubic(highp float x)
{
    highp float x2 = x * x;
    highp float x3 = x2 * x;
    highp vec4 w;
    w.x =        -x3 + 3.0 * x2 - 3.0 * x + 1.0;
    w.y =  3.0 *  x3 - 6.0 * x2           + 4.0;
    w.z = -3.0 *  x3 + 3.0 * x2 + 3.0 * x + 1.0;
    w.w =  x3;
    
    return w / 6.0;
}

void main()
{
    lowp vec4 inputColor = texture2D(originalTexture, textureCoordinate);
    lowp vec2 hv = rgb2hv(inputColor.rgb);
    
    if (hv.y <= 0.2 || (hv.x < 0.88 && hv.x > 0.17) || opacity == 0.0) {
        gl_FragColor = inputColor;
    } else {
        lowp float op = opacity * hv2opacity(hv);
        
        lowp vec4 targetColor = texture2D(inputImageTexture, textureCoordinate);
        gl_FragColor = mix(inputColor, targetColor, op);
    }
}
