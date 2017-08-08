//
//  DIProxy.h
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/8.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DIProxy <NSObject>

- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol;

@end

extern id DIProxyCreate();
