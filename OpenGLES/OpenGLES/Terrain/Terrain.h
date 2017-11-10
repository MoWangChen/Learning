//
//  Terrain.h
//  OpenGLES
//
//  Created by 谢鹏翔 on 2017/11/9.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "GLObject.h"

@interface Terrain : GLObject

- (instancetype)initWithGLContext:(GLContext *)context
                        heightMap:(UIImage *)heightMap
                      terrainSize:(CGSize)terrainSize
                    terrainHeight:(CGFloat)terrainHeight
                            grass:(GLKTextureInfo *)grass
                             dirt:(GLKTextureInfo *)dirt;

@end
