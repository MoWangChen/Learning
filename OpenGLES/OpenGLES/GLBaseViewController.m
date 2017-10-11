//
//  GLBaseViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/16.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLBaseViewController.h"

@interface GLBaseViewController ()

@end

@implementation GLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContext];
    [self setupShader];
}

- (void)setupContext
{
    // 使用OpenGL ES2,  ES2 之后都采用shader来管理渲染管线
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"fail to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];
    
    // 设置OpenGL状态
    glEnable(GL_DEPTH_TEST);    // 开启深度测试
    glEnable(GL_BLEND);     // 开启颜色混合
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  //
}

- (void)update {
    // 距离上一次调用update过了多长时间，比如一个游戏物体速度是3m/s,那么每一次调用update，
    // 他就会行走3m/s * deltaTime，这样做就可以让游戏物体的行走实际速度与update调用频次无关
    // NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    
    NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    self.elapsedTime += deltaTime;
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 清空之前的绘制
    glClearColor(0.6, 0.2, 0.2, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 使用fragment.glsl 和 vertex.glsl中的shader
//    glUseProgram(self.glContext.program);
    [self.glContext active];
    
    glEnable(GL_DEPTH_TEST);
    
    // 设置shader中 uniform elapseTime 的值
    [self.glContext setUniform1f:@"elapsedTime" value:(GLfloat)self.elapsedTime];
}

#pragma mark - private method
- (void)bindAttribs:(GLfloat *)triangleData
{
    [self bindAttributes:triangleData];
}

- (void)bindAttributes:(GLfloat *)triangleData
{
    // 启用Shader中的两个属性
    // attribute vec4 positon
    // attribute vec4 color
    // attribute vec2 uv
    GLuint positionAttribLocation = glGetAttribLocation(self.glContext.program, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint colorAttribLocation = glGetAttribLocation(self.glContext.program, "normal");
    glEnableVertexAttribArray(colorAttribLocation);
    GLuint uvAttribLocation = glGetAttribLocation(self.glContext.program, "uv");
    glEnableVertexAttribArray(uvAttribLocation);
    
    // 为shader中的position和color赋值
    //
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
    glVertexAttribPointer(uvAttribLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData + 6 * sizeof(GLfloat));
}

- (void)setupShader {
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
    self.glContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];;
}

@end
