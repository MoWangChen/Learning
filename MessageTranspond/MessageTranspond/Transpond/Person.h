//
//  Person.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonMethodDelegate <NSObject>
@optional
- (void)run;

@end

@interface Person : NSObject <PersonMethodDelegate>

@end

