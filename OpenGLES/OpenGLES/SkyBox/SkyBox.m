//
//  SkyBox.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/8.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "SkyBox.h"

@implementation SkyBox

- (void)draw:(GLContext *)glContext
{
    glCullFace(GL_FRONT);
    glDepthMask(GL_FALSE);
    [super draw:glContext];
    glDepthMask(GL_TRUE);
    glCullFace(GL_BACK);
}

@end
