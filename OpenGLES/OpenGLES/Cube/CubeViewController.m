//
//  CubeViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/9/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "CubeViewController.h"
#import "Cube.h"

@interface CubeViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;

@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lightDirection = GLKVector3Make(1, -1, 0);
    [self cameraMatrixInit];
}

#pragma mark - over ride
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

- (void)update
{
    [super update];
    
    GLKVector3 eyePosition = GLKVector3Make(2 * sin(self.elapsedTime/2), 2, 2 * cos(self.elapsedTime/2));
    
    self.cameraMatrix = GLKMatrix4MakeLookAt(eyePosition.x, eyePosition.y, eyePosition.z, 0, 0, 0, 0, 1, 0);
}


#pragma mark - transformMatrix
// 初始化各参数
- (void)cameraMatrixInit
{
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 1000.0);
    
    // 设置摄像机在 0, 0, 2坐标,看向0,0,0点. Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 1, 3, 0, 0, 0, 0, 1, 0);
    
    // 初始化模型矩阵为单位矩阵
    self.objects = [NSMutableArray array];
    [self creatCubes];
}


#pragma mark - Draw Graph
- (void)creatCubes
{
    for (int j = -4; j <= 4; j++) {
        for (int i = -4; i <= 4; i++) {
            Cube *cube = [[Cube alloc] initWithGLContext:self.glContext];
            cube.modelMatrix = GLKMatrix4MakeTranslation(j * 2, 0, i * 2);
            [self.objects addObject:cube];
        }
    }
}


@end
