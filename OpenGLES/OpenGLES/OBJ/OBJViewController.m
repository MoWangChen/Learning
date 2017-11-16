//
//  OBJViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/16.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "OBJViewController.h"
#import "WavefrontOBJ.h"

@interface OBJViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

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
    self.lightDirection = GLKVector3Make(1, -1, 0);
    
    self.objects = [NSMutableArray new];
    [self createMonkeyFromObj];
}

- (void)createMonkeyFromObj
{
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"car" ofType:@"obj"];
    WavefrontOBJ *obj = [[WavefrontOBJ alloc] initWithGLContext:self.glContext objFile:objFilePath];
    obj.modelMatrix = GLKMatrix4MakeRotation(-M_PI / 2.0, 0, 1, 0);
    [self.objects addObject:obj];
}

#pragma mark - Update Delegate
- (void)update
{
    [super update];
    GLKVector3 eyePosition = GLKVector3Make(200 * sin(self.elapsedTime), 100, 200 * cos(self.elapsedTime));
    GLKVector3 lookAtPosition = GLKVector3Make(0, 0, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(eyePosition.x, eyePosition.y, eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.context active];
        [obj.context setUniform1f:@"elapsedTime" value:(GLfloat)self.elapsedTime];
        [obj.context setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
        [obj.context setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
        
        [obj.context setUniform3fv:@"lightDirection" value:self.lightDirection];
        [obj draw:obj.context];
    }];
}

@end
