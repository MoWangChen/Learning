//
//  SolidViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/6/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "SolidViewController.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 1, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface SolidViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray<UIView *> *faces;

@end

@implementation SolidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    _containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_containerView];
    
    // set up the container view sublayer transform
    // 在绕轴做旋转时,X轴,Y轴,Z轴是顺时针旋转指定角度
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    
    // add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    // add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    // add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    // add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    // add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    // add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    //get the face view add add it to the container
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    //center the face view within the container
    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    //apply the transform
    face.layer.transform = transform;
    
    //apply lighting
    [self applyLightingToFace:face.layer];
}

- (void)applyLightingToFace:(CALayer *)face
{
    // add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    // convert face transform to matrix
    // (CLKMatrix4 has the same structure as CATransform3D)
    // CLKMatri4 和 CAtransform3D内存结构一致,但坐标类型有长度区别,所以理论上应该做一次float到CGFloat的转换
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    // get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    // get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    // set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}

- (NSArray<UIView *> *)faces
{
    if (!_faces) {
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:6];
        for (int i = 0; i <= 5; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            label.font = [UIFont systemFontOfSize:30];
            label.text = [NSString stringWithFormat:@"%d",i + 1];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderWidth = 2.f;
            label.layer.borderColor = [UIColor blackColor].CGColor;
            [view addSubview:label];
            label.center = CGPointMake(100, 100);
            
            [mutArr addObject:view];
        }
        _faces = mutArr.copy;
    }
    return _faces;
}

@end
