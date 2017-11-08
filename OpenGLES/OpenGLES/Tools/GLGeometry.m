//
//  GLGeometry.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/1.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLGeometry.h"


@interface GLGeometry ()
{
    GLuint vbo;
    BOOL vboValid;
}

@property (nonatomic, strong) NSMutableData *vertexData;
@end

@implementation GLGeometry

- (instancetype)initWithGeometryType:(GLGeometryType)geometryType
{
    self = [super init];
    if (self) {
        self.geometryType = geometryType;
        vboValid = NO;
        self.vertexData = [NSMutableData data];
    }
    return self;
}

- (void)dealloc
{
    if (vboValid) {
        glDeleteBuffers(1, &vbo);
    }
}

- (void)appendVertex:(GLVertex)vertex
{
    void *pVertex = (void *)(&vertex);
    NSUInteger size = sizeof(GLVertex);
    [self.vertexData appendBytes:pVertex length:size];
}

- (GLuint)getVBO
{
    if (vboValid == NO) {
        glGenBuffers(1, &vbo);
        vboValid = YES;
        
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], self.vertexData.bytes, GL_STATIC_DRAW);
    }
    return vbo;
}

- (int)vertexCount
{
    return (int)[self.vertexData length] / sizeof(GLVertex);
}

@end
