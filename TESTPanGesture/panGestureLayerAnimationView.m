//
//  panGestureLayerAnimationView.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/24.
//  Copyright © 2020 maoqiang. All rights reserved.
//



#import "panGestureLayerAnimationView.h"

#define animationViewH 500

#define animationDuration 0.25

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface panGestureLayerAnimationView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIButton *restBtn;
@end

@implementation panGestureLayerAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.animationView];
        [self addPanGesture];
        [self.animationView addSubview:self.restBtn];
    }
    return self;
}

-(void)panGesture:(UIPanGestureRecognizer *)recognizer{
    
    CGFloat progressY = [recognizer translationInView:self].y / (self.bounds.size.height * 1.0);
    
    if (progressY < 0) {
        progressY = -progressY;
    }
    progressY = MIN(1.0, MAX(0.0, progressY));
    
    
    
//    NSLog(@"progressY = %f",progressY);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //判断滑动方式：横向or纵向
        CGPoint direction = [recognizer velocityInView:self];
        
        //上滑
        if (direction.y < 0) {
            [self moveUpAnimation];
        }else{
//            [self moveDownAnimation];
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
//        [self animationProgress:progressY];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
//        if (progressY > 0.2) {
//            [self finishAnimation];
//        }
    }
}

-(void)moveUpAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = animationDuration;
    animation.repeatCount = 1;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5*screenW, screenH)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5*screenW, screenH-0.5*animationViewH)];
    
    animation.delegate = self;
    
    //取消反弹
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;

    //timeoffset\beginTime时间解释参考https://www.jianshu.com/p/fb088f8ddb4e
    animation.beginTime = 0;//动画开始时间
    animation.timeOffset = 0;//动画执行时间
    
    //匀速动画
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.animationView.layer addAnimation:animation forKey:@"moveUp"];
//    self.animationView.layer.speed = 0;
}

-(void)animationProgress:(CGFloat )progress{
    
    
    self.animationView.layer.timeOffset = animationDuration*progress;
    NSLog(@"progress = %f",progress);

}

-(void)finishAnimation{
    
    CFTimeInterval pasuedTime= self.animationView.layer.timeOffset;
    
    self.animationView.layer.speed = 1;
    self.animationView.layer.beginTime = 0;
//    self.animationView.layer.beginTime = [self.animationView.layer convertTime:CACurrentMediaTime() toLayer:nil]-pasuedTime;

}

-(void)moveDownAnimation{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = animationDuration;
    animation.repeatCount = 1;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5*screenW, screenH-0.5*animationViewH)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5*screenW, screenH)];
    
    animation.delegate = self;
    
    //取消反弹
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    //timeoffset\beginTime时间解释参考https://www.jianshu.com/p/fb088f8ddb4e
    animation.beginTime = 0;//动画开始时间
    animation.timeOffset = 0;//动画执行时间
    
    //匀速动画
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.animationView.layer addAnimation:animation forKey:@"moveDown"];
    self.animationView.layer.speed = 0;

}

//CALayer animation不会改变UIView的frame，因为按钮位置在屏幕外没法被点击
-(void)resetAction{
    NSLog(@"resetAction");
}

-(void)addPanGesture{
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:pan];
}

-(UIView *)animationView{
    if (nil == _animationView) {
        
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH-animationViewH*0.5 , screenW, animationViewH)];
        _animationView.backgroundColor = [UIColor redColor];
    }
    return _animationView;
}

-(UIButton *)restBtn{
    if (nil == _restBtn) {
        _restBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, screenW-200, 40)];
        [_restBtn setTitle:@"未点中" forState:UIControlStateNormal];
        [_restBtn setTitle:@"已点中" forState:UIControlStateHighlighted];
        [_restBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_restBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _restBtn.backgroundColor = [UIColor whiteColor];
        [_restBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restBtn;
}

/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"%s",__func__);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%s",__func__);
}

@end
