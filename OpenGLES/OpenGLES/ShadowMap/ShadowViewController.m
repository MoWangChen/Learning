//
//  ShadowViewController.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/1.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ShadowViewController.h"
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

@interface ShadowViewController ()
{
    GLuint shadowMapFramebuffer;
    GLuint shadowDepthMap;
}

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;  // 投影矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;      // 观察矩阵
@property (nonatomic, assign) Directionlight light;    // 平行光照方向
@property (nonatomic, assign) Material material;
@property (nonatomic, assign) GLKVector3 eyePosition;

@property (nonatomic, strong) NSMutableArray<GLObject *> *objects;
@property (nonatomic, assign) BOOL useNormalMap;

// 投影器矩阵
@property (nonatomic, assign) GLKMatrix4 lightProjectionMatrix;
@property (nonatomic, assign) GLKMatrix4 lightCameraMatrix;
@property (nonatomic, assign) CGSize shadowMapSize;
@property (nonatomic, strong) GLContext *shadowMapContext;

@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用透视投影矩阵
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 1000.0);
    
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
    material.diffuseColor = GLKVector3Make(0.1, 0.1, 0.1);
    material.specularColor = GLKVector3Make(1, 1, 1);
    material.smoothness = 70;
    self.material = material;
    
    self.useNormalMap = YES;
    
    self.objects = [NSMutableArray new];
    [self createCube:GLKVector3Make(-1, 0.6, -1.3) size:GLKVector3Make(0.6, 0.6, 0.6)];
    [self createCube:GLKVector3Make(2, 1, 1) size:GLKVector3Make(0.4, 1, 0.4)];
    [self createCube:GLKVector3Make(0.2, 1.3, 0.8) size:GLKVector3Make(0.3, 1.3, 0.4)];
    [self createFloor];
    
    self.lightProjectionMatrix = GLKMatrix4MakeOrtho(-10, 10, -10, 10, -100, 100);
    self.lightCameraMatrix = GLKMatrix4MakeLookAt(-defaultLight.direction.x * 10, -defaultLight.direction.y * 10, -defaultLight.direction.z * 10, 0, 0, 0, 0, 1, 0);
    
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"frag_shadowmap" ofType:@"glsl"];
    self.shadowMapContext = [GLContext contextWithVertexShaderPath:vertexShaderPath fragmentShaderPath:fragmentShaderPath];
    [self createShadowMap];
}

- (void)createCube:(GLKVector3)location size:(GLKVector3)size
{
    UIImage *normalImage = [UIImage imageNamed:@"normal.png"];
    GLKTextureInfo *normalMap = [GLKTextureLoader textureWithCGImage:normalImage.CGImage options:nil error:nil];
    UIImage *diffuseImage = [UIImage imageNamed:@"texture.jpg"];
    GLKTextureInfo *diffuseMap = [GLKTextureLoader textureWithCGImage:diffuseImage.CGImage options:nil error:nil];
    
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    WavefrontOBJ *cube = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFilePath diffuseMap:diffuseMap normalMap:normalMap];
    cube.modelMatrix = GLKMatrix4MakeTranslation(location.x, location.y, location.z);
    cube.modelMatrix = GLKMatrix4Multiply(cube.modelMatrix, GLKMatrix4MakeScale(size.x, size.y, size.z));
    [self.objects addObject:cube];
}

- (void)createFloor
{
    UIImage *normalImage = [UIImage imageNamed:@"stoneFloor_NRM.png"];
    GLKTextureInfo *normalMap = [GLKTextureLoader textureWithCGImage:normalImage.CGImage options:nil error:nil];
    UIImage *diffuseImage = [UIImage imageNamed:@"stoneFloor.jpg"];
    GLKTextureInfo *diffuseMap = [GLKTextureLoader textureWithCGImage:diffuseImage.CGImage options:nil error:nil];
    
    NSString *objFilePath = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    WavefrontOBJ *cube = [WavefrontOBJ objWithGLContext:self.glContext objFile:objFilePath diffuseMap:diffuseMap normalMap:normalMap];
    cube.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, -0.1, 0), GLKMatrix4MakeScale(3, 0.2, 3));
    [self.objects addObject:cube];
}

