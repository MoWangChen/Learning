//
//  Cube.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/31.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Cube.h"

@interface Cube ()
{
    GLuint vbo;
    GLuint vao;
}
@property (nonatomic, strong) GLKTextureInfo *diffuseTexture;

@end

@implementation Cube

- (instancetype)initWithGLContext:(GLContext *)context
{
    if (self = [super initWithGLContext:context]) {
        [self genTexture];
        self.modelMatrix = GLKMatrix4Identity;
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

- (void)genTexture
{
    NSString *textureFile = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"jpg"];
    NSError *error;
    self.diffuseTexture = [GLKTextureLoader textureWithContentsOfFile:textureFile options:0 error:&error];
}

- (void)genVBO
{
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, 36 * 8 * sizeof(GLfloat), [self cubeData], GL_STATIC_DRAW);
}

- (void)genVAO
{
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    [self.context bindAttributes:NULL];
    
    glBindVertexArrayOES(0);
}

- (void)draw:(GLContext *)glContext
{
    [glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        [glContext setUniformMatrix4fv:@"normalMatrix" value:normalMatrix];
    }
    
    [glContext bindTexture:self.diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [glContext drawTrianglesWithVAO:vao vertexCount:36];
}

- (GLfloat *)cubeData
{
    static GLfloat cubeData[] = {
        0.5f,  -0.5f,   0.5f,   1,  0,  0, 0,  1,
        0.5f,  -0.5f,  -0.5f,   1,  0,  0, 1,  1,
        0.5f,   0.5f,  -0.5f,   1,  0,  0, 1,  0,
        0.5f,   0.5f,  -0.5f,   1,  0,  0, 1,  0,
        0.5f,   0.5f,   0.5f,   1,  0,  0, 0,  0,
        0.5f,  -0.5f,   0.5f,   1,  0,  0, 0,  1,
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0, 0,  1,
        -0.5f,  -0.5f,  -0.5f,  -1,  0,  0, 1,  1,
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0, 1,  0,
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0, 1,  0,
        -0.5f,   0.5f,   0.5f,  -1,  0,  0, 0,  0,
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0, 0,  1,
        
        -0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  1,
        -0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  1,
        0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  0,
        0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  0,
        0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  0,
        -0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  1,
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  1,
        -0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  1,
        0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  0,
        0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  0,
        0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  0,
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  1,
        
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,
        -0.5f, -0.5f,   0.5f,   0,  0,   1, 1,  1,
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,
        0.5f,   0.5f,   0.5f,   0,  0,   1, 0,  0,
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1, 0,  1,
        -0.5f, -0.5f,  -0.5f,   0,  0,  -1, 1,  1,
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1, 1,  0,
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1, 1,  0,
        0.5f,   0.5f,  -0.5f,   0,  0,  -1, 0,  0,
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1, 0,  1,
    };
    
    return cubeData;
}
@end
