//
//  Laser.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/11.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <GLKit/GLKit.h>

@class GLContext;

@interface Laser : NSObject

@property (nonatomic, assign) GLfloat life;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 direction;
@property (nonatomic, assign) float length;
@property (nonatomic, assign) float radius;

- (id)initWithLaserImage:(UIImage *)image;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