- (void)createShadowMap
{
    self.shadowMapSize = CGSizeMake(1024, 1024);
    glGenFramebuffers(1, &shadowMapFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, shadowMapFramebuffer);
    
    // 生成深度缓冲区的纹理对象并绑定到framebuffer上
    glGenTextures(1, &shadowDepthMap);
    glBindTexture(GL_TEXTURE_2D, shadowDepthMap);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, self.shadowMapSize.width, self.shadowMapSize.height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_INT, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, shadowDepthMap, 0);
    
    // 检查framebuffer的创建状态
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        // framebuffer生成失败
        NSLog(@"shadowMapFramebuffer生成失败");
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

#pragma mark - Update Delegate
- (void)update
{
    [super update];
    self.eyePosition = GLKVector3Make(1, 4, 4);
    GLKVector3 lookAtPosition = GLKVector3Make(0, 0, 0);
    self.cameraMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
    
    Directionlight light = self.light;
    light.direction = GLKVector3Make(-sin(self.elapsedTime), -1, -cos(self.elapsedTime));
    self.light = light;
    self.lightProjectionMatrix = GLKMatrix4MakeOrtho(-10, 10, -10, 10, -100, 100);
    self.lightCameraMatrix = GLKMatrix4MakeLookAt(-light.direction.x * 10, -light.direction.y * 10, -light.direction.z * 10, 0, 0, 0, 0, 1, 0);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glBindFramebuffer(GL_FRAMEBUFFER, shadowMapFramebuffer);
    glViewport(0, 0, self.shadowMapSize.width, self.shadowMapSize.height);
    glClearColor(0.8, 0.8, 0.8, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self drawObjectsForShadowMap];
    
    // `[view bindDrawable]` 将GLKView生成的framebuffer版订到GL_FrameBuffer, 并设置好viewport,这样后面的内容将呈现在GLKView上
    [view bindDrawable];
    glClearColor(0.7, 0.7, 0.7, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self drawObjects];
}

- (void)drawObjectsForShadowMap
{
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.shadowMapContext active];
        [obj.context setUniformMatrix4fv:@"projectionMatrix" value:self.lightProjectionMatrix];
        [obj.context setUniformMatrix4fv:@"cameraMatrix" value:self.lightCameraMatrix];
        [obj draw:self.shadowMapContext];
    }];
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
        
        [obj.context setUniformMatrix4fv:@"lightMatrix" value:GLKMatrix4Multiply(self.lightProjectionMatrix, self.lightCameraMatrix)];
        [obj.context bindTextureName:shadowDepthMap to:GL_TEXTURE2 uniformName:@"shadowMap"];
        
        [obj draw:obj.context];
    }];
}

#pragma mark - UI
- (void)loadSwitch
{
    UISwitch *button = [[UISwitch alloc] initWithFrame:CGRectMake(0, 30, 80, 30)];
    [button addTarget:self action:@selector(switchUseNormalMap:) forControlEvents: UIControlEventValueChanged];
    [button setOn:YES];
    [self.view addSubview:button];
}

- (void)switchUseNormalMap:(UISwitch *)sender
{
    self.useNormalMap = sender.isOn;
}

- (void)loadStackView
{
    UIStackView *labelStackView = [[UIStackView alloc] initWithFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, 100, 200)];
    labelStackView.distribution = UIStackViewDistributionEqualCentering;
    labelStackView.axis = UILayoutConstraintAxisVertical;
    labelStackView.alignment = UIStackViewAlignmentFill;
    NSArray *textArray = @[@"光滑度", @"indensity", @"lightColor", @"ambientColor", @"diffuseColor", @"specularColor"];
    for (NSString *text in textArray) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.font = [UIFont systemFontOfSize:14];
        [labelStackView addArrangedSubview:label];
    }
    [self.view addSubview:labelStackView];
    
    UIStackView *sliderStackView = [[UIStackView alloc] initWithFrame: CGRectMake(100, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width - 130, 200)];
    sliderStackView.distribution = UIStackViewDistributionEqualCentering;
    sliderStackView.axis = UILayoutConstraintAxisVertical;
    sliderStackView.alignment = UIStackViewAlignmentFill;
    NSArray *keyValues = @[@{@"value":@70,
                             @"maxValue":@100}, // 光滑度
                           @{@"value":@1,
                             @"maxValue":@2}, // indensity
                           @{@"value":@6.28,
                             @"maxValue":@6.28}, // lightColor
                           @{@"value":@6.28,
                             @"maxValue":@6.28}, // ambientColor
                           @{@"value":@0,
                             @"maxValue":@6.28}, // diffuseColor
                           @{@"value":@6.28,
                             @"maxValue":@6.28},]; // specularColor
    for (int i = 0; i < 6; i++) {
        NSDictionary *dict = keyValues[i];
        UISlider *slider = [[UISlider alloc] initWithFrame: CGRectMake(10, i * 30, [UIScreen mainScreen].bounds.size.width - 150, 30)];
        slider.minimumValue = 0;
        slider.maximumValue = [dict[@"maxValue"] floatValue];
        slider.value = [dict[@"value"] floatValue];
        slider.tag = i + 1;
        [slider addTarget:self action:@selector(colorAdjust:) forControlEvents: UIControlEventValueChanged];
        [sliderStackView addArrangedSubview:slider];
    }
    [self.view addSubview:sliderStackView];
}

