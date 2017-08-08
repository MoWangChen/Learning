//
//  DuckEntity.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/7.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "DuckEntity.h"

@interface DuckEntity : NSProxy

- (instancetype)initWithJSONString:(NSString *)json;

@end

@interface DuckEntity ()

@property (nonatomic, strong) NSMutableDictionary *innerDictionary;

@end

@implementation DuckEntity

id DuckEntityCreateWithJSON(NSString *json)
{
    return [[DuckEntity alloc] initWithJSONString:json];
}

- (instancetype)initWithJSONString:(NSString *)json
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        self.innerDictionary = [jsonObject mutableCopy];
    }
    return self;
}

#pragma mark - override 
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    SEL changedSelector = sel;
    if ([self propertyNameScanFromGetterSelector:sel]) {
        changedSelector = @selector(objectForKey:);
    }else if ([self propertyNameScanFromSetterSelector:sel]){
        changedSelector = @selector(setObject:forKey:);
    }

    return [[self.innerDictionary class] instanceMethodSignatureForSelector:changedSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    NSString *propertyName = nil;
    propertyName = [self propertyNameScanFromGetterSelector:selector];
    if (propertyName) {
        invocation.selector = @selector(objectForKey:);
        [invocation setArgument:&propertyName atIndex:2]; // self _cmd key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    propertyName = [self propertyNameScanFromSetterSelector:selector];
    if (propertyName) {
        invocation.selector = @selector(setObject:forKey:);
        [invocation setArgument:&propertyName atIndex:3]; // self _cmd obj key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    [super forwardInvocation:invocation];
}

#pragma mark - private method
- (NSString *)propertyNameScanFromGetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count];
    if (parameterCount == 1) {
        return selectorName;
    }
    return nil;
}

- (NSString *)propertyNameScanFromSetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count];
    if ([selectorName hasPrefix:@"set"] && parameterCount == 2) {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        return [[selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)] lowercaseString];
    }
    return nil;
}

@end
