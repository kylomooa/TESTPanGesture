//
//  pauseAnimationView.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/24.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "pauseAnimationView.h"

#define animationViewH 500
#define animationViewShowH (0.5*animationViewH)

#define animationDuration 2

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface pauseAnimationView ()
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation pauseAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.animationView];
        [self addSubview:self.startBtn];
        [self addSubview:self.resumeBtn];

    }
    return self;
}


-(void)moveUpAnimation{
    
    NSLog(@"self.animationView.layer.beginTime = %f",self.animationView.layer.beginTime);
    
    //还原之前动画对象的时间
    self.animationView.layer.beginTime = 0;
    self.animationView.layer.timeOffset = 0;
    
    [self.animationView.layer removeAllAnimations];
    self.animationView.frame = CGRectMake(0, screenH-animationViewH+animationViewShowH, screenW, animationViewH);
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.animationView.frame = CGRectMake(0, screenH-animationViewH, screenW, animationViewH);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pauseLayer:self.animationView.layer];
    });
}


/**
 //layer的动画渲染是根据layer的对象自身本地时间执行的（猜测）
 t = (tp - begin) * speed + timeOffset
 t - 本对象的本地时间
 tp - 父对象的本地时间
 begin - beginTime
 
 参考动画的时间系统博客：https://www.jianshu.com/p/fb088f8ddb4e
 */
-(void)pauseLayer:(CALayer*)layer
{
    
    //这3步主要作用是让layer动画对象的时间静止，从而使渲染引擎不会对该layer操作(猜测)
    
    //1、计算暂停之前 "动画layer" 的对象 "时间"
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2、设置speed = 0，使(tp - begin) * speed = 0；
    layer.speed = 0.0;
    
    //3、将暂停时间赋值给timeOffset，保证时间固定
    //layer对象本地时间为：t = (tp - begin) * 0 + timeOffset；（为固定值）
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{

    //1、拿到暂停时动画的最后时间
    CFTimeInterval pausedTime = layer.timeOffset;
    
    //2、使layer对象的动画进度受到父对象本地时间的影响
    layer.speed = 1.0;
    
    //3、将timeOffset还原（动画执行前设置的timeOffset的值，我这里之前没设置所以默认为0）
    layer.timeOffset = 0.0;
    
    //4、将动画暂停的时间间隔赋值给beginTime
    //所以layer对象本地时间为：t = (tp - begin) * speed + timeOffset，计算出layer动画对象的时间为:pausedTime（即暂停动画前的时间）
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


-(void)resumeAction{
    [self resumeLayer:self.animationView.layer];
}


-(UIView *)animationView{
    if (nil == _animationView) {
        
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH-animationViewShowH , screenW, animationViewH)];
        _animationView.backgroundColor = [UIColor redColor];
    }
    return _animationView;
}

-(UIButton *)startBtn{
    if (nil == _startBtn) {
        _startBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, screenW-200, 40)];
        [_startBtn setTitle:@"开始动画" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _startBtn.backgroundColor = [UIColor blackColor];
        [_startBtn addTarget:self action:@selector(moveUpAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

-(UIButton *)resumeBtn{
    if (nil == _resumeBtn) {
        _resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, screenW-200, 40)];
        [_resumeBtn setTitle:@"继续动画" forState:UIControlStateNormal];
        [_resumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resumeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _resumeBtn.backgroundColor = [UIColor blackColor];
        [_resumeBtn addTarget:self action:@selector(resumeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resumeBtn;
}

@end

