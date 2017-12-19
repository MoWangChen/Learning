//
//  Billboard.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@interface Billboard : GLObject
@property (nonatomic, assign) GLKVector2 billboardSize;
@property (nonatomic, assign) GLKVector3 billboardCenterPosition;
@property (nonatomic, assign) BOOL lockToYAxis;

- (instancetype)initWithGLContext:(GLContext *)context texture:(GLKTextureInfo *)texture;

@end
