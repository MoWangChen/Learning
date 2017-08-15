//
//  Rectangle.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/14.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle
// 抛出异常
- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"test" userInfo:nil];
}

@end
