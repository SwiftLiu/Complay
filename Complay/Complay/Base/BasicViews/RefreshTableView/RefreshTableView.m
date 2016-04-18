//
//  RefreshTableView.m
//  Complay
//
//  Created by liuping on 16/4/12.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "RefreshTableView.h"

#define BeginRefreshOffsetY -64.0l

@interface RefreshTableView ()<UIScrollViewDelegate>
{
    BOOL hasInit;
    BOOL refreshing;
    BOOL shouldRefreshing;
    BOOL dragging;
    
    UIImageView *aniView;
    CABasicAnimation *moveAni;
}
@end

@implementation RefreshTableView

#pragma mark - 重写
- (void)layoutSubviews
{
    if (!hasInit) {
        hasInit = YES;
        ((UIScrollView *)(self)).delegate = self;
        //背景
        UIImageView *imgView = [UIImageView new];
        imgView.image = [UIImage imageNamed:@"refresh_bg"];
        CGFloat width = self.bounds.size.width;
        CGFloat height = imgView.image.size.height;
        imgView.frame = CGRectMake(0, -height, width, height);
        [self insertSubview:imgView atIndex:0];
        //动画
        aniView = [UIImageView new];
        aniView.bounds = CGRectMake(0, 0, 30, 30);
        aniView.contentMode = UIViewContentModeScaleAspectFit;
        aniView.animationRepeatCount = 0;
        aniView.animationDuration = 1;
        [imgView addSubview:aniView];
        //移动动画
        moveAni = [CABasicAnimation new];
        moveAni.keyPath = @"position";
        moveAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 25)];
        moveAni.toValue = [NSValue valueWithCGPoint:CGPointMake(width, 25)];
        moveAni.duration = 5.0l;
        moveAni.repeatCount = HUGE_VALF;
        moveAni.autoreverses = NO;
    }
}

#pragma mark - 开始刷新
- (void)beginRefreshing
{
    if (!refreshing) {
        refreshing = YES;
//        [self setContentOffset:CGPointMake(0, BeginRefreshOffsetY) animated:YES];
        //打开动画
        NSMutableArray *imgs = [NSMutableArray array];
        for (int i=1; i<=10; i++) {
            NSString *name = [NSString stringWithFormat:@"refreshing%04d", i];
            UIImage *img = [UIImage imageNamed:name];
            if (img) [imgs addObject:img];
        }
        aniView.animationImages = imgs;
        [aniView startAnimating];
        [aniView.layer addAnimation:moveAni forKey:@"move"];
    }
}

#pragma mark - 结束刷新
- (void)endRefreshing
{
    if (refreshing) {
        refreshing = NO;
        if (!dragging) [self setContentOffset:CGPointZero animated:YES];
        //关闭动画
        [aniView stopAnimating];
        aniView.animationImages = nil;
        [aniView.layer removeAnimationForKey:@"move"];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dragging = YES;
    shouldRefreshing = !refreshing;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    dragging = NO;
    if (shouldRefreshing) {
        if (scrollView.contentOffset.y<BeginRefreshOffsetY) {
            self.scrollsToTop = NO;
            [self setContentOffset:CGPointMake(0, 30) animated:YES];
            [self beginRefreshing];
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return NO;
}

@end
