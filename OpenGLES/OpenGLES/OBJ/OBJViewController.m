//
//  OBJViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/16.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "OBJViewController.h"
#import "WavefrontOBJ.h"

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

@interface OBJViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) Directionlight light;    // 平行光照方向
@property (nonatomic, assign) Material material;
@property (nonatomic, assign) GLKVector3 eyePosition;

@property (nonatomic, strong) WavefrontOBJ *carModel;
@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;

@end

@implementation OBJViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 1000.0);
    
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 1, 6.5, 0, 0, 0, 0, 1, 0);
    
    // 设置平行光方向
    Directionlight defaultLight;
    defaultLight.color = GLKVector3Make(1, 1, 1); // 白色的灯
    defaultLight.direction = GLKVector3Make(1, -1, 0);
    defaultLight.indensity = 1.0;
    defaultLight.ambientIndensity = 0.1;
    self.light = defaultLight;

    Material material;
    material.ambientColor = GLKVector3Make(1, 1, 1);
    material.diffuseColor = GLKVector3Make(0.1, 0.1, 0.1);
    material.specularColor = GLKVector3Make(1, 1, 1);
    material.smoothness = 300;
    self.material = material;
    
    self.objects = [NSMutableArray new];
    [self createMonkeyFromObj];
}

- (void)createMonkeyFromObj
{
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"car" ofType:@"obj"];
    WavefrontOBJ *obj = [[WavefrontOBJ alloc] initWithGLContext:self.glContext objFile:objFilePath];
    obj.modelMatrix = GLKMatrix4MakeRotation(-M_PI / 2.0, 0, 1, 0);
    self.carModel = obj;
    [self.objects addObject:obj];
}

#pragma mark - Update Delegate
- (void)update
{
    [super update];
    self.eyePosition = GLKVector3Make(60, 100, 200);
    GLKVector3 lookAtPosition = GLKVector3Make(0, 0, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
    self.carModel.modelMatrix = GLKMatrix4MakeRotation(-M_PI * 2.0 * self.elapsedTime / 4.0, 0, 1, 0);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
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
        [obj draw:obj.context];
    }];
}

@end
