//
//  InstrumentsViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/19.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "InstrumentsViewController.h"

@interface InstrumentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation InstrumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
        [array addObject:@{@"name":[self randomName], @"image":[self randomAvatar]}];
    }
    self.items = array;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:item[@"image"] ofType:nil];
//    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    cell.imageView.image = [UIImage imageNamed:item[@"image"]];
    cell.imageView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = item[@"name"];
    
    // set image shadow
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 0.75;
    cell.clipsToBounds = YES;
    
    // set text shadow
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.shadowOpacity = 0.5;
    
    // rasterize
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}


#pragma mark - privite method
- (NSString *)randomName
{
    NSArray *first = @[@"Alice", @"Bob", @"Bill", @"Charles", @"Dan", @"Dave", @"Ethan", @"Frank"];
    NSArray *last = @[@"Appleseed", @"Bandicoot", @"Caravan", @"Dabble", @"Ernest", @"Fortune"];
    NSUInteger index1 = (rand()/(double)INT_MAX) * [first count];
    NSUInteger index2 = (rand()/(double)INT_MAX) * [last count];
    return [NSString stringWithFormat:@"%@ %@", first[index1], last[index2]];
}

- (NSString *)randomAvatar
{
    NSArray *images = @[@"Play.png", @"Pause.png", @"twitterlogo.png"];
    NSUInteger index = (rand()/(double)INT_MAX) * [images count];
    return images[index];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
