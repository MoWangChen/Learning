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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.transformMatrix = GLKMatrix4Identity;
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    GLuint transformUniformLocation = glGetUniformLocation(self.shaderProgram, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, self.transformMatrix.m);
    
    [self drawTriangle];
}

- (void)update
{
    [super update];
    
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

#pragma mark - Draw Graph

- (void)drawTriangle
{
    static GLfloat triangleData[36] = {
        0,      0.5f,   0,  1,  0,  0, // x, y, z, r, g, b,每一行存储一个点的信息,位置和颜色
        -0.5f,  0.0f,   0,  0,  1,  0,
        0.5f,   0.0f,   0,  0,  0,  1,
        0.0f,  -0.5f,   0,  1,  0,  0,
        -0.5f,  0.0f,   0,  0,  1,  0,
        0.5f,   0.0f,   0,  0,  0,  1,
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
