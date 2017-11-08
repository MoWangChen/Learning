//
//  GLGeometry.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/1.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef enum : NSInteger {
    GLGeometryTypeTriangles,
    GLGeometryTypeTriangleStrip,
    GLGeometryTypeTriangleFan
} GLGeometryType;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat normalX;
    GLfloat normalY;
    GLfloat normalZ;
    GLfloat u;
    GLfloat v;
} GLVertex;

static inline GLVertex GLVertexMake(GLfloat x,
                                    GLfloat y,
                                    GLfloat z,
                                    GLfloat normalX,
                                    GLfloat normalY,
                                    GLfloat normalZ,
                                    GLfloat u,
                                    GLfloat v) {
    GLVertex vertex;
    vertex.x = x,
    vertex.y = y,
    vertex.z = z,
    vertex.normalX = normalX;
    vertex.normalY = normalY;
    vertex.normalZ = normalZ;
    vertex.u = u;
    vertex.v = v;
    return vertex;
}

@interface GLGeometry : NSObject

@property (nonatomic, assign) GLGeometryType geometryType;

- (instancetype)initWithGeometryType:(GLGeometryType)geometryType;
- (void)appendVertex:(GLVertex)vertex;
- (GLuint)getVBO;
- (int)vertexCount;

@end