- (void)colorAdjust:(UISlider *)sender
{
    NSLog(@"%f",sender.value);
    if (sender.tag == 1) {
        Material material = self.material;
        material.smoothness = sender.value;
        self.material = material;
    }else if (sender.tag == 2){
        Directionlight light = self.light;
        light.indensity = sender.value;
        self.light = light;
    }else if (sender.tag == 3){
        GLKVector3 yuv = GLKVector3Make(1.0, (cos(sender.value) + 1.0) / 2.0, (sin(sender.value) + 1.0) / 2.0);
        Directionlight light = self.light;
        light.color = [self colorFromYUV:yuv];
        if (sender.value == sender.maximumValue) {
            light.color = GLKVector3Make(1, 1, 1);
        }
        self.light = light;
        sender.backgroundColor = [UIColor colorWithRed:_light.color.r green:_light.color.g blue:_light.color.b alpha:1.0];
    }else if (sender.tag == 4){
        GLKVector3 yuv = GLKVector3Make(1.0, (cos(sender.value) + 1.0) / 2.0, (sin(sender.value) + 1.0) / 2.0);
        Material material = self.material;
        material.ambientColor = [self colorFromYUV:yuv];
        if (sender.value == sender.maximumValue) {
            material.ambientColor = GLKVector3Make(1, 1, 1);
        }
        self.material = material;
        sender.backgroundColor = [UIColor colorWithRed:_material.ambientColor.r green:_material.ambientColor.g blue:_material.ambientColor.b alpha:1.0];
    }else if (sender.tag == 5){
        GLKVector3 yuv = GLKVector3Make(1.0, (cos(sender.value) + 1.0) / 2.0, (sin(sender.value) + 1.0) / 2.0);
        Material material = self.material;
        material.diffuseColor = [self colorFromYUV:yuv];
        if (sender.value == sender.maximumValue) {
            material.diffuseColor = GLKVector3Make(1, 1, 1);
        }
        self.material = material;
        sender.backgroundColor = [UIColor colorWithRed:_material.diffuseColor.r green:_material.diffuseColor.g blue:_material.diffuseColor.b alpha:1.0];
    }else if (sender.tag == 6){
        GLKVector3 yuv = GLKVector3Make(1.0, (cos(sender.value) + 1.0) / 2.0, (sin(sender.value) + 1.0) / 2.0);
        Material material = self.material;
        material.specularColor = [self colorFromYUV:yuv];
        if (sender.value == sender.maximumValue) {
            material.specularColor = GLKVector3Make(1, 1, 1);
        }
        self.material = material;
        sender.backgroundColor = [UIColor colorWithRed:_material.specularColor.r green:_material.specularColor.g blue:_material.specularColor.b alpha:1.0];
    }
    
}

- (GLKVector3)colorFromYUV:(GLKVector3)yuv
{
    float Cb, Cr, Y;
    float R, G, B;
    Y = yuv.x * 255.0;
    Cb = yuv.y * 255.0 - 128;
    Cr = yuv.z * 255.0 - 128;
    
    R = 1.402 * Cr + Y;
    G = -0.344 * Cb - 0.714 * Cr + Y;
    B = 1.772 * Cb + Y;
    
    return GLKVector3Make(MIN(1.0, R / 255.0), MIN(1.0, G / 255.0), MIN(1.0, B / 255.0));
}

@end
