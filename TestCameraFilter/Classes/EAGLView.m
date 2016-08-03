//
//  EAGLView.m
//  TestCameraFilter
//
//  Created by HAN on 2016. 2. 1..
//  Copyright © 2016년 CampMobile. All rights reserved.
//

#import "EAGLView.h"

@interface EAGLView () {
    GLint framebufferWidth;
    GLint framebufferHeight;

    GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;

    CADisplayLink *displayLink;

    BOOL useDepthBuffer;
}

@end

@implementation EAGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithCoder:(NSCoder *)coder
{
    //call the init method of our parent view
    self = [super initWithCoder:coder];

    //now we create the core animation EAGL layer
    if (self == nil) {
        return nil;
    }

    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

    //we don't want a transparent surface
    eaglLayer.opaque = TRUE;

    //here we configure the properties of our canvas, most important is the color depth RGBA8 !
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                    nil];

    //create an OpenGL ES 2 context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    //if this failed or we cannot set the context for some reason, quit
    if (self.context == nil || [EAGLContext setCurrentContext:self.context] == NO) {
        NSLog(@"Could not create context!");
        return nil;
    }

    //do we want to use a depth buffer?
    //for 3D applications we usually do, so we'll set it to true by default
    useDepthBuffer = FALSE;

    /*

       //we did not initialize our lesson yet:
       lessonIsInitialized = FALSE;

     */

    //default values for our OpenGL buffers
    defaultFramebuffer = 0;
    colorRenderbuffer = 0;
    depthRenderbuffer = 0;

    [self startRenderLoop];


    return self;
}

- (void)layoutSubviews
{
    [self deleteFramebuffer];
}

//cleanup our view
- (void)dealloc
{
    [self deleteFramebuffer];
}

#pragma mark - Public Methods

//our render loop just tells the iOS device that we want to keep refreshing our view all the time
- (void)startRenderLoop
{
    //check whether the loop is already running
    if (displayLink == nil) {
        //the display link specifies what to do when the screen has to be redrawn,
        //here we use the selector (method) drawFrame
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];

        //by adding the display link to the run loop our draw method will be called 60 times per second
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        NSLog(@"Starting Render Loop");
    }
}

//we have to be able to stop the render loop
- (void)stopRenderLoop
{
    if (displayLink != nil) {
        //if the display link is present, we invalidate it (so the loop stops)
        [displayLink invalidate];
        displayLink = nil;
        NSLog(@"Stopping Render Loop");
    }
}

- (void)setDisplayFramebuffer
{
    if (self.context) {
        //        [EAGLContext setCurrentContext:context];

        if (defaultFramebuffer == 0) {
            [self createFramebuffer];
        }

        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);

        glViewport(0, 0, framebufferWidth, framebufferHeight);
    }
}

- (BOOL)presentFramebuffer
{
    return [self presentFramebuffer:defaultFramebuffer];
}

- (BOOL)presentFramebuffer:(GLuint)frameBuffer
{
    BOOL success = FALSE;

    if (self.context) {
        //      [EAGLContext setCurrentContext:context];

        glBindRenderbuffer(GL_RENDERBUFFER, frameBuffer);

        success = [self.context presentRenderbuffer:GL_RENDERBUFFER];
    }

    return success;
}

#pragma mark - Private Methods

- (void)createFramebuffer
{
    //this method assumes, that the context is valid and current, and that the default framebuffer has not been created yet!
    //this works, because as soon as we call glGenFramebuffers the value will be > 0
    assert(defaultFramebuffer == 0);

    NSLog(@"EAGLView: creating Framebuffer");

    // Create default framebuffer object and bind it
    glGenFramebuffers(1, &defaultFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);

    // Create color render buffer
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);

    //get the storage from iOS so it can be displayed in the view
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    //get the frame's width and height
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);

    //attach this color buffer to our framebuffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

    /*
       //our lesson needs to know the size of the renderbuffer so it can work with the right aspect ratio
       if (lesson != NULL) {
        lesson->setRenderbufferSize(framebufferWidth, framebufferHeight);
       }

     */

    if (useDepthBuffer) {
        //create a depth renderbuffer
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        //create the storage for the buffer, optimized for depth values, same size as the colorRenderbuffer
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        //attach the depth buffer to our framebuffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    }

    //check that our configuration of the framebuffer is valid
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
}

//deleting the framebuffer and all the buffers it contains
- (void)deleteFramebuffer
{
    //we need a valid and current context to access any OpenGL methods
    if (self.context) {
        [EAGLContext setCurrentContext:self.context];

        //if the default framebuffer has been set, delete it.
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }

        //same for the renderbuffers, if they are set, delete them
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }

        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
    }
}

- (void)drawFrame
{
    //we need a context for rendering
    if (self.context != nil) {
        //make it the current context for rendering
        [EAGLContext setCurrentContext:self.context];

        //if our framebuffers have not been created yet, do that now!
        if (defaultFramebuffer == 0) {
            [self createFramebuffer];
        }

        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);


        //finally, get the color buffer we rendered to, and pass it to iOS
        //so it can display our awesome results!
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        [self.context presentRenderbuffer:GL_RENDERBUFFER];
    } else {
        NSLog(@"Context not set!");
    }
}

- (GLint)getFrameBufferWidth
{
    return framebufferWidth;
}

- (GLint)getFrameBufferHeight
{
    return framebufferHeight;
}

- (GLuint)getColorRenderBuffer
{
    return colorRenderbuffer;
}
@end
