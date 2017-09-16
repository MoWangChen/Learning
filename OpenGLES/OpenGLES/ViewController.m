//
//  ViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/11.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLuint shaderProgram;
@property (nonatomic, assign) GLfloat elapsedTime;

@end

@implementation ViewController

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
}

- (void)update {
    // 距离上一次调用update过了多长时间，比如一个游戏物体速度是3m/s,那么每一次调用update，
    // 他就会行走3m/s * deltaTime，这样做就可以让游戏物体的行走实际速度与update调用频次无关
    // NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    
    NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    self.elapsedTime += deltaTime;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 清空之前的绘制
    glClearColor(0.6, 0.2, 0.2, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 使用fragment.glsl 和 vertex.glsl中的shader
    glUseProgram(self.shaderProgram);
    
    // 设置shader中 uniform elapseTime 的值
    GLuint elapsedTimeUniformLocation = glGetUniformLocation(self.shaderProgram, "elapsedTime");
    glUniform1f(elapsedTimeUniformLocation, (GLfloat)self.elapsedTime);
    
    [self drawPoints];
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

- (void)bindAttributes:(GLfloat *)triangleData
{
    // 启用Shader中的两个属性
    // attribute vec4 positon
    // attribute vec4 color
    GLuint positionAttribLocation = glGetAttribLocation(self.shaderProgram, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint colorAttribLocation = glGetAttribLocation(self.shaderProgram, "color");
    glEnableVertexAttribArray(colorAttribLocation);
    
    // 为shader中的position和color赋值
    //
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
}

#pragma mark - Prepare Shaders
bool createProgram(const char *vertexShader, const char *fragmentShader, GLuint *pProgram) {
    GLuint program, vertShader, fragShader;
    // Create shader program.
    program = glCreateProgram();
    
    const GLchar *vssource = (GLchar *)vertexShader;
    const GLchar *fssource = (GLchar *)fragmentShader;
    
    if (!compileShader(&vertShader,GL_VERTEX_SHADER, vssource)) {
        printf("Failed to compile vertex shader");
        return false;
    }
    
    if (!compileShader(&fragShader,GL_FRAGMENT_SHADER, fssource)) {
        printf("Failed to compile fragment shader");
        return false;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Link program.
    if (!linkProgram(program)) {
        printf("Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        return false;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
    *pProgram = program;
    printf("Effect build success => %d \n", program);
    return true;
}


bool compileShader(GLuint *shader, GLenum type, const GLchar *source) {
    GLint status;
    
    if (!source) {
        printf("Failed to load vertex shader");
        return false;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    
#if Debug
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        printf("Shader compile log:\n%s", log);
        printf("Shader: \n %s\n", source);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return false;
    }
    
    return true;
}

bool linkProgram(GLuint prog) {
    GLint status;
    glLinkProgram(prog);
    
#if Debug
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        printf("Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return false;
    }
    
    return true;
}

bool validateProgram(GLuint prog) {
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        printf("Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return false;
    }
    
    return true;
}

- (void)setupShader {
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
    NSString *vertexShaderContent = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil];
    NSString *fragmentShaderContent = [NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil];
    GLuint program;
    createProgram(vertexShaderContent.UTF8String, fragmentShaderContent.UTF8String, &program);
    self.shaderProgram = program;
    
}

@end
