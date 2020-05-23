//
//  bezierPathHiteTestViewController.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/23.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "bezierPathHiteTestViewController.h"

@interface bezierPathView : UIView
@property (nonatomic, strong) UIBezierPath *bezierPath;
@end

@implementation bezierPathView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    if ([self.bezierPath containsPoint:point]) {
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect{
    
    self.bezierPath = [UIBezierPath bezierPath];
    [self.bezierPath moveToPoint:CGPointMake(0, rect.size.height)];
    [self.bezierPath addLineToPoint:CGPointMake(rect.size.width, 0)];
    [self.bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [self.bezierPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [[UIColor redColor]setFill];
    [self.bezierPath fill];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches bezierPathView");
}

@end

@interface bezierPathHiteTestViewController ()

@end

@implementation bezierPathHiteTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    bezierPathView *view = [[bezierPathView alloc]initWithFrame:CGRectMake(100, 100, self.self.view.frame.size.width-200, 100)];
    [self.view addSubview:view];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches superView");

}

@end
