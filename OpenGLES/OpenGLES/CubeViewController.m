//
//  CubeViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "CubeViewController.h"

@interface CubeViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix;       // 变换矩阵

@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lightDirection = GLKVector3Make(0, -1, 0);
    [self cameraMatrixInit];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    GLuint projectionMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixUniformLocation, 1, 0, self.projectionMatrix.m);
    
    GLuint cameraMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixUniformLocation, 1, 0, self.cameraMatrix.m);
    
    GLuint modelMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "modelMatrix");
    glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, self.modelMatrix.m);
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        GLuint modelMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "normalMatrix");
        glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, normalMatrix.m);
    }
    
    GLuint lightDirectionUniformLocation = glGetUniformLocation(self.shaderProgram, "lightDirection");
    glUniform3fv(lightDirectionUniformLocation, 1, self.lightDirection.v);
    
    [self drawCube];
}

- (void)update
{
    [super update];
    
    float varyingFactor = (sin(self.elapsedTime) + 1) / 2.0;  // 0 ~ 1
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyingFactor + 1), 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 1, 1, 1);
    self.modelMatrix = rotateMatrix;
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
- (void)drawCube
{
    [self drawXPlans];
    [self drawYPlans];
    [self drawZPlans];
}

- (void)drawXPlans
{
    static GLfloat triangleData[] = {
         0.5f,  -0.5f,   0.5f,   1,  0,  0,
         0.5f,  -0.5f,  -0.5f,   1,  0,  0,
         0.5f,   0.5f,  -0.5f,   1,  0,  0,
         0.5f,   0.5f,  -0.5f,   1,  0,  0,
         0.5f,   0.5f,   0.5f,   1,  0,  0,
         0.5f,  -0.5f,   0.5f,   1,  0,  0,
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0,
        -0.5f,  -0.5f,  -0.5f,  -1,  0,  0,
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0,
        -0.5f,   0.5f,  -0.5f,  -1,  0,  0,
        -0.5f,   0.5f,   0.5f,  -1,  0,  0,
        -0.5f,  -0.5f,   0.5f,  -1,  0,  0,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 12);
}

- (void)drawYPlans
{
    static GLfloat triangleData[] = {
        -0.5f,    0.5f,    0.5f,   0,   1,  0,
        -0.5f,    0.5f,   -0.5f,   0,   1,  0,
         0.5f,    0.5f,   -0.5f,   0,   1,  0,
         0.5f,    0.5f,   -0.5f,   0,   1,  0,
         0.5f,    0.5f,    0.5f,   0,   1,  0,
        -0.5f,    0.5f,    0.5f,   0,   1,  0,
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,
        -0.5f,   -0.5f,   -0.5f,   0,  -1,  0,
         0.5f,   -0.5f,   -0.5f,   0,  -1,  0,
         0.5f,   -0.5f,   -0.5f,   0,  -1,  0,
         0.5f,   -0.5f,    0.5f,   0,  -1,  0,
        -0.5f,   -0.5f,    0.5f,   0,  -1,  0,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 12);
}

- (void)drawZPlans
{
    static GLfloat triangleData[] = {
        -0.5f,  0.5f,   0.5f,   0,  0,   1,
        -0.5f, -0.5f,   0.5f,   0,  0,   1,
        0.5f,  -0.5f,   0.5f,   0,  0,   1,
        0.5f,  -0.5f,   0.5f,   0,  0,   1,
        0.5f,   0.5f,   0.5f,   0,  0,   1,
        -0.5f,  0.5f,   0.5f,   0,  0,   1,
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1,
        -0.5f, -0.5f,  -0.5f,   0,  0,  -1,
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1,
        0.5f,  -0.5f,  -0.5f,   0,  0,  -1,
        0.5f,   0.5f,  -0.5f,   0,  0,  -1,
        -0.5f,  0.5f,  -0.5f,   0,  0,  -1,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 12);
}
@end
