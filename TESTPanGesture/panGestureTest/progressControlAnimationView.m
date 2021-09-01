//
//  progressControlAnimationView.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/24.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "progressControlAnimationView.h"

#define animationViewH 500
#define animationViewShowH (0.5*animationViewH)

#define animationDuration 0.25

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface progressControlAnimationView ()
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation progressControlAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        
        [self addSubview:self.animationView];
        [self.animationView addSubview:self.statusLabel];
        [self addPanGesture];
        
    }
    return self;
}

-(void)panGesture:(UIPanGestureRecognizer *)recognizer{
    
    CGFloat progressY = [recognizer translationInView:self].y / (self.bounds.size.height * 1.0);
    
    if (progressY < 0) {
        progressY = -progressY;
    }
    progressY = MIN(1.0, MAX(0.0, progressY));
    
    progressY = progressY * (screenH / animationViewShowH);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.layer.beginTime = 0;
        self.layer.timeOffset = 0;
        self.layer.speed = 0;
        self.layer.repeatCount = INT_MAX;
        
        //判断滑动方式：横向or纵向
        CGPoint direction = [recognizer velocityInView:self];
                    
        [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            if (direction.y > 0) {
                self.animationView.frame = CGRectMake(0, screenH-animationViewShowH, screenW, animationViewH);
            }else{
                self.animationView.frame = CGRectMake(0, screenH-animationViewH, screenW, animationViewH);
            }
        } completion:nil];
        

    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        if (progressY > 0.5) {
            self.statusLabel.text = @"松手自动继续动画";
        }else{
            self.statusLabel.text = [NSString stringWithFormat:@"滑动进度=%f",progressY];
        }

        [self animationProgress:progressY];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (progressY > 0.5) {
            //完成剩余动画
            [self finishAnimation];
        }else{
            //取消动画
            [self cancelAnimation];
        }
    }
}

/**
 对比初始动画speed=1的区别：
 *注意：这里和初始speed = 1的动画时间起始值不同，speed = 1的初始动画，其本地时间以父layer的本地时间础上开始计算；
 *而初始speed = 0时layer对象的动画进度 “不被” 系统时间的影响；
 
 原因：layer动画时间公式：t = (tp - begin) * 0 + timeOffset；
 所以：只需要修改timeOffset即可改变动画执行进度，
 
 */
-(void)animationProgress:(CGFloat )p{
    
    //该对象的本地时间timeOffset,它是相对于本地时间0s的一个偏移
    self.layer.timeOffset = p*animationDuration;
    
}

/**
//layer的动画渲染是根据layer的对象自身本地时间执行的（猜测）
t = (tp - begin) * speed + timeOffset
t - 本对象的本地时间
tp - 父对象的本地时间
begin - beginTime

参考动画的时间系统博客：https://www.jianshu.com/p/fb088f8ddb4e
*/
-(void)finishAnimation{
    
    //1、之前滑动时动画的最后执行时间
    CFTimeInterval pausedTime = self.layer.timeOffset;
        
    //2、将timeOffset还原（动画执行前设置的timeOffset的值，我这里之前没设置所以默认为0）
    self.layer.timeOffset = 0;
    
    //3、使layer对象的动画进度受到父对象本地时间的影响
    self.layer.speed = 1;
    
    //4、因为speed置为1后，layer对象的beginTime受到父对象本地时间的影响
    //所以layer对象动画执行时间为：t = (tp - begin) * speed + timeOffset，计算出layer动画对象的本地时间为:du（即手势结束动画时的time）
    self.layer.beginTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
}

//取消之前执行的进度动画
-(void)cancelAnimation{
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(cancelLink)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

-(void)cancelLink{
    
    CFTimeInterval duration = [self.displayLink duration];
    NSTimeInterval timeOffset = self.layer.timeOffset-duration;
    
    if (timeOffset < 0) {
        [self.displayLink invalidate];
    }else{
        self.layer.timeOffset = timeOffset;
    }
}


-(void)addPanGesture{
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:pan];
}

-(UIView *)animationView{
    if (nil == _animationView) {
        
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH-animationViewShowH , screenW, animationViewH)];
        _animationView.backgroundColor = [UIColor whiteColor];
    }
    return _animationView;
}

-(UILabel *)statusLabel{
    if (nil == _statusLabel) {
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        _statusLabel.textColor = [UIColor blackColor];
    }
    return _statusLabel;
}
@end

