//
//  Cylinder.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@interface Cylinder : GLObject

@property (nonatomic, assign) GLfloat height;
@property (nonatomic, assign) int sideCount;
@property (nonatomic, assign) GLfloat radius;

- (instancetype)initWithGLContext:(GLContext *)context sides:(int)sides radius:(GLfloat)radius height:(GLfloat)height texture:(GLKTextureInfo *)texture;
- (void)draw:(GLContext *)glContext;

@end
