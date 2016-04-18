
//
//  LoadView.m
//  Complay
//
//  Created by FineexMac on 16/4/12.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "LoadView.h"

@interface LoadView ()
{
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *capionLabel;
}
@end

@implementation LoadView

///便利初始化
+ (LoadView *)loadView
{
    NSString *nibName = NSStringFromClass([self class]);
    LoadView *load = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    return load;
}

///加载中
- (void)startLoading;
{
    [imgView stopAnimating];
    imgView.animationImages = AnimImgs(@"loading", 8);
    imgView.animationRepeatCount = 0;
    imgView.animationDuration = 0.7;
    [imgView startAnimating];
    imgView.userInteractionEnabled = NO;
    capionLabel.text = @"使劲儿加载中...";
}

///加载成功
- (void)endLoadSucceed
{
    [imgView stopAnimating];
    imgView.animationImages = nil;
}

///加载成功，但无数据
- (void)endLoadNoData
{
    [imgView stopAnimating];
    imgView.animationImages = AnimImgs(@"loadnodata", 6);
    imgView.animationRepeatCount = 0;
    imgView.animationDuration = 0.5;
    [imgView startAnimating];
    imgView.userInteractionEnabled = NO;
    capionLabel.text = @"暂无相关数据";
}

///加载失败
- (void)endLoadFailed
{
    [imgView stopAnimating];
    NSArray *imgs = AnimImgs(@"loadfail", 6);
    imgView.image = imgs.lastObject;
    imgView.animationImages = imgs;
    imgView.animationRepeatCount = 1;
    imgView.animationDuration = 0.5;
    [imgView startAnimating];
    imgView.userInteractionEnabled = YES;
    capionLabel.text = @"加载失败，点击重新加载";
}

///重新加载
- (IBAction)reload:(UITapGestureRecognizer *)sender {
    [self.delegate loadViewDidReloading];
}

#pragma mark - 
NSArray *AnimImgs(NSString *key, int count) {
    NSMutableArray *imgs = [NSMutableArray new];
    for (int i=1; i<=count; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@%04d",key, i];
        UIImage *img = [UIImage imageNamed:imgName];
        if (img) [imgs addObject:img];
    }
    return imgs;
}

@end
