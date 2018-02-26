//
//  MyClass.h
//  runtime
//
//  Created by 谢鹏翔 on 2018/2/26.
//  Copyright © 2018年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;

- (void)method1;
- (void)method2;
+ (void)classMethod1;

@end
