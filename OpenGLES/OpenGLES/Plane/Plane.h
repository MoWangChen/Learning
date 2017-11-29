//
//  Plane.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/28.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@interface Plane : GLObject

- (instancetype)initWithGLContext:(GLContext *)context texture:(GLuint)texture;

@end
