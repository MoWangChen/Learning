//
//  TerrainViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/10.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "TerrainViewController.h"
#import "Terrain.h"

@interface TerrainViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) GLKVector3 lightDirection;    // 平行光照方向

@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;

@end

@implementation TerrainViewController

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
    
    GLKVector3 eyePosition = GLKVector3Make(500 * sin(self.elapsedTime/2), sin(self.elapsedTime/2) * 50 + 250, 500 * cos(self.elapsedTime/2));
    GLKVector3 lookAtPosition = GLKVector3Make(0, 0, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(eyePosition.x, eyePosition.y, eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
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
    [self createTerrain];
}

- (void)createTerrain
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@".glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"frag_terrain" ofType:@".glsl"];
    GLContext *terrainContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
    GLKTextureInfo *dirt = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"dirt_01.jpg"].CGImage options:nil error:nil];
    GLKTextureInfo *grass = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"grass_01.jpg"].CGImage options:nil error:nil];
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, dirt.name);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glBindTexture(GL_TEXTURE_2D, grass.name);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    UIImage *heightMap = [UIImage imageNamed:@"terrain_01.jpg"];
    Terrain *terrain = [[Terrain alloc] initWithGLContext:terrainContext heightMap:heightMap terrainSize:CGSizeMake(500, 500) terrainHeight:100 grass:grass dirt:dirt];
    terrain.modelMatrix = GLKMatrix4MakeTranslation(-250, 0, -250);
    [self.objects addObject:terrain];
}

@end
