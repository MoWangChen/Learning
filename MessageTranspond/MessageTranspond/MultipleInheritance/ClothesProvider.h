//
//  ClothesProvider.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClothesProviderProtocol <NSObject>

- (void)purchaseClothesWithSize:(NSString *)size;

@end

@interface ClothesProvider : NSObject <ClothesProviderProtocol>

@end
