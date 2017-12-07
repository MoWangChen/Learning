//
//  CameraViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/6.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "CameraViewController.h"
#import "Camera.h"
#import "WavefrontOBJ.h"
#import "Mirror.h"

// 平行光
typedef struct {
    GLKVector3 direction;
    GLKVector3 color;
    float indensity;
    float ambientIndensity;
}Directionlight;

typedef struct {
    GLKVector3 diffuseColor;
    GLKVector3 ambientColor;
    GLKVector3 specularColor;
    float smoothness; // 0 ~ 1000 越高显得越光滑
}Material;

@interface CameraViewController ()
{
    GLuint mirrorFramebuffer;
    GLuint mirrorTexture;
    GLuint framebufferSize;
}

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKMatrix4 mirrorProjectionMatrix; // mirror投影矩阵
@property (nonatomic, assign) GLKMatrix4 viewProjectionMatrix; // 视图投影矩阵
@property (nonatomic, assign) Directionlight light;    // 平行光照方向
@property (nonatomic, assign) Material material;
@property (nonatomic, assign) GLKVector3 eyePosition;

@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;
@property (nonatomic, assign) BOOL useNormalMap;

@property (nonatomic, strong) GLKTextureInfo *cubeTexture;

@property (nonatomic, strong) Mirror *mirror;

@property (nonatomic, strong) Camera *mainCamera; // 当前主视图的camera
@property (nonatomic, strong) Camera *mirrorCamera; // 渲染镜子里的场景时使用的camera
@property (nonatomic, assign) BOOL clipplaneEnable;
@property (nonatomic, assign) GLKVector4 clipplane;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.viewProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 1000.0);
    self.mainCamera = [Camera new];
    self.mirrorCamera = [Camera new];
    [self.mainCamera setupCameraWithEye:GLKVector3Make(0, 1, 6.5) lookAt:GLKVector3Make(0, 0, 0) up:GLKVector3Make(0, 1, 0)];
    self.mirrorProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), 1, 0.1, 1000.0);
    self.projectionMatrix = self.viewProjectionMatrix;
    
    // 设置平行光方向
    Directionlight defaultLight;
    defaultLight.color = GLKVector3Make(1, 1, 1); // 白色的灯
    defaultLight.direction = GLKVector3Make(-1, -1, 0);
    defaultLight.indensity = 1.0;
    defaultLight.ambientIndensity = 0.1;
    self.light = defaultLight;
    
    Material material;
    material.ambientColor = GLKVector3Make(1, 1, 1);
    material.diffuseColor = GLKVector3Make(0.8, 0.1, 0.2);
    material.specularColor = GLKVector3Make(1, 1, 1);
    material.smoothness = 20;
    self.material = material;
    
    self.useNormalMap = YES;
    
    self.objects = [NSMutableArray array];
    [self createFloor];
    [self createWalls];
    [self createCubes];
    [self createMirror];
}

- (void)createMirror
{
    CGSize framebufferSize = CGSizeMake(1024, 1024);
    [self createTextureFramebuffer:framebufferSize];
    
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"frag_mirror" ofType:@"glsl"];
    GLContext *mirrorGLContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
    self.mirror = [[Mirror alloc] initWithGLContext:mirrorGLContext texture:mirrorTexture];
    self.mirror.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 3.5, 0), GLKMatrix4MakeScale(8, 7, 1));
}

- (void)createCubes
{
    UIImage *normalImage = [UIImage imageNamed:@"normal.png"];
    GLKTextureInfo *normalMap = [GLKTextureLoader textureWithCGImage:normalImage.CGImage options:nil error:nil];
    UIImage *diffuseImage = [UIImage imageNamed:@"texture.jpg"];
    GLKTextureInfo *diffuseMap = [GLKTextureLoader textureWithCGImage:diffuseImage.CGImage options:nil error:nil];
    
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    for (int i = 0; i < 360; i += 36) {
        float x = sin(i) * 5;
        float z = cos(i) * 5;
        float height = rand() / (float)RAND_MAX * 2 + 1;
        WavefrontOBJ *cube = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFilePath diffuseMap:diffuseMap normalMap:normalMap];
        cube.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(x, height, z), GLKMatrix4MakeScale(1, height, 1));
        [self.objects addObject:cube];
    }
}

- (void)createWalls
{
    UIImage *normalImage = [UIImage imageNamed:@"stoneFloor_NRM.png"];
    GLKTextureInfo *normalMap = [GLKTextureLoader textureWithCGImage:normalImage.CGImage options:nil error:nil];
    UIImage *diffuseImage = [UIImage imageNamed:@"stoneFloor.jpg"];
    GLKTextureInfo *diffuseMap = [GLKTextureLoader textureWithCGImage:diffuseImage.CGImage options:nil error:nil];
    
    NSString *objFile = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    WavefrontOBJ *wall1 = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFile diffuseMap:diffuseMap normalMap:normalMap];
    wall1.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -16), GLKMatrix4MakeScale(15, 15, 1));
    [self.objects addObject:wall1];
    
    WavefrontOBJ *wall2 = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFile diffuseMap:diffuseMap normalMap:normalMap];
    wall2.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, 16), GLKMatrix4MakeScale(15, 15, 1));
    [self.objects addObject:wall2];
    
    WavefrontOBJ *wall3 = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFile diffuseMap:diffuseMap normalMap:normalMap];
    wall3.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(16, 0, 0), GLKMatrix4MakeScale(1, 15, 15));
    [self.objects addObject:wall3];
    
    WavefrontOBJ *wall4 = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFile diffuseMap:diffuseMap normalMap:normalMap];
    wall4.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-16, 0, 0), GLKMatrix4MakeScale(1, 15, 15));
    [self.objects addObject:wall4];
}

