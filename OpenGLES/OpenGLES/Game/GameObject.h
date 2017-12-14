//
//  GameObject.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/13.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLObject.h"
#import "RigidBody.h"

@interface GameObject : NSObject

@property (nonatomic, strong) GLObject *geometry;
@property (nonatomic, strong) RigidBody *rigidBody;

- (instancetype)initWithGeometry:(GLObject *)geometry rigidBody:(RigidBody *)rigidBody;
- (void)update:(NSTimeInterval)deltaTime;

@end
