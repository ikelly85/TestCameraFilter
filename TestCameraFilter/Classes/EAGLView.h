//
//  EAGLView.h
//  TestCameraFilter
//
//  Created by HAN on 2016. 2. 1..
//  Copyright © 2016년 CampMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface EAGLView : UIView

@property (nonatomic, strong) EAGLContext *context;

- (void)startRenderLoop;
- (void)stopRenderLoop;

- (void)setDisplayFramebuffer;
- (BOOL)presentFramebuffer;
- (BOOL)presentFramebuffer:(GLuint)frameBuffer;

- (GLint)getFrameBufferWidth;
- (GLint)getFrameBufferHeight;
- (GLuint)getColorRenderBuffer;

@end
