//
//  ViewController.m
//  TestCameraFilter
//
//  Created by HAN on 2016. 2. 1..
//  Copyright © 2016년 CampMobile. All rights reserved.
//

#import "ViewController.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

// Uniform index.
enum {
    UNIFORM_BACKGROUND,
    UNIFORM_ALPHABLEND,
    UNIFORM_FILTER,
    UNIFORM_MATRIX,
    UNIFORM_TEXELWIDTH,
    UNIFORM_TEXELHEIGHT,
    UNIFORM_EDGESTRENGTH,
    UNIFORM_RADIUS,
    UNIFORM_ANGLE,
    UNIFORM_CENTER,
    UNIFORM_ASPECTRATIO,
    UNIFORM_REFRACTIVEINDEX,
    UNIFORM_SCALE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTUREPOSITON,
    NUM_ATTRIBUTES
};

@interface ViewController () {
    GLuint baseProgram;
    GLuint otherProgram;
    GLuint otherProgram2;
    GLuint backgroundTexture;
    GLuint alphaBledingTexture;
    GLuint lookupTexture;
}

@end

@implementation ViewController

#pragma mark - Override Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    static BOOL addedSubviews = NO;
    if (addedSubviews == NO) {
        addedSubviews = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubviews];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)clickedGrayScaleButton
{
    [self loadVertexShader:@"GrayScaleShader" fragmentShader:@"GrayScaleShader" forProgram:&baseProgram];

    [self drawImageOnOpenGLSpace];
}

- (IBAction)clickedSepiaButton
{
    [self loadVertexShader:@"SepiaShader" fragmentShader:@"SepiaShader" forProgram:&baseProgram];

    [self drawImageOnOpenGLSpace];
}

- (IBAction)clickedOriginalButton
{
    [self loadVertexShader:@"DirectDisplayShader" fragmentShader:@"DirectDisplayShader" forProgram:&baseProgram];

    [self drawImageOnOpenGLSpace];
}

