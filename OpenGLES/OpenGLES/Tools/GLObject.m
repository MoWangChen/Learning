//
//  GLObject.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/12.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@implementation GLObject

- (instancetype)initWithGLContext:(GLContext *)context
{
    if (self = [super init]) {
        self.context = context;
    }
    return self;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
    
}

- (void)draw:(GLContext *)glContext
{
    
}

@end
