//
//  panGestureViewController.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/24.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "panGestureViewController.h"
#import "panGestureLayerAnimationView.h"
#import "progressControlAnimationView.h"
#import "pauseAnimationView.h"

@interface panGestureViewController ()

@end

@implementation panGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width-200, 40)];
    [btn setTitle:@"Btn" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    //layer动画（layer动画不改变view的frame，不适合需要点击的view做动画）
//    panGestureLayerAnimationView *view = [[panGestureLayerAnimationView alloc]initWithFrame:self.view.bounds];
    
    //暂停动画
    //    pauseAnimationView *view = [[pauseAnimationView alloc]initWithFrame:self.view.bounds];
    
    //手势进度动画
    progressControlAnimationView *view = [[progressControlAnimationView alloc]initWithFrame:self.view.bounds];
    
    
    [self.view addSubview:view];
    
}



@end
