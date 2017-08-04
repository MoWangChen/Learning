//
//  BookProvider.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookProviderProtocol <NSObject>

- (void)purchaseBookWithTitle:(NSString *)bookTitle;

@end

@interface BookProvider : NSObject <BookProviderProtocol>

@end
