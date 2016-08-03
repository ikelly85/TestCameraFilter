//
//  ViewController.h
//  TestCameraFilter
//
//  Created by HAN on 2016. 2. 1..
//  Copyright © 2016년 CampMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EAGLView.h"

@interface ViewController : UIViewController
{
    GLuint otherFrameBuffer;
}
@property (nonatomic, weak) IBOutlet EAGLView *glView;

@end
