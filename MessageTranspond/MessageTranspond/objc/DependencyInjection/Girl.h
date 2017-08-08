//
//  Girl.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/8.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GirlFriend <NSObject>

- (void)kiss;

@end

@interface LinZhiLing : NSObject<GirlFriend>

@end

@interface ZhangYang : NSObject<GirlFriend>

@end
