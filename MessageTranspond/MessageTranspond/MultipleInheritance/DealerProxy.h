//
//  DealerProxy.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookProvider.h"
#import "ClothesProvider.h"

@interface DealerProxy : NSProxy<BookProviderProtocol,ClothesProviderProtocol>

+ (instancetype)dealerProxy;

@end
