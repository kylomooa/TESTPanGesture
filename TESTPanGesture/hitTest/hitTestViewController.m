//
//  hitTestViewController.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/23.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "hitTestViewController.h"

@interface UIRedView : UIView

@end

@implementation UIRedView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"UIRedView touchesBegan");
}


@end

@interface CustomView : UIView

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.userInteractionEnabled = NO;
    }
    return self;
}

//touchesBegan会在hitTest之后调用
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"CustomView touchesBegan");
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    //会连续调用两次hitTest？，估计底层为了判断单击和双击而做的操作
    
    //如果自身userInteractionEnabled = NO，则中断自身遍历查找事件
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    //判断该点击事件在自己的frame内
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    //优先遍历最外层的view，如果找到点击的子view就返回，不再继续查找
    for (UIView *subView in [self.subviews reverseObjectEnumerator].allObjects ) {

        CGPoint subPoint = [subView convertPoint:point fromView:self];
        
        //如果子view有一个存在该响应事件，则返回子view
        return [subView hitTest:subPoint withEvent:event];
    }
    
    //如果子view都不存在该响应事件，则返回自己
    return self;
    
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //判断该点击事件在自己的frame内
    if (CGRectContainsPoint(self.frame, point)) {
        return YES;
    }
    return NO;
}

@end

@interface hitTestViewController ()
@property (nonatomic, strong) UIRedView *redView;
@property (nonatomic, strong) UIView *blueView;

@end

@implementation hitTestViewController

-(void)loadView{
    self.view = [[CustomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.redView];
    [self.view addSubview:self.blueView];
//    [self.view bringSubviewToFront:self.redView];

}

- (UIRedView *)redView {
    if (!_redView) {
        _redView = [[UIRedView alloc] initWithFrame:self.view.bounds];
        _redView.backgroundColor = [UIColor redColor];
        _redView.userInteractionEnabled = YES;
    }
    return _redView;
}

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:self.view.bounds];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}


@end
