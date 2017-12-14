//
//  PhysicsEngine.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/12.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "PhysicsEngine.h"
#include "Bullet/btBulletDynamicsCommon.h"
#include "Bullet/btBulletCollisionCommon.h"
#include "BulletUtils.mm"

@interface PhysicsEngine () {
    btDefaultCollisionConfiguration *configration; //细粒度的碰撞检测
    btCollisionDispatcher *dispatcher;
    btSequentialImpulseConstraintSolver *solver; // 解决受力, 约束
    btDbvtBroadphase *broadphase;   // 快速碰撞检测
    
    btDiscreteDynamicsWorld *world; // 重力世界
    
    NSMutableSet *rigidBodies;
}
@end

@implementation PhysicsEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        configration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(configration);
        solver = new btSequentialImpulseConstraintSolver();
        broadphase = new btDbvtBroadphase();
        
        world = new btDiscreteDynamicsWorld(dispatcher, broadphase, solver, configration);
        
        world->setGravity(btVector3(0, -9.8, 0));
        
        rigidBodies = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc
{
    delete configration;
    delete dispatcher;
    delete solver;
    delete broadphase;
    delete world;
    
    for (RigidBody *rigidBody in rigidBodies) {
        btRigidBody *btrigidBody = (btRigidBody *)rigidBody.rawBtRigidBodyPointer;
        if (btrigidBody) {
            delete btrigidBody;
        }
    }
}

- (void)update:(NSTimeInterval)deltaTime {
    world->stepSimulation((btScalar)deltaTime);
    [self syncRigidBodies];
}

- (void)addRigidBody:(RigidBody *)rigidBody {
    btTransform defaultTransform = btTransformFromGLK(rigidBody.rigidBodyTransform);
    btDefaultMotionState *motionState = new btDefaultMotionState(defaultTransform);
    btVector3 fallInertia(0, 0, 0);
    btCollisionShape *collisionShape = [self buildCollisionShape:rigidBody];
    collisionShape->calculateLocalInertia(rigidBody.mass, fallInertia);
    btRigidBody *btrigidBody = new btRigidBody(rigidBody.mass, motionState, collisionShape, fallInertia);
    btrigidBody->setRestitution(rigidBody.restitution);
    btrigidBody->setFriction(rigidBody.friction);
    
    world->addRigidBody(btrigidBody);
    btrigidBody->setUserPointer((__bridge void *)rigidBody);
    rigidBody.rawBtRigidBodyPointer = btrigidBody;
    [rigidBodies addObject:rigidBody];
}

- (void)syncRigidBodies {
    for (RigidBody *rigidBody in rigidBodies) {
        btRigidBody *btrigidBody = (btRigidBody *)rigidBody.rawBtRigidBodyPointer;
        rigidBody.rigidBodyTransform = glkTransformFromBT(btrigidBody->getWorldTransform());
    }
}

- (btCollisionShape *)buildCollisionShape:(RigidBody *)rigidBody {
    if (rigidBody.rigidbodyShape.type == RigidBodyShapeTypeBox) {
        GLKVector3 boxSize = rigidBody.rigidbodyShape.shapes.box.size;
        return new btBoxShape(btVector3(boxSize.x / 2.0, boxSize.y / 2.0, boxSize.z / 2.0));
    }
    return new btSphereShape(1.0);
}


















@end
