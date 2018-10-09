//
//  THRefreshFooter.m
//  sss
//
//  Created by jm on 2018/10/8.
//  Copyright © 2018年 jm. All rights reserved.
//

#import "THRefreshFooter.h"

@interface THRefreshFooter()

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@property (nonatomic, strong) UIButton * loadMoreBtn;

@end

@implementation THRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
        
    }
    return _stateTitles;
}
- (void)prepare
{
    [super prepare];
    
    self.stateTitles[@(MJRefreshStateIdle)] = @" 上拉加载更多";
    self.stateTitles[@(MJRefreshStateRefreshing)] = @" 刷新中...";
    self.stateTitles[@(MJRefreshStateNoMoreData)] = @" 没有更多了";

    [self addSubview:self.loadMoreBtn];
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loadMoreBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MJRefreshFooterHeight);
}



#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    [self.loadMoreBtn setTitle:self.stateTitles[@(state)] forState:UIControlStateNormal];

    if (state == MJRefreshStateRefreshing) {
        [self.loadMoreBtn setImage:[UIImage imageNamed:@"ic_loading"] forState:UIControlStateNormal];
        [self.loadMoreBtn.imageView.layer addAnimation:[self creatTransformAnimation] forKey:nil];
    } else {
        [self.loadMoreBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)endRefreshing{
    
    [self.loadMoreBtn.imageView.layer removeAllAnimations];
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


- (UIButton *)loadMoreBtn{
    if (_loadMoreBtn == nil) {
        _loadMoreBtn = [[UIButton alloc] init];
        _loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_loadMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _loadMoreBtn;
}
@end
