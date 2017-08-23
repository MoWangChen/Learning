//
//  ViewController.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "DealerProxy.h"
#import "DataSource.h"
#import "DuckEntity.h"
#import "DIProxy.h"
#import "Girl.h"

#import "ZombieClass.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DataSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self loadTableView];
    
//    [self testDuckEntity];
    
//    [self testDependencyInjection];
    
    [self testZombieClass];
}

- (void)testZombieClass
{
    testRelease();
}

- (void)testDependencyInjection
{
    LinZhiLing *implementA = [[LinZhiLing alloc] init];
    ZhangYang *implementB = [[ZhangYang alloc] init];
    
    id<DIProxy,GirlFriend> girl = DIProxyCreate();
    [girl injectDependencyObject:implementA forProtocol:@protocol(GirlFriend)];
    [girl kiss];
    [girl injectDependencyObject:implementB forProtocol:@protocol(GirlFriend)];
    [girl kiss];
}

- (void)testDuckEntity
{
    NSDictionary *dic = @{@"name":@"xiaobai",
                          @"sex":@"man",
                          @"age":@"13",
                          @"teacher":@"teacher Li"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    id<UserDuckEntry> entity = DuckEntityCreateWithJSON(jsonString);
    NSLog(@"name:%@  ",entity.name);
    
    entity.teacher = @"teacher Luo";
    NSLog(@"teacher: %@",entity.teacher);
}

- (void)testProxy
{
    Person *person = [[Person alloc] init];
    [person run];
    
    DealerProxy *proxy = [DealerProxy dealerProxy];
    [proxy purchaseBookWithTitle:@"horizon"];
    [proxy purchaseClothesWithSize:@"small"];
}

- (void)loadTableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
//        tableView.dataSource = (Class <UITableViewDataSource>)[DataSource class];
        _dataSource = [[DataSource alloc] init];
        tableView.dataSource = _dataSource;
        _tableView = tableView;
        [self.view addSubview:_tableView];
    }
}

@end