- (IBAction)clickedAlphaBlendButton
{
    [self loadVertexShader:@"AlphaBlendingShader" fragmentShader:@"AlphaBlendingShader" forProgram:&baseProgram];

    glEnable(GL_TEXTURE_2D);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];
    alphaBledingTexture = [self textureWithImageName:@"sample2.png"];

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    [self.glView setDisplayFramebuffer];
    glUseProgram(baseProgram);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, alphaBledingTexture);
    glUniform1i(uniforms[UNIFORM_ALPHABLEND], 3);

    // Update attribute values.
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedLookupFilterButton
{
    [self loadVertexShader:@"LookupFilterShader" fragmentShader:@"LookupFilterShader" forProgram:&baseProgram];

    glEnable(GL_TEXTURE_2D);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];
    alphaBledingTexture = [self textureWithImageName:@"sample2.png"];
    lookupTexture = [self textureWithImageName:@"fairy_tale.png"];

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    [self.glView setDisplayFramebuffer];
    glUseProgram(baseProgram);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, alphaBledingTexture);
    glUniform1i(uniforms[UNIFORM_ALPHABLEND], 3);

    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, lookupTexture);
    glUniform1i(uniforms[UNIFORM_FILTER], 4);

    // Update attribute values.
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedRotateButton
{
    glEnable(GL_TEXTURE_2D);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    [self.glView setDisplayFramebuffer];

    // gray filter
    [self loadVertexShader:@"RotateShader" fragmentShader:@"RotateShader" forProgram:&baseProgram];

    float angle = 1.56;

    GLfloat matrix[] = { cos(angle), -sin(angle), 0.0, 0.0, sin(angle), cos(angle), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 };
    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniformMatrix4fv(uniforms[UNIFORM_MATRIX], 1, GL_FALSE, matrix);

    // Update attribute values.
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedSketchButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat squareVertices1[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices1[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    glGenFramebuffers(1, &otherFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, otherFrameBuffer);
    glViewport(0, 0, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight]);

    GLuint otherTexture;
    glGenTextures(1, &otherTexture);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, otherTexture, 0);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    // gray filter
    [self loadVertexShader:@"SketchShader" fragmentShader:@"SketchShader" forProgram:&baseProgram];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_TEXELWIDTH], 1.0 / 720.0);
    glUniform1f(uniforms[UNIFORM_TEXELHEIGHT], 1.0 / 1280.0);
    glUniform1f(uniforms[UNIFORM_EDGESTRENGTH], 1.0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView setDisplayFramebuffer];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices1);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices1);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    // sketch filter
    [self loadVertexShader:@"InvertShader" fragmentShader:@"InvertShader" forProgram:&otherProgram];

    glUseProgram(otherProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedBlurButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat squareVertices1[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices1[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    glGenFramebuffers(1, &otherFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, otherFrameBuffer);
    glViewport(0, 0, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight]);

    GLuint otherTexture;
    glGenTextures(1, &otherTexture);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, otherTexture, 0);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    // HBlur filter
    [self loadVertexShader:@"HBlurShader" fragmentShader:@"HBlurShader" forProgram:&baseProgram];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView setDisplayFramebuffer];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices1);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices1);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    // VBLur filter
    [self loadVertexShader:@"VBlurShader" fragmentShader:@"VBlurShader" forProgram:&otherProgram];

    glUseProgram(otherProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedBilateralButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat squareVertices1[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices1[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    glGenFramebuffers(1, &otherFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, otherFrameBuffer);
    glViewport(0, 0, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight]);

    GLuint otherTexture;
    glGenTextures(1, &otherTexture);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, otherTexture, 0);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"BilateralShader" fragmentShader:@"BilateralShader" forProgram:&baseProgram];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_TEXELWIDTH], 1.0 / 720.0);
    glUniform1f(uniforms[UNIFORM_TEXELHEIGHT], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView setDisplayFramebuffer];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices1);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices1);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"BilateralShader" fragmentShader:@"BilateralShader" forProgram:&otherProgram];

    glUseProgram(otherProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_TEXELWIDTH], 0);
    glUniform1f(uniforms[UNIFORM_TEXELHEIGHT], 1.0 / 1280.0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedSmoothingButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat squareVertices1[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices1[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    glGenFramebuffers(1, &otherFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, otherFrameBuffer);
    glViewport(0, 0, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight]);

    GLuint otherTexture;
    glGenTextures(1, &otherTexture);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [_glView getFrameBufferWidth], [_glView getFrameBufferHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, otherTexture, 0);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"BilateralShader" fragmentShader:@"BilateralShader" forProgram:&baseProgram];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_TEXELWIDTH], 1.0 / 720.0);
    glUniform1f(uniforms[UNIFORM_TEXELHEIGHT], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView setDisplayFramebuffer];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices1);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices1);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"BilateralShader" fragmentShader:@"BilateralShader" forProgram:&otherProgram];

    glUseProgram(otherProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_TEXELWIDTH], 0);
    glUniform1f(uniforms[UNIFORM_TEXELHEIGHT], 1.0 / 1280.0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView setDisplayFramebuffer];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices1);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices1);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"SmoothingMask" fragmentShader:@"SmoothingMask" forProgram:&otherProgram2];

    glUseProgram(otherProgram2);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, otherTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedSwirlButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"SwirlShader" fragmentShader:@"SwirlShader" forProgram:&baseProgram];

    [self.glView setDisplayFramebuffer];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_RADIUS], 0.5);
    glUniform1f(uniforms[UNIFORM_ANGLE], 1.0);
    glUniform2f(uniforms[UNIFORM_CENTER], 0.5, 0.5);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedDistortionButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"DistortionShader" fragmentShader:@"DistortionShader" forProgram:&baseProgram];

    [self.glView setDisplayFramebuffer];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_RADIUS], 0.25);
    glUniform2f(uniforms[UNIFORM_CENTER], 0.5, 0.5);
    glUniform1f(uniforms[UNIFORM_ASPECTRATIO], 720.0 / 1280.0);
    glUniform1f(uniforms[UNIFORM_SCALE], 0.5);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

