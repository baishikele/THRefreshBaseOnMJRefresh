//
//  THRefreshHeader.m
//  sss
//
//  Created by jm on 2018/10/8.
//  Copyright © 2018年 jm. All rights reserved.
//

#import "THRefreshHeader.h"
#import <MJRefresh/MJRefresh.h>

@interface THRefreshHeader()

@property (nonatomic, strong) UILabel * logoView;
@property (nonatomic, strong) UIImageView * circleView;
@property (nonatomic, strong) CAShapeLayer * circleLayer;
@property (nonatomic, assign) BOOL hasRefreshed;

@end
@implementation THRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Const
CGRect kZZZLogoViewBounds = {0,0,35,35};
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.hasRefreshed = NO;//初始化的时候，肯定是没有刷新过的

    [self addSubview:self.logoView];
    
    [self addSubview:self.circleView];

}

#pragma mark 在这里设置子控件的位置和尺寸

- (void)placeSubviews
{
    [super placeSubviews];
    self.logoView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0 + 10.0);// +10是为了logoView在中心点往下一点的位置，方便观看
    self.logoView.bounds = kZZZLogoViewBounds;
    self.circleView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0 + 10.0);// +10是为了logoView在中心点往下一点的位置，方便观看
    self.circleView.bounds = kZZZLogoViewBounds;
}

#pragma mark - setter & getter

- (UILabel *)logoView{
    if (!_logoView) {
        _logoView = [[UILabel alloc] init];
        _logoView.text = @"🐰";
        _logoView.textAlignment = NSTextAlignmentCenter;
        [_logoView.layer addSublayer:self.circleLayer];
    }
    return _logoView;
}

- (UIImageView *)circleView{
    if (!_circleView) {
        _circleView = [[UIImageView alloc] init];
        _circleView.image = [UIImage imageNamed:@"ic_loading"];
        _circleLayer.hidden = YES; //刷新时候的图片，开始的时候不需要显示出来

    }
    return _circleView;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [self creatCircleShapeLayerWithBounds:kZZZLogoViewBounds];//跟上面的getShapeLayer方法一样，不过这里我稍微改写了原函数，减少依赖
    }
    return _circleLayer;
}

- (CAShapeLayer *)creatCircleShapeLayerWithBounds:(CGRect) rect{
    UIBezierPath *path       = [UIBezierPath bezierPathWithOvalInRect:rect];//先写剧本
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path          = path.CGPath;//安排剧本
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;//填充色要为透明，不然会遮挡下面的图层
    shapeLayer.strokeColor   = [UIColor redColor].CGColor;
    shapeLayer.lineWidth     = 1.0;
    shapeLayer.frame         = rect;
    shapeLayer.strokeEnd = 0;
    
    return shapeLayer;
}




#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.circleView.hidden = YES;
            self.circleLayer.hidden = NO;
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            self.circleView.hidden = NO;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.circleLayer.hidden = YES;
            [CATransaction commit];
            
    
            self.hasRefreshed = YES;//刷新过了

            [self.circleView.layer addAnimation:[self creatTransformAnimation] forKey:nil];
            break;
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    if (self.hasRefreshed) {//刷新返回的时候，strokeEnd = 1.0
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeEnd = 1.0;
        [CATransaction commit];
        self.hasRefreshed = NO;//重置状态为未刷新
    }else{
        self.circleLayer.strokeEnd = pullingPercent;
    }
    
  }

- (void)endRefreshing{
    
    [self.circleView.layer removeAllAnimations];
    [super endRefreshing];
}

- (CABasicAnimation *)creatTransformAnimation{
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"]; //指定对transform.rotation属性做动画
    animation.duration            = 2.0f; //设定动画持续时间
    animation.byValue             = @(M_PI*2); //设定旋转角度，单位是弧度
    animation.fillMode            = kCAFillModeForwards;//设定动画结束后，不恢复初始状态之设置一
    animation.repeatCount         = 1000;//设定动画执行次数
    animation.removedOnCompletion = NO;//设定动画结束后，不恢复初始状态之设置二
 
    return animation;
}

@end
