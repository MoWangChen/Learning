//
//  Particle.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/12/19.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Billboard.h"

typedef struct {
    int maxParticles;
    float birthRate;
    float startLife;
    float endLife;
    GLKVector3 startSpeed;
    GLKVector3 endSpeed;
    float startSize;
    float endSize;
    GLKVector3 startColor;
    GLKVector3 endColor;
    GLKVector3 emissionBoxExtends;    // emission 发射,发散
    GLKMatrix4 emissionBoxTransform;  // translate only
} ParticleSystemConfig;

@interface Particle : Billboard

@property (nonatomic, assign) float life;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 speed;
@property (nonatomic, assign) float size;
@property (nonatomic, assign) GLKVector3 color;

@end

@interface ParticleSystem : GLObject

@property (nonatomic, assign) ParticleSystemConfig config;
@property (nonatomic, strong) GLKTextureInfo *particleTexture;
@property (nonatomic, strong) NSMutableArray *activeParticles;
@property (nonatomic, strong) NSMutableArray *inactiveParticles;

- (instancetype)initWithGLContext:(GLContext *)context config:(ParticleSystemConfig)config particleTexture:(GLKTextureInfo *)particleTexture;
@end
