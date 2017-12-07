//
//  Camera.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/6.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Camera : NSObject

@property (nonatomic, assign) GLKVector3 forward;
@property (nonatomic, assign) GLKVector3 up;
@property (nonatomic, assign) GLKVector3 position;

- (void)setupCameraWithEye:(GLKVector3)eye lookAt:(GLKVector3)lookAt up:(GLKVector3)up;
- (void)mirrorTo:(Camera *)targetCamera plane:(GLKVector4)plane;
- (GLKMatrix4)cameraMatrix;

@end
