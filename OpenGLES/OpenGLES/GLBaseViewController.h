//
//  GLBaseViewController.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/16.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLBaseViewController : GLKViewController

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLuint shaderProgram;
@property (nonatomic, assign) GLfloat elapsedTime;

- (void)update;
- (void)bindAttribs:(GLfloat *)triangleData;
- (void)bindAttributes:(GLfloat *)triangleData;

@end