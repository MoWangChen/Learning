//
//  TimingFunctionTool.h
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimingFunctionTool : NSObject

+ (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time;

@end
