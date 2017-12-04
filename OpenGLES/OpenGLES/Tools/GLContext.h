//
//  GLContext.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/10.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <GLKit/GLKit.h>

@class GLGeometry;
@interface GLContext : NSObject

@property (nonatomic, assign) GLuint program;

+ (id)contextWithVertexShaderPath:(NSString *)vertexShaderPath fragmentShaderPath:(NSString *)fragmentShaderPath;
- (id)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;
- (void)active;

- (void)bindAttributes:(GLfloat *)triangleData;

// draw
- (void)drawTriangles:(GLfloat *)triangleData vertexCount:(GLint)vertexCount;
- (void)drawTrianglesWithVBO:(GLuint)vbo vertexCount:(GLint)vertexCount;
- (void)drawTrianglesWithVAO:(GLuint)vao vertexCount:(GLint)vertexCount;
- (void)drawTrianglesWithIndiceVAO:(GLuint)vao vertexCount:(GLint)vertexCount;
- (void)drawGeometry:(GLGeometry *)geometry;

// uniform setters
- (void)setUniform1i:(NSString *)uniformName value:(GLuint)value;
- (void)setUniform1f:(NSString *)uniformName value:(GLfloat)value;
- (void)setUniform3fv:(NSString *)uniformName value:(GLKVector3)value;
- (void)setUniformMatrix4fv:(NSString *)uniformName value:(GLKMatrix4)value;

// textture
- (void)bindTexture:(GLKTextureInfo *)textInfo to:(GLenum)textureChannel uniformName:(NSString *)uniformName;
- (void)bindTextureName:(GLuint)textureName to:(GLenum)textureChannel uniformName:(NSString *)uniformName;
- (void)bindCubeTexture:(GLKTextureInfo *)textInfo to:(GLenum)textureChannel uniformName:(NSString *)uniformName;
@end
