//
//  Person.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/15.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Person.h"

@implementation Person
{
    NSMutableSet *_friends;
}

// 抛出异常
- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"test" userInfo:nil];
}

// 全能初始化方法,不应使用 init 方法初始化
- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _friends = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addFriend:(Person *)person
{
    [_friends addObject:person];
}

- (void)removeFriend:(Person *)person
{
    [_friends removeObject:person];
}

// -> 语法, friend并非属性,只是内部使用的实例变量
- (id)copyWithZone:(NSZone *)zone
{
    Person *copy = [[[self class] allocWithZone:zone] initWithFirstName:_firstName lastName:_lastName];
    copy->_friends = [_friends mutableCopy];
    return copy;
}

@end
