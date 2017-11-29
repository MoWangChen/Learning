//
//  Plane.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/28.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Plane.h"

@interface Plane ()
{
    GLuint vbo;
    GLuint vao;
    GLuint diffuseTexture;
}
@end

@implementation Plane

- (instancetype)initWithGLContext:(GLContext *)context texture:(GLuint)texture
{
    self = [super initWithGLContext:context];
    if (self) {
        self.modelMatrix = GLKMatrix4Identity;
        diffuseTexture = texture;
        [self genVBO];
        [self genVAO];
    }
    return self;
}

- (void)dealloc
{
    glDeleteBuffers(1, &vbo);
    glDeleteBuffers(1, &vao);
}

- (GLfloat *)planeData
{
    static GLfloat planeData[] = {
        -0.5,   0.5,    0.5,    0,  0,  1,  0,  0,
        -0.5,   -0.5,   0.5,    0,  0,  1,  0,  1,
        0.5,    -0.5,   0.5,    0,  0,  1,  1,  1,
        0.5,    -0.5,   0.5,    0,  0,  1,  1,  1,
        0.5,    0.5,    0.5,    0,  0,  1,  1,  0,
        -0.5,   0.5,    0.5,    0,  0,  1,  0,  0,
    };
    return planeData;
}

- (void)genVBO
{
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, 6 * 8 * sizeof(GLfloat), [self planeData], GL_STATIC_DRAW);
}

- (void)genVAO
{
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    [self.context bindAttributes:NULL];
    
    glBindVertexArrayOES(0);
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
    
}

- (void)draw:(GLContext *)glContext
{
    [glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    [glContext setUniformMatrix4fv:@"normalMatrix" value:canInvert? normalMatrix : GLKMatrix4Identity];
    [glContext bindTextureName:diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [glContext drawTrianglesWithVAO:vao vertexCount:6];
}



@end
