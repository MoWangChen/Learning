//
//  AlphaMixtureViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/1.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "AlphaMixtureViewController.h"

@interface AlphaMixtureViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix;       // 变换矩阵

@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

@property (nonatomic, strong) GLKTextureInfo *opaqueTexture;
@property (nonatomic, strong) GLKTextureInfo *redTransparencyTexture;
@property (nonatomic, strong) GLKTextureInfo *grennTransparencyTexture;

@end

@implementation AlphaMixtureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lightDirection = GLKVector3Make(1, -1, 0);
    [self genTexture];
    [self cameraMatrixInit];
}

- (void)genTexture
{
    NSString *opaqueTextureFile = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"jpg"];
    NSString *redTransparencyTextureFile = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"];
    NSString *greenTransparencyTextureFile = [[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"];
    NSError *error;
    self.opaqueTexture = [GLKTextureLoader textureWithContentsOfFile:opaqueTextureFile options:0 error:&error];
    self.redTransparencyTexture = [GLKTextureLoader textureWithContentsOfFile:redTransparencyTextureFile options:0 error:nil];
    self.grennTransparencyTexture = [GLKTextureLoader textureWithContentsOfFile:greenTransparencyTextureFile options:0 error:nil];
    NSLog(@"%@",error);
}

#pragma mark - over ride
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    GLuint projectionMatrixUniformLocation = glGetUniformLocation(self.glContext.program, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixUniformLocation, 1, 0, self.projectionMatrix.m);
    
    GLuint cameraMatrixUniformLocation = glGetUniformLocation(self.glContext.program, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixUniformLocation, 1, 0, self.cameraMatrix.m);
    
    GLuint lightDirectionUniformLocation = glGetUniformLocation(self.glContext.program, "lightDirection");
    glUniform3fv(lightDirectionUniformLocation, 1, self.lightDirection.v);

    [self drawPlaneAt:GLKVector3Make(0, 0, -0.3) texture:self.opaqueTexture];
    
    glDepthMask(false);
    [self drawPlaneAt:GLKVector3Make(0.2, 0.2, 0) texture:self.grennTransparencyTexture];
    [self drawPlaneAt:GLKVector3Make(-0.2, 0.3, -0.5) texture:self.redTransparencyTexture];
    glDepthMask(true);

}

#pragma mark - private method
- (void)drawPlaneAt:(GLKVector3)position texture:(GLKTextureInfo *)texture
{
    self.modelMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    GLuint modelMatrixUniformLocation = glGetUniformLocation(self.glContext.program, "modelMatrix");
    glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, self.modelMatrix.m);
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        GLuint modelMatrixUniformLocation = glGetUniformLocation(self.glContext.program, "normalMatrix");
        glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, normalMatrix.m);
    }
    
    // 绑定纹理
    GLuint diffuseMapUniformLocation = glGetUniformLocation(self.glContext.program, "diffuseMap");
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture.name);
    glUniform1i(diffuseMapUniformLocation, 0);
    
    [self drawTriangle];
}

#pragma mark - transformMatrix
// 初始化各参数
- (void)cameraMatrixInit
{
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100);
    
    // 设置摄像机在 0, 0, 2坐标,看向0,0,0点. Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    
    // 初始化模型矩阵为单位矩阵
    self.modelMatrix = GLKMatrix4Identity;
}


#pragma mark - Draw Graph
- (void)drawTriangle
{
    static GLfloat triangleData[] = {
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,
        -0.5f, -0.5f,   0.5f,   0,  0,   1, 1,  1,
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,
        0.5f,  -0.5f,   0.5f,   0,  0,   1, 1,  0,
        0.5f,   0.5f,   0.5f,   0,  0,   1, 0,  0,
        -0.5f,  0.5f,   0.5f,   0,  0,   1, 0,  1,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
