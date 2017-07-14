//
//  AlphaViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/6/28.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "AlphaViewController.h"

@interface AlphaViewController ()



@end

@implementation AlphaViewController

/*
    这是由透明度的混合叠加造成的，当你显示一个50%透明度的图层时，图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
    在我们的示例中，按钮和表情都是白色背景。虽然他们都是50%的可见度，但是合起来的可见度是75%，所以标签所在的区域看上去就没有周围的部分那么透明。所以看上去子视图就高亮了，使得这个显示效果都糟透了。
    理想状况下，当你设置了一个图层的透明度，你希望它包含的整个图层树像一个整体一样的透明效果。你可以通过设置Info.plist文件中的UIViewGroupOpacity为YES来达到这个效果，但是这个设置会影响到这个应用，整个app可能会受到不良影响。如果UIViewGroupOpacity并未设置，iOS 6和以前的版本会默认为NO（也许以后的版本会有一些改变）。
    另一个方法就是，你可以设置CALayer的一个叫做shouldRasterize属性（见清单4.7）来实现组透明的效果，如果它被设置为YES，在应用透明度之前，图层及其子图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self testAlpha];
}

- (void)testAlpha
{
    [self testView];
    [self testLayer];
}

- (void)testView
{
    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 70, 70)];
    backview1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    label1.text = @"test1";
    label1.backgroundColor = [UIColor whiteColor];
    [backview1 addSubview:label1];
    
    UIView *backview2 = [[UIView alloc] initWithFrame:CGRectMake(130, 30, 70, 70)];
    backview2.backgroundColor = [UIColor whiteColor];
    backview2.alpha = 0.5;
    [self.view addSubview:backview2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    label2.text = @"test2";
    label2.backgroundColor = [UIColor whiteColor];
    label2.alpha = 0.5;
    [backview2 addSubview:label2];
}

- (void)testLayer
{
    CALayer *backlayer1 = [[CALayer alloc] init];
    backlayer1.frame = CGRectMake(30, 130, 70, 70);
    backlayer1.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:backlayer1];
    
    CATextLayer *textLayer1 = [[CATextLayer alloc] init];
    textLayer1.frame = CGRectMake(15, 15, 40, 40);
    textLayer1.backgroundColor = [UIColor whiteColor].CGColor;
    textLayer1.string = @"layer1";
    textLayer1.foregroundColor = [UIColor blackColor].CGColor;
    textLayer1.contentsScale = [UIScreen mainScreen].scale;
    [backlayer1 addSublayer:textLayer1];
    
    CALayer *backlayer2 = [[CALayer alloc] init];
    backlayer2.frame = CGRectMake(130, 130, 70, 70);
    backlayer2.backgroundColor = [UIColor whiteColor].CGColor;
    backlayer2.opacity = 0.5;
    [self.view.layer addSublayer:backlayer2];
    
    CATextLayer *textLayer2 = [[CATextLayer alloc] init];
    textLayer2.frame = CGRectMake(15, 15, 40, 40);
    textLayer2.backgroundColor = [UIColor whiteColor].CGColor;
    textLayer2.string = @"layer2";
    textLayer2.foregroundColor = [UIColor blackColor].CGColor;
    textLayer2.contentsScale = [UIScreen mainScreen].scale;
    textLayer2.opacity = 0.5;
    [backlayer2 addSublayer:textLayer2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
