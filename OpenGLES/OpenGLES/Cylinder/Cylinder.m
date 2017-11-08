//
//  Cylinder.m
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Cylinder.h"
#import "GLGeometry.h"

@interface Cylinder ()

@property (nonatomic, strong) GLGeometry *topCircle;
@property (nonatomic, strong) GLGeometry *middleCircle;
@property (nonatomic, strong) GLGeometry *bottomCircle;

@property (nonatomic, strong) GLKTextureInfo *diffuseTexture;

@end

@implementation Cylinder

- (instancetype)initWithGLContext:(GLContext *)context sides:(int)sides radius:(GLfloat)radius height:(GLfloat)height texture:(GLKTextureInfo *)texture
{
    self = [super initWithGLContext:context];
    if (self) {
        self.modelMatrix = GLKMatrix4Identity;
        self.sideCount = sides;
        self.radius = radius;
        self.height = height;
        self.diffuseTexture = texture;
    }
    return self;
}

- (GLGeometry *)topCircle
{
    if (!_topCircle) {
        _topCircle = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleFan];
    
        float y = self.height / 2.0;
        // 中心点
        GLVertex centerVertex = GLVertexMake(0, y, 0, 0, 1, 0, 0.5, 0.5);
        [_topCircle appendVertex:centerVertex];
        for (int i = self.sideCount; i >= 0; i--) {
            GLfloat angle = (float)i / (float)self.sideCount * M_PI * 2;
            GLVertex vertex = GLVertexMake(cos(angle) * self.radius,
                                           y,
                                           sin(angle) * self.radius,
                                           0,
                                           1,
                                           0,
                                           (cos(angle) + 1) / 2.0,
                                           (sin(angle) + 1) / 2.0);
            [_topCircle appendVertex:vertex];
        }
    }
    return _topCircle;
}

- (GLGeometry *)middleCircle
{
    if (!_middleCircle) {
        _middleCircle = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleStrip];
        
        float yUP = self.height / 2.0;
        float yDown = -self.height / 2.0;
        for (int i = 0; i <= self.sideCount; i++) { //int i = self.sideCount; i >= 0; i--
            GLfloat angle = (float)i / (float)self.sideCount * M_PI * 2;
            GLKVector3 vector = GLKVector3Normalize(GLKVector3Make(cos(angle) * self.radius,
                                                            0,
                                                            sin(angle) * self.radius));
            GLVertex vertexUp = GLVertexMake(cos(angle) * self.radius,
                                           yUP,
                                           sin(angle) * self.radius,
                                           vector.x,
                                           vector.y,
                                           vector.z,
                                           (float)i / (float)self.sideCount,
                                           0);
            GLVertex vertexDown = GLVertexMake(cos(angle) * self.radius,
                                           yDown,
                                           sin(angle) * self.radius,
                                           vector.x,
                                           vector.y,
                                           vector.z,
                                           (float)i / (float)self.sideCount,
                                           1);
            // 添加顺序 影响三角形顺时针/逆时针绘制, 单面绘制时,可能只显示背面
            
            [_middleCircle appendVertex:vertexDown];
            [_middleCircle appendVertex:vertexUp];
        }
    }
    return _middleCircle;
}

- (GLGeometry *)bottomCircle
{
    if (!_bottomCircle) {
        _bottomCircle = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleFan];
        
        float y = -self.height / 2.0;
        // 中心点
        GLVertex centerVertex = GLVertexMake(0, y, 0, 0, -1, 0, 0.5, 0.5);
        [_bottomCircle appendVertex:centerVertex];
        for (int i = 0; i <= self.sideCount; i++) {
            GLfloat angle = (float)i / (float)self.sideCount * M_PI * 2;
            GLVertex vertex = GLVertexMake(cos(angle) * self.radius,
                                           y,
                                           sin(angle) * self.radius,
                                           0,
                                           -1,
                                           0,
                                           (cos(angle) + 1) / 2.0,
                                           (sin(angle) + 1) / 2.0);
            [_bottomCircle appendVertex:vertex];
        }
    }
    return _bottomCircle;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate{
    
}

- (void)draw:(GLContext *)glContext
{
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    
    [glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        [glContext setUniformMatrix4fv:@"normalMatrix" value:normalMatrix];
    }
    
    [glContext bindTexture:self.diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [glContext drawGeometry:self.topCircle];
    [glContext drawGeometry:self.middleCircle];
    [glContext drawGeometry:self.bottomCircle];
}

@end
