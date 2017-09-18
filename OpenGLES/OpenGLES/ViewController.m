//
//  ViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/11.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) GLKMatrix4 transformMatrix;

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix1;      // 第一个矩形的模型变换
@property (nonatomic, assign) GLKMatrix4 modelMatrix2;      // 第二个矩形的模型变换

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.transformMatrix = GLKMatrix4Identity;
    [self cameraMatrixInit];
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    [self cameraTransformDrawInRect];
}

- (void)update
{
    [super update];
    
    [self cameraTransformMatrix];
}

#pragma mark - 摄像机
- (void)cameraTransformDrawInRect
{
    GLuint projectionMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixUniformLocation, 1, 0, self.projectionMatrix.m);
    GLuint cameraMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixUniformLocation, 1, 0, self.cameraMatrix.m);
    
    GLuint modelMatrixUniformLocation = glGetUniformLocation(self.shaderProgram, "modelMatrix");
    
    glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, self.modelMatrix1.m);
    [self drawTriangle];
    
    glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, self.modelMatrix2.m);
    [self drawTriangle];
}

// 初始化各参数
- (void)cameraMatrixInit
{
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100);
    
    // 设置摄像机在 0, 0, 2坐标,看向0,0,0点. Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    
    // 初始化矩形1,矩形2的模型矩阵为单位矩阵
    self.modelMatrix1 = GLKMatrix4Identity;
    self.modelMatrix2 = GLKMatrix4Identity;
}

- (void)cameraTransformMatrix
{
    float varyingFactor = (sin(self.elapsedTime) + 1) / 2.0;  // 0 ~ 1
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyingFactor + 1), 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 translateMatrix1 = GLKMatrix4MakeTranslation(-0.7, 0, 0);
    GLKMatrix4 rotateMatrix1 = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 0, 1, 0);
    self.modelMatrix1 = GLKMatrix4Multiply(translateMatrix1, rotateMatrix1);
    
    GLKMatrix4 translateMatrix2 = GLKMatrix4MakeTranslation(0.7, 0, 0);
    GLKMatrix4 rotateMatrix2 = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 0, 0, 1);
    self.modelMatrix2 = GLKMatrix4Multiply(translateMatrix2, rotateMatrix2);
}

#pragma mark - transformMatrix
- (void)transformDrawInRect
{
    GLuint transformUniformLocation = glGetUniformLocation(self.shaderProgram, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, self.transformMatrix.m);
    
    [self drawTriangle];
}

- (void)noarmalTransformMatrix
{
    float varyingFactor = sin(self.elapsedTime);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(varyingFactor, varyingFactor, 1.0);
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0.0, 0.0, 1.0);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(varyingFactor, 0.0, 0.0);
    // transformMatrix = translateMatrix * rotateMatrix * scaleMatrix
    // 矩阵会按照从右到左的顺序应用到position上,也就是先缩放(scale),再旋转(rotate),后平移(translate)
    // 如果这个顺序反过来,就完全不同了.从线性代数角度来讲,矩阵A乘以B, 不等于矩阵B乘以A
    self.transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(self.transformMatrix, scaleMatrix);
}

// 透视投影
- (void)perspectiveTransformMatrix
{
    float varyingFactor = self.elapsedTime;
    
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0, 1, 0);
 
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    // GLKMathDegreesToRadians 将角度转换成弧度
    GLKMatrix4 perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 10);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0, 0, -1.6);
    self.transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(perspectiveMatrix, self.transformMatrix);
}

// 正交投影
- (void)orthoTransformMatrix
{
    float varyingFactor = self.elapsedTime;
    
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0, 1, 0);
    
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    GLKMatrix4 orthMatrix = GLKMatrix4MakeOrtho(-viewWidth/2, viewWidth/2, -viewHeight/2, viewHeight/2, -10, -10);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(200, 200, 200);
    self.transformMatrix = GLKMatrix4Multiply(scaleMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(orthMatrix, self.transformMatrix);
}

#pragma mark - Draw Graph

- (void)drawTriangle
{
    static GLfloat triangleData[36] = {
        -0.5,   0.5f,   0,  1,  0,  0, // x, y, z, r, g, b,每一行存储一个点的信息,位置和颜色
        -0.5f, -0.5f,   0,  0,  1,  0,
        0.5f,  -0.5f,   0,  0,  0,  1,
        0.5f,  -0.5f,   0,  0,  0,  1,
        0.5f,   0.5f,   0,  1,  0,  0,
        -0.5f,  0.5f,   0,  0,  1,  0,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)drawTriangleStrip
{
    static GLfloat triangleData[] = {
        0,      0.5f,   0,  1,  0,  0,
        -0.5f,  0.0f,   0,  0,  1,  0,
        0.5f,   0.0f,   0,  0,  0,  1,
        0,      -0.5f,  0,  1,  0,  0,
        0.5f,   -0.5f,  0,  0,  1,  0,
        0.8f,   -0.8f,  0,  1,  0,  0,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
}

- (void)drawTriangleFan // 原点为中心顶点, 遍历两个点为顶点,绘制三角形
{
    static GLfloat triangleData[] = {
        -0.5,   0.0f,   0,  1,  0,  0,
        0,      0.5f,   0,  0,  1,  0,
        0.5f,   0.0f,   0,  0,  0,  1,
        0,      -0.5f,  0,  1,  0,  0,
        -0.3,   -0.8f,  0,  0,  1,  0,
    };
    [self bindAttributes:triangleData];
    glDrawArrays(GL_TRIANGLE_FAN, 0, 5);
}

- (void)drawLines
{
    static GLfloat lineData[] = {
        0.0f,  0.0f,  0,  0,  1,  0,
        0.5,   0.5f,  0,  1,  0,  0,
        0.0f,  0.0f,  0,  0,  0,  1,
        0.5,   -0.5f, 0,  1,  0,  0,
    };
    [self bindAttributes:lineData];
    glLineWidth(5);
    glDrawArrays(GL_LINES, 0, 4);
}

- (void)drawLineStrip
{
    static GLfloat lineData[] = {
        0.0f,  0.0f,  0,  0,  1,  0,
        0.5,   0.5f,  0,  1,  0,  0,
        0.5,   -0.5f, 0,  1,  0,  0,
    };
    [self bindAttributes:lineData];
    glLineWidth(5);
    glDrawArrays(GL_LINE_STRIP, 0, 3);
}

- (void)drawPoints
{
    static GLfloat pointData[] = {
        0.0f,  0.0f,  0,  0,  1,  0,
        0.5,   0.5f,  0,  1,  0,  0,
        0.5,   -0.5f, 0,  1,  0,  0,
    };
    [self bindAttributes:pointData];
    glDrawArrays(GL_POINTS, 0, 3);
}


@end
