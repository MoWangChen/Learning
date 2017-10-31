//
//  GLObject.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/12.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import "GLContext.h"
@interface GLObject : NSObject

@property (nonatomic, strong) GLContext *context;
@property (nonatomic, assign) GLKMatrix4 modelMatrix;

- (instancetype)initWithGLContext:(GLContext *)context;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
