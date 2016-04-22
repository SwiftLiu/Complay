//
//  HeadImgView.m
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "AvatarView.h"
#import "UIImageView+WebCache.h"


#define DefaultAvatarImg [UIImage imageNamed:@"default_head_img"]

@implementation AvatarView


#pragma mark - 重写
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 45, 45);
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
        [super setImage:DefaultAvatarImg];
    }
}

#pragma mark - 添加手势
- (void)initView
{
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHeadView)];
    [self addGestureRecognizer:tap];
}

#pragma mark - 下载头像
- (void)getAvatar:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:DefaultAvatarImg];
}

#pragma mark - 点击查看对呀用户信息
- (void)pressedHeadView
{
    if (_clickBlock) _clickBlock();
}

@end
