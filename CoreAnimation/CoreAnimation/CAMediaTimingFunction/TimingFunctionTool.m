//
//  TimingFunctionTool.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "TimingFunctionTool.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@implementation TimingFunctionTool

// 插值函数(线型直线)
float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

// 插值函数(EaseInOut)
float quadraticEaseInOut(float t)
{
    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}

// 插值函数
float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

+ (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        // get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(from.x + (to.x - from.x) * bounceEaseOut(time), from.y + (to.y - from.y) * bounceEaseOut(time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    // provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}


@end