- (void)createFloor
{
    UIImage *normalImage = [UIImage imageNamed:@"stoneFloor_NRM.png"];
    GLKTextureInfo *normalMap = [GLKTextureLoader textureWithCGImage:normalImage.CGImage options:nil error:nil];
    UIImage *diffuseImage = [UIImage imageNamed:@"stoneFloor.jpg"];
    GLKTextureInfo *diffuseMap = [GLKTextureLoader textureWithCGImage:diffuseImage.CGImage options:nil error:nil];
    
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    WavefrontOBJ *floor = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFilePath diffuseMap:diffuseMap normalMap:normalMap];
    floor.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, -1, 0), GLKMatrix4MakeScale(10, 1, 10));
    [self.objects addObject:floor];
}

- (void)createTextureFramebuffer:(CGSize)framebufferSize
{
    glGenFramebuffers(1, &mirrorFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mirrorFramebuffer);
    
    // 生成颜色缓冲区的纹理对象并绑定到framebuffer上
    glGenTextures(1, &mirrorTexture);
    glBindTexture(GL_TEXTURE_2D, mirrorTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, framebufferSize.width, framebufferSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mirrorTexture, 0);
    
    // 生成深度缓冲区的纹理对象并绑定到framebuffer上
//    glGenTextures(1, &framebufferDepthTexture);
//    glBindTexture(GL_TEXTURE_2D, framebufferDepthTexture);
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, framebufferSize.width, framebufferSize.height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_INT, NULL);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, framebufferDepthTexture, 0);
    
    // 不使用纹理作为深度缓冲区
    GLuint depthBufferID;
    glGenRenderbuffers(1, &depthBufferID);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBufferID);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferSize.width, framebufferSize.height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBufferID);
    
    // 检查framebuffer的创建状态
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        // framebuffer生成失败
        NSLog(@"framebuffer生成失败");
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

#pragma mark - Update Delegate
- (void)update
{
    [super update];
    self.eyePosition = GLKVector3Make(sin(self.elapsedTime / 3.0) * 10, 6, cos(self.elapsedTime / 3.0) * 10);
    GLKVector3 lookAtPosition = GLKVector3Make(0, 6, 0);
    [self.mainCamera setupCameraWithEye:self.eyePosition lookAt:lookAtPosition up:GLKVector3Make(0, 1, 0)];
    [self.mainCamera mirrorTo:self.mirrorCamera plane:GLKVector4Make(0, 0, 1, 0)];
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    self.projectionMatrix = self.mirrorProjectionMatrix;
    self.cameraMatrix = [self.mirrorCamera cameraMatrix];
    glBindFramebuffer(GL_FRAMEBUFFER, mirrorFramebuffer);
    glViewport(0, 0, 1024, 1024);
    glClearColor(0.7, 0.7, 0.9, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    self.clipplaneEnable = YES;
    self.clipplane = GLKVector4Make(0, 0, 1, 0);
    glEnable(GL_CLIP_DISTANCE0_APPLE);
    [self drawObjects];
    
    glDisable(GL_CLIP_DISTANCE0_APPLE);
    self.clipplaneEnable = NO;
    self.projectionMatrix = self.viewProjectionMatrix;
    self.cameraMatrix = [self.mainCamera cameraMatrix];
    [view bindDrawable];
    glClearColor(0.7, 0.7, 0.7, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self drawObjects];
    [self drawMirror];
}

- (void)drawObjects
{
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.context active];
        [obj.context setUniform1f:@"elapsedTime" value:(GLfloat)self.elapsedTime];
        [obj.context setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
        [obj.context setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
        
        [obj.context setUniform3fv:@"eyePosition" value:self.eyePosition];
        [obj.context setUniform3fv:@"light.direction" value:self.light.direction];
        [obj.context setUniform3fv:@"light.color" value:self.light.color];
        [obj.context setUniform1f:@"light.indensity" value:self.light.indensity];
        [obj.context setUniform1f:@"light.ambientIndensity" value:self.light.ambientIndensity];
        [obj.context setUniform3fv:@"material.diffuseColor" value:self.material.diffuseColor];
        [obj.context setUniform3fv:@"material.ambientColor" value:self.material.ambientColor];
        [obj.context setUniform3fv:@"material.specularColor" value:self.material.specularColor];
        [obj.context setUniform1f:@"material.smoothness" value:self.material.smoothness];
        
        [obj.context setUniform1f:@"useNormalMap" value:self.useNormalMap];
        
        [obj.context setUniform1i:@"clipplaneEnable" value:self.clipplaneEnable];
        [obj.context setUniform4fv:@"clipplane" value:self.clipplane];
        
        [obj draw:obj.context];
    }];
}

- (void)drawMirror
{
    glEnable(GL_CULL_FACE);
    [self.mirror.context active];
    [self.mirror.context setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
    [self.mirror.context setUniformMatrix4fv:@"mirrorPVMatrix" value:GLKMatrix4Multiply(self.mirrorProjectionMatrix, [self.mirrorCamera cameraMatrix])];
    [self.mirror.context setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
    [self.mirror draw:self.mirror.context];
    glDisable(GL_CULL_FACE);
}

@end
