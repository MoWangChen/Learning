//
//  Cube.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/31.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@interface Cube : GLObject

- (id)initWithGLContext:(GLContext *)context diffuseMap:(GLKTextureInfo *)diffuseMap;

@end
