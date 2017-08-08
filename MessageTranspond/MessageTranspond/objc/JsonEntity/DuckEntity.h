//
//  DuckEntity.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/7.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

extern id DuckEntityCreateWithJSON(NSString *json);

@protocol UserDuckEntry <NSObject>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *teacher;

@end
