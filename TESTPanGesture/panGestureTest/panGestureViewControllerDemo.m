//
//  panGestureViewControllerDemo.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/7/21.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "panGestureViewControllerDemo.h"

@interface panGestureViewControllerDemo ()
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) CALayer *doorLayer;
@end

@implementation panGestureViewControllerDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //add the door
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 100, 128, 256);
    self.doorLayer.position = CGPointMake(150 - 64, 150);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[self getEmptyImag].CGImage;
    [self.view.layer addSublayer:self.doorLayer];
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    //add pan gesture recognizer to handle swipes
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    //pause all layer animations
    self.doorLayer.speed = 0.0;
    //apply swinging animation (which won't play because layer is paused)
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
    [self.doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    //get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    //convert from points to animation duration //using a reasonable scale factor
    x /= 200.0f;
    //update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    //reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
}


-(UIImage *)getEmptyImag{
    UIGraphicsBeginImageContext(CGSizeMake(128, 256));
    [[UIColor systemBlueColor] set];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 128, 256)] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