- (IBAction)clickedRefractionButton
{
    glEnable(GL_TEXTURE_2D);

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    [self loadVertexShader:@"RefractionShader" fragmentShader:@"RefractionShader" forProgram:&baseProgram];

    [self.glView setDisplayFramebuffer];

    glUseProgram(baseProgram);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);
    glUniform1f(uniforms[UNIFORM_RADIUS], 0.25);
    glUniform2f(uniforms[UNIFORM_CENTER], 0.5, 0.5);
    glUniform1f(uniforms[UNIFORM_ASPECTRATIO], 720.0 / 1280.0);
    glUniform1f(uniforms[UNIFORM_REFRACTIVEINDEX], 1.71);

    glClearColor(0, 0, 0, 1.0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

#pragma mark - OpenGL ES 2.0 setup methods

- (BOOL)loadVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName forProgram:(GLuint *)programPointer;
{
    GLuint vertexShader, fragShader;

    NSString *vertShaderPathname, *fragShaderPathname;

    // Create shader program.
    *programPointer = glCreateProgram();

    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShaderName ofType:@"vsh"];
    if (![self compileShader:&vertexShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }

    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShaderName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }

    // Attach vertex shader to program.
    glAttachShader(*programPointer, vertexShader);

    // Attach fragment shader to program.
    glAttachShader(*programPointer, fragShader);

    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(*programPointer, ATTRIB_VERTEX, "position");
    glBindAttribLocation(*programPointer, ATTRIB_TEXTUREPOSITON, "inputTextureCoordinate");

    // Link program.
    if (![self linkProgram:*programPointer]) {
        NSLog(@"Failed to link program: %d", *programPointer);

        if (vertexShader) {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (*programPointer) {
            glDeleteProgram(*programPointer);
            *programPointer = 0;
        }

        return FALSE;
    }

    // Get uniform locations.
    uniforms[UNIFORM_BACKGROUND] = glGetUniformLocation(*programPointer, "backgroundFrame");
    uniforms[UNIFORM_ALPHABLEND] = glGetUniformLocation(*programPointer, "alphaBlendFrame");
    uniforms[UNIFORM_FILTER] = glGetUniformLocation(*programPointer, "filterFrame");
    uniforms[UNIFORM_MATRIX] = glGetUniformLocation(*programPointer, "matrix");
    uniforms[UNIFORM_TEXELWIDTH] = glGetUniformLocation(*programPointer, "imageWidthFactor");
    uniforms[UNIFORM_TEXELHEIGHT] = glGetUniformLocation(*programPointer, "imageHeightFactor");
    uniforms[UNIFORM_EDGESTRENGTH] = glGetUniformLocation(*programPointer, "edgeStrength");
    uniforms[UNIFORM_RADIUS] = glGetUniformLocation(*programPointer, "radius");
    uniforms[UNIFORM_ANGLE] = glGetUniformLocation(*programPointer, "angle");
    uniforms[UNIFORM_CENTER] = glGetUniformLocation(*programPointer, "center");
    uniforms[UNIFORM_ASPECTRATIO] = glGetUniformLocation(*programPointer, "aspectRatio");
    uniforms[UNIFORM_SCALE] = glGetUniformLocation(*programPointer, "scale");
    uniforms[UNIFORM_REFRACTIVEINDEX] = glGetUniformLocation(*programPointer, "refractiveIndex");
    //uniforms[UNIFORM_INPUTCOLOR] = glGetUniformLocation(*programPointer, "inputColor");
    //uniforms[UNIFORM_THRESHOLD] = glGetUniformLocation(*programPointer, "threshold");

    // Release vertex and fragment shaders.
    if (vertexShader) {
        glDeleteShader(vertexShader);
    }
    if (fragShader) {
        glDeleteShader(fragShader);
    }

    return TRUE;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;

    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return FALSE;
    }

    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;

    glLinkProgram(prog);

#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;

    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }

    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

#pragma mark - Private Methods

