//
//  RigidBody.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/13.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    RigidBodyShapeTypeBox
} RigidBodyShapeType;

typedef struct
{
    RigidBodyShapeType type;
    union {
        struct {
            GLKVector3 size;
        } box;
        struct {
            GLfloat radius;
            GLfloat height;
        } cylinder;
    } shapes;
} RigidBodyShape;

@interface RigidBody : NSObject

@property (nonatomic, assign) GLfloat mass; // 重量
@property (nonatomic, assign) GLKVector3 velocity; // 速度
@property (nonatomic, assign) GLfloat restitution; // 弹性系数
@property (nonatomic, assign) GLfloat friction; // 摩擦系数

@property (nonatomic, assign) RigidBodyShape rigidbodyShape;
@property (nonatomic, assign) GLKMatrix4 rigidBodyTransform;

@property (nonatomic, assign) void * rawBtRigidBodyPointer;

- (instancetype)initAsBox:(GLKVector3)size;
@end
