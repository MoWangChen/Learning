//
//  DataSource.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/7.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

/**
 * <NSObject>协议的存在一方面是给NSProxy这样的其他根类使用，同时也给了鸭子协议类型一个根类型，正如给了大部分类一个NSObject根类一样。说个小插曲，由于objc中Class也是id类型，形如id<UITableViewDataSource>的鸭子类型是可以用Class对象来扮演的，只需要把实例方法替换成类方法
 * 这种非主流写法合法且运行正常，归功于objc中加号和减号方法在@selector中并未体现，在protocol中也是形同虚设，这种代码我相信没人真的写，但确实能体现鸭子类型的灵活性。
 */
+ (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

+ (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

+ (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"test test test";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"test test test";
    return cell;
}

@end
