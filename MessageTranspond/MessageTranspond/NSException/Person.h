//
//  Person.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/15.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName;

@end
