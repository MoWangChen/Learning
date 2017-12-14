//
//  BulletUtils.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/13.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <GLKit/GLKit.h>
#include "Bullet/btBulletCollisionCommon.h"

static btTransform btTransformFromGLK(GLKMatrix4 glkMatrix)
{
    GLKQuaternion glkQuaternion = GLKQuaternionMakeWithMatrix4(glkMatrix);
    btQuaternion quaternion(glkQuaternion.x, glkQuaternion.y, glkQuaternion.z, glkQuaternion.w);
    btTransform btTransform(quaternion, btVector3(glkMatrix.m30, glkMatrix.m31, glkMatrix.m32));
    return btTransform;
}

static GLKMatrix4 glkTransformFromBT(btTransform bttransform) {
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(bttransform.getOrigin().x(), bttransform.getOrigin().y(), bttransform.getOrigin().z());
    
    btQuaternionFloatData quaternionFloatData;
    bttransform.getRotation().serialize(quaternionFloatData);
    GLKQuaternion quaternion = GLKQuaternionMake((float)quaternionFloatData.m_floats[0], (float)quaternionFloatData.m_floats[1], (float)quaternionFloatData.m_floats[2], (float)quaternionFloatData.m_floats[3]);
    GLKMatrix4 glkTransform = GLKMatrix4Multiply(translateMatrix, GLKMatrix4MakeWithQuaternion(quaternion));
    return glkTransform;
}