- (void)addSubviews
{
    UIButton *originalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [originalButton setFrame:CGRectMake(10.0f, 25.0f, 90.0f, 30.0f)];
    [originalButton setBackgroundColor:[UIColor clearColor]];
    [originalButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [originalButton.layer setBorderWidth:0.5f];
    [originalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [originalButton addTarget:self action:@selector(clickedOriginalButton) forControlEvents:UIControlEventTouchUpInside];
    [originalButton setTitle:@"original" forState:UIControlStateNormal];
    [self.view addSubview:originalButton];

    UIButton *scaleGrayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scaleGrayButton setFrame:CGRectMake(110.0f, 25.0f, 90.0f, 30.0f)];
    [scaleGrayButton setBackgroundColor:[UIColor clearColor]];
    [scaleGrayButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [scaleGrayButton.layer setBorderWidth:0.5f];
    [scaleGrayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scaleGrayButton addTarget:self action:@selector(clickedGrayScaleButton) forControlEvents:UIControlEventTouchUpInside];
    [scaleGrayButton setTitle:@"gray scale" forState:UIControlStateNormal];
    [self.view addSubview:scaleGrayButton];

    UIButton *sepiaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sepiaButton setFrame:CGRectMake(210.0f, 25.0f, 90.0f, 30.0f)];
    [sepiaButton setBackgroundColor:[UIColor clearColor]];
    [sepiaButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [sepiaButton.layer setBorderWidth:0.5f];
    [sepiaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sepiaButton addTarget:self action:@selector(clickedSepiaButton) forControlEvents:UIControlEventTouchUpInside];
    [sepiaButton setTitle:@"sepia" forState:UIControlStateNormal];
    [self.view addSubview:sepiaButton];

    UIButton *alphaBlendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [alphaBlendButton setFrame:CGRectMake(10, 60.0f, 90.0f, 30.0f)];
    [alphaBlendButton setBackgroundColor:[UIColor clearColor]];
    [alphaBlendButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [alphaBlendButton.layer setBorderWidth:0.5f];
    [alphaBlendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alphaBlendButton addTarget:self action:@selector(clickedAlphaBlendButton) forControlEvents:UIControlEventTouchUpInside];
    [alphaBlendButton setTitle:@"alpha blend" forState:UIControlStateNormal];
    [self.view addSubview:alphaBlendButton];

    UIButton *lookupFilterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lookupFilterButton setFrame:CGRectMake(110, 60.0f, 90.0f, 30.0f)];
    [lookupFilterButton setBackgroundColor:[UIColor clearColor]];
    [lookupFilterButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [lookupFilterButton.layer setBorderWidth:0.5f];
    [lookupFilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookupFilterButton addTarget:self action:@selector(clickedLookupFilterButton) forControlEvents:UIControlEventTouchUpInside];
    [lookupFilterButton setTitle:@"lookup filter" forState:UIControlStateNormal];
    [self.view addSubview:lookupFilterButton];

    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateButton setFrame:CGRectMake(210, 60.0f, 90.0f, 30.0f)];
    [rotateButton setBackgroundColor:[UIColor clearColor]];
    [rotateButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [rotateButton.layer setBorderWidth:0.5f];
    [rotateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rotateButton addTarget:self action:@selector(clickedRotateButton) forControlEvents:UIControlEventTouchUpInside];
    [rotateButton setTitle:@"rotate" forState:UIControlStateNormal];
    [self.view addSubview:rotateButton];

    UIButton *sketchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sketchButton setFrame:CGRectMake(10, 95.0f, 60.0f, 30.0f)];
    [sketchButton setBackgroundColor:[UIColor clearColor]];
    [sketchButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [sketchButton.layer setBorderWidth:0.5f];
    [sketchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sketchButton addTarget:self action:@selector(clickedSketchButton) forControlEvents:UIControlEventTouchUpInside];
    [sketchButton setTitle:@"sketch" forState:UIControlStateNormal];
    [self.view addSubview:sketchButton];

    UIButton *blurButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [blurButton setFrame:CGRectMake(80, 95.0f, 60.0f, 30.0f)];
    [blurButton setBackgroundColor:[UIColor clearColor]];
    [blurButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [blurButton.layer setBorderWidth:0.5f];
    [blurButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [blurButton addTarget:self action:@selector(clickedBlurButton) forControlEvents:UIControlEventTouchUpInside];
    [blurButton setTitle:@"blur" forState:UIControlStateNormal];
    [self.view addSubview:blurButton];

    UIButton *bilateralButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bilateralButton setFrame:CGRectMake(150, 95.0f, 60.0f, 30.0f)];
    [bilateralButton setBackgroundColor:[UIColor clearColor]];
    [bilateralButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [bilateralButton.layer setBorderWidth:0.5f];
    [bilateralButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bilateralButton addTarget:self action:@selector(clickedBilateralButton) forControlEvents:UIControlEventTouchUpInside];
    [bilateralButton setTitle:@"bilateral" forState:UIControlStateNormal];
    [self.view addSubview:bilateralButton];

    UIButton *smoothingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [smoothingButton setFrame:CGRectMake(220, 95.0f, 80.0f, 30.0f)];
    [smoothingButton setBackgroundColor:[UIColor clearColor]];
    [smoothingButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [smoothingButton.layer setBorderWidth:0.5f];
    [smoothingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [smoothingButton addTarget:self action:@selector(clickedSmoothingButton) forControlEvents:UIControlEventTouchUpInside];
    [smoothingButton setTitle:@"smoothing" forState:UIControlStateNormal];
    [self.view addSubview:smoothingButton];

    UIButton *swirlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [swirlButton setFrame:CGRectMake(10, 568 - 30 - 10, 90.0f, 30.0f)];
    [swirlButton setBackgroundColor:[UIColor clearColor]];
    [swirlButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [swirlButton.layer setBorderWidth:0.5f];
    [swirlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [swirlButton addTarget:self action:@selector(clickedSwirlButton) forControlEvents:UIControlEventTouchUpInside];
    [swirlButton setTitle:@"swirl" forState:UIControlStateNormal];
    [self.view addSubview:swirlButton];

    UIButton *distortionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [distortionButton setFrame:CGRectMake(110, 568 - 30 - 10, 90.0f, 30.0f)];
    [distortionButton setBackgroundColor:[UIColor clearColor]];
    [distortionButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [distortionButton.layer setBorderWidth:0.5f];
    [distortionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [distortionButton addTarget:self action:@selector(clickedDistortionButton) forControlEvents:UIControlEventTouchUpInside];
    [distortionButton setTitle:@"distortion" forState:UIControlStateNormal];
    [self.view addSubview:distortionButton];

    UIButton *refractionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refractionButton setFrame:CGRectMake(210, 568 - 30 - 10, 90.0f, 30.0f)];
    [refractionButton setBackgroundColor:[UIColor clearColor]];
    [refractionButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [refractionButton.layer setBorderWidth:0.5f];
    [refractionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refractionButton addTarget:self action:@selector(clickedRefractionButton) forControlEvents:UIControlEventTouchUpInside];
    [refractionButton setTitle:@"refraction" forState:UIControlStateNormal];
    [self.view addSubview:refractionButton];
}

- (CGImageRef)imageRef:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    /* Get informations about the Y plane */
    uint8_t *YPlaneAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);

    //    /* the problematic part of code */
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, YPlaneAddress,
                                                                  height * bytesPerRow, NULL);
    CGImageRef newImage = CGImageCreate(width, height, 8, 8, bytesPerRow,
                                        colorSpace, kCGImageAlphaNone, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    CGColorSpaceRelease(colorSpace);

    return newImage;
}

#pragma mark - UIImage Methods

- (UIImage *)resizeImage:(CGSize)size image:(UIImage *)image
{
    float resizeWidth = size.width;
    float resizeHeight = size.height;

    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

- (GLuint)textureWithImageName:(NSString *)fileName
{
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }

    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);

    GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));

    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);

    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);

    CGContextRelease(spriteContext);

    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);

    free(spriteData);
    return texName;
}

#pragma mark - private
- (void)drawImageOnOpenGLSpace
{
    glEnable(GL_TEXTURE_2D);

    backgroundTexture = [self textureWithImageName:@"sample3.jpg"];

    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat textureVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    [self.glView setDisplayFramebuffer];
    glUseProgram(baseProgram);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(uniforms[UNIFORM_BACKGROUND], 0);

    // Update attribute values.
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self.glView presentFramebuffer];
}

@end
