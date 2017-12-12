//
//  FogViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/11.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "FogViewController.h"
#import "SkyBox.h"
#import "Terrain.h"
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

typedef enum : NSUInteger {
    FogTypeLindear = 0,
    FogTypeExp = 1,
    FogTypeExpSquare = 2,
} FogType;

typedef struct {
    FogType fogType;
    // for linear
    GLfloat fogStart;
    GLfloat fogEnd;
    // for exp & exp square
    GLfloat fogIndensity;
    GLKVector3 fogColor;
} Fog;

@interface FogViewController ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) Directionlight light;    // 平行光照方向
@property (nonatomic, assign) Material material;
@property (nonatomic, assign) GLKVector3 eyePosition;

@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;
@property (nonatomic, assign) BOOL useNormalMap;

@property (nonatomic, strong) GLKTextureInfo *cubeTexture;

@property (nonatomic, strong) SkyBox *skyBox;
@property (nonatomic, assign) Fog fog;

@end

@implementation FogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 10000.0);
    
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 1, 6.5, 0, 0, 0, 0, 1, 0);
    
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
    material.smoothness = 700;
    self.material = material;
    
    Fog fog;
    fog.fogColor = GLKVector3Make(1, 1, 1);
    fog.fogStart = 0;
    fog.fogEnd = 200;
    fog.fogIndensity = 0.02;
    fog.fogType = FogTypeLindear;
    self.fog = fog;
    
    self.useNormalMap = NO;
    
    self.objects = [NSMutableArray new];
    [self createTerrain];
    [self createCubeTexture];
    [self createSkyBox];
}

- (void)createTerrain
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@".glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"frag_terrain" ofType:@".glsl"];
    GLContext *terrainContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
    GLKTextureInfo *dirt = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"dirt_01.jpg"].CGImage options:nil error:nil];
    GLKTextureInfo *grass = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"grass_01.jpg"].CGImage options:nil error:nil];
    
    //    glEnable(GL_TEXTURE_2D);
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

- (void)createCubeTexture
{
    NSMutableArray *files = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        NSString *fileName = [NSString stringWithFormat:@"cube-%d",i + 1];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"tga"];
        [files addObject:filePath];
    }
    //    NSLog(@"GL Error = %u", glGetError());
    NSError *error;
    self.cubeTexture = [GLKTextureLoader cubeMapWithContentsOfFiles:files options:nil error:&error];
    NSLog(@"error: %@",error);
}

- (void)createSkyBox
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"frag_skybox" ofType:@"glsl"];
    GLContext *skyGLContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
    self.skyBox = [[SkyBox alloc] initWithGLContext:skyGLContext];
    self.skyBox.modelMatrix = GLKMatrix4MakeScale(1000, 1000, 1000);
}

#pragma mark - Update Delegate
- (void)update
{
    [super update];
    self.eyePosition = GLKVector3Make(5 * sin(self.elapsedTime / 1.5), 30, 5 * cos(self.elapsedTime / 1.5));
    GLKVector3 lookAtPosition = GLKVector3Make(0, 32, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    [self drawObjects];
}

- (void)drawObjects
{
    [self.skyBox.context active];
    [self bindFog:self.skyBox.context];
    [self.skyBox.context setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
    [self.skyBox.context setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
    [self.skyBox.context bindCubeTexture:self.cubeTexture to:GL_TEXTURE4 uniformName:@"envMap"];
    [self.skyBox draw:self.skyBox.context];
    
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.context active];
        [self bindFog:obj.context];
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
        
        [obj.context bindCubeTexture:self.cubeTexture to:GL_TEXTURE4 uniformName:@"envMap"];
        
        [obj draw:obj.context];
    }];
}

- (void)bindFog:(GLContext *)context
{
    [context setUniform1i:@"fog.fogType" value:self.fog.fogType];
    [context setUniform1f:@"fog.fogStart" value:self.fog.fogStart];
    [context setUniform1f:@"fog.fogEnd" value:self.fog.fogEnd];
    [context setUniform1f:@"fog.fogIndensity" value:self.fog.fogIndensity];
    [context setUniform3fv:@"fog.fogColor" value:self.fog.fogColor];
}

@end
