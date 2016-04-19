//
//  HeadImgView.m
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "HeadImgView.h"

@implementation HeadImgView


#pragma mark - 重写
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 60, 60);
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    if (!self.image) {
        self.image = nil;
    }
    [self initView];
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        [super setImage:image];
    }else{
        [super setImage:[UIImage imageNamed:@"default_head_img"]];
    }
}

#pragma mark - 添加手势
- (void)initView
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHeadView)];
    [self addGestureRecognizer:tap];
}

#pragma mark - 点击查看对呀用户信息
- (void)pressedHeadView
{
    if (_clickBlock) _clickBlock();
}

@end
