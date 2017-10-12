//
//  LaserViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/10/11.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "LaserViewController.h"
#import "Laser.h"

@interface LaserViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix;       // 变换矩阵

@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

@property (nonatomic, strong) NSMutableArray<Laser *> *lasers;

@end

@implementation LaserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareLaserGLContext];
    [self prepareLasers];
    [self cameraMatrixInit];
    
    self.lightDirection = GLKVector3Make(1, -1, 0);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    [self.glContext setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
    [self.glContext setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
    
    [self.glContext setUniform3fv:@"lightDirection" value:self.lightDirection];
    
    [self.lasers enumerateObjectsUsingBlock:^(Laser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj draw:self.glContext];
    }];
}

- (void)update{
    [super update];
    
    [self.lasers enumerateObjectsUsingBlock:^(Laser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

#pragma mark - transformMatrix
// 初始化各参数
- (void)cameraMatrixInit
{
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100);
    
    // 设置摄像机在 0, 0, 2坐标,看向0,0,0点. Y轴正向为摄像机顶部指向的方向
//    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(1.5, -1, 0, 0, 0, -10, 0, 1, 0);
    
    // 初始化模型矩阵为单位矩阵
    self.modelMatrix = GLKMatrix4Identity;
}

#pragma mark - prepare load
- (void)prepareLaserGLContext
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"laserVertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"laserFragment" ofType:@"glsl"];
    self.glContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
}

- (void)prepareLasers
{
    self.lasers = [NSMutableArray arrayWithCapacity:4];
    Laser *laser = nil;
    laser = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser"]];
    laser.position = GLKVector3Make(0, 0, -40);
    laser.direction = GLKVector3Make(0.08, 0.08, 1);
    laser.length = 60;
    laser.radius = 1;
    [self.lasers addObject:laser];
    
    laser = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser"]];
    laser.position = GLKVector3Make(0, 0, -40);
    laser.direction = GLKVector3Make(-0.08, -0.08, 1);
    laser.length = 60;
    laser.radius = 1;
    [self.lasers addObject:laser];
    
    laser = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser"]];
    laser.position = GLKVector3Make(0, 0, -40);
    laser.direction = GLKVector3Make(-0.08, -0.08, 1);
    laser.length = 60;
    laser.radius = 1;
    [self.lasers addObject:laser];
    
    laser = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser"]];
    laser.position = GLKVector3Make(0, 0, -40);
    laser.direction = GLKVector3Make(-0.08, -0.08, 1);
    laser.length = 60;
    laser.radius = 1;
    [self.lasers addObject:laser];
}

@end
