//
//  PhysicsEngine.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/12.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RigidBody.h"

@interface PhysicsEngine : NSObject

- (void)update:(NSTimeInterval)deltaTime;
- (void)addRigidBody:(RigidBody *)rigidBody;

@end
