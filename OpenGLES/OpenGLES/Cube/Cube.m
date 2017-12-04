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
    
    GLuint indiceVbo;
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
        [self genIndiceVBO];
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
    glBufferData(GL_ARRAY_BUFFER, 8 * 8 * sizeof(GLfloat), [self cubeVertex], GL_STATIC_DRAW);
}

- (void)genIndiceVBO
{
    glGenBuffers(1, &indiceVbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indiceVbo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 36 * sizeof(GLushort), [self cubeVertexIndice], GL_STATIC_DRAW);
}

- (void)genVAO
{
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indiceVbo);
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
//    [glContext drawTrianglesWithIndiceVAO:indiceVbo vertexCount:36];
}

#pragma mark - cube
- (GLfloat *)cubeVertex
{
    static GLfloat cubeVertex[] = {
        0.5f,  -0.5f,   0.5f,   1,  0,  0, 0,  1,   // vertexA
        0.5f,  -0.5f,  -0.5f,   1,  0,  0, 1,  1,   // vertexB
        0.5f,   0.5f,  -0.5f,   1,  0,  0, 1,  0,   // vertexC
        0.5f,   0.5f,   0.5f,   1,  0,  0, 0,  0,   // vertexD
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0, 0,  1,  // vertexE
        -0.5f,  -0.5f,  -0.5f,  -1,  0,  0, 1,  1,  // vertexF
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0, 1,  0,  // vertexG
        -0.5f,   0.5f,   0.5f,  -1,  0,  0, 0,  0,  // vertexH
    };
    return cubeVertex;
}

- (GLushort *)cubeVertexIndice
{
    static GLushort cubeVertexIndice[] = {
        0,
        1,
        2,
        2,
        3,
        0,
        
        4,
        5,
        6,
        6,
        7,
        4,
        
        7,
        6,
        2,
        2,
        3,
        7,
        
        4,
        5,
        1,
        1,
        0,
        4,
        
        7,
        4,
        0,
        0,
        3,
        7,
        
        6,
        5,
        1,
        1,
        2,
        6,
    };
    return cubeVertexIndice;
}

- (GLfloat *)cubeData
{
    static GLfloat cubeData[] = {
        0.5f,  -0.5f,   0.5f,   1,  0,  0, 0,  1,   // vertexA
        0.5f,  -0.5f,  -0.5f,   1,  0,  0, 1,  1,   // vertexB
        0.5f,   0.5f,  -0.5f,   1,  0,  0, 1,  0,   // vertexC
        0.5f,   0.5f,  -0.5f,   1,  0,  0, 1,  0,   // vertexC
        0.5f,   0.5f,   0.5f,   1,  0,  0, 0,  0,   // vertexD
        0.5f,  -0.5f,   0.5f,   1,  0,  0, 0,  1,   // vertexA
        
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0, 0,  1,  // vertexE
        -0.5f,  -0.5f,  -0.5f,  -1,  0,  0, 1,  1,  // vertexF
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0, 1,  0,  // vertexG
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0, 1,  0,  // vertexG
        -0.5f,   0.5f,   0.5f,  -1,  0,  0, 0,  0,  // vertexH
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0, 0,  1,  // vertexE
        
        -0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  1,  // vertexH
        -0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  1,  // vertexG
        0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  0,   // vertexC
        0.5f,    0.5f,   -0.5f,   0,   1,  0,  1,  0,   // vertexC
        0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  0,   // vertexD
        -0.5f,    0.5f,    0.5f,   0,   1,  0,  0,  1,  // vertexH
        
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  1,  // vertexE
        -0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  1,  // vertexF
        0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  0,   // vertexB
        0.5f,   -0.5f,   -0.5f,   0,  -1,  0,  1,  0,   // vertexB
        0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  0,   // vertexA
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,  0,  1,  // vertexE
        
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,  // vertexH
        -0.5f, -0.5f,   0.5f,   0,  0,   1, 1,  1,  // vertexE
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,  // vertexA
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,  // vertexA
        0.5f,   0.5f,   0.5f,   0,  0,   1, 0,  0,  // vertexD
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,  // vertexH
        
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1, 0,  1,  // vertexG
        -0.5f, -0.5f,  -0.5f,   0,  0,  -1, 1,  1,  // vertexF
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1, 1,  0,  // vertexB
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1, 1,  0,  // vertexB
        0.5f,   0.5f,  -0.5f,   0,  0,  -1, 0,  0,  // vertexC
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1, 0,  1,  // vertexG
    };
    
    return cubeData;
}
@end
