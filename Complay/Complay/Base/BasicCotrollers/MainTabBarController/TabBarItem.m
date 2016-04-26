//
//  TabBarItem.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "TabBarItem.h"
#import "LPBadgeView.h"

@interface TabBarItem ()<LPBadgeViewDelegate>
{
    UIImageView *imgView;
    UILabel *titleLabel;
    LPBadgeView *badgeView;
}
@end

@implementation TabBarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    imgView = [UIImageView new];
    imgView.alpha = TabBarItemAlpha;
    imgView.contentMode = UIViewContentModeCenter;
    imgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self addSubview:imgView];
    
    titleLabel = [UILabel new];
    titleLabel.alpha = TabBarItemAlpha;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:titleLabel];
    
    badgeView = [LPBadgeView badgeWithColor:[UIColor redColor]];
    badgeView.value = 0;
    badgeView.delegate = self;
    [self addSubview:badgeView];
}

- (void)setImage:(UIImage *)image
{
    imgView.image = image;
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (void)setBadgeNum:(int)badgeNum
{
    badgeView.value = badgeNum;
}


//重写高宽设置
- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(self.frame.size, frame.size)) {
        [super setFrame:frame];
        imgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*0.7);
        titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame), frame.size.width, 10);
        badgeView.center = CGPointMake(CGRectGetMidX(imgView.frame)+20, CGRectGetMidY(imgView.frame)-5);
    }else{
        [super setFrame:frame];
    }
}
- (void)setBounds:(CGRect)bounds
{
    if (!CGSizeEqualToSize(self.bounds.size, bounds.size)) {
        [super setBounds:bounds];
        imgView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height*0.7);
        titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame), bounds.size.width, 10);
    }else{
        [super setBounds:bounds];
    }
}


//重写点击事件
- (void)setSelected:(BOOL)selected
{
    if (!self.selected && selected) {
        imgView.alpha = 1;
        titleLabel.alpha = 1;
        [UIView animateWithDuration:0.1 animations:^{
            imgView.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.15, 1.15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imgView.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            }];
        }];
    }
    else if (self.selected && !selected) {
        imgView.alpha = TabBarItemAlpha;
        titleLabel.alpha = TabBarItemAlpha;
    }
    [super setSelected:selected];
}

#pragma mark - <LPBadgeViewDelegate>
- (void)badgeViewDidClearValue:(int)value
{
    if (_hideBadgeBlock) _hideBadgeBlock(value);
}

@end
