//
//  RigidBody.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/13.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "RigidBody.h"

@implementation RigidBody

- (void)commonInit {
    self.mass = 1.0;
    self.velocity = GLKVector3Make(0, 0, 0);
    self.restitution = 0.2;
    self.friction = 0.8;
}

- (instancetype)initAsBox:(GLKVector3)size
{
    self = [super init];
    if (self) {
        RigidBodyShape rigidBodyShape;
        rigidBodyShape.type = RigidBodyShapeTypeBox;
        rigidBodyShape.shapes.box.size = size;
        self.rigidbodyShape = rigidBodyShape;
        
        [self commonInit];
    }
    return self;
}

@end
