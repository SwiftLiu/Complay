//
//  TabBarItem.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "TabBarItem.h"


@interface TabBarItem ()
{
    UIImageView *imgView;
    UILabel *label;
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
    self.alpha = TabBarItemAlpha;
    
    imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self addSubview:imgView];
    
    label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    [self addSubview:label];
}

- (void)setImage:(UIImage *)image
{
    imgView.image = image;
}

- (void)setTitle:(NSString *)title
{
    label.text = title;
}

//重写高宽设置
- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(self.frame.size, frame.size)) {
        [super setFrame:frame];
        imgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*0.7);
        label.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame), frame.size.width, 10);
    }else{
        [super setFrame:frame];
    }
}
- (void)setBounds:(CGRect)bounds
{
    if (!CGSizeEqualToSize(self.bounds.size, bounds.size)) {
        [super setBounds:bounds];
        imgView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height*0.7);
        label.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame), bounds.size.width, 10);
    }else{
        [super setBounds:bounds];
    }
}


//重写点击事件
- (void)setSelected:(BOOL)selected
{
    if (!self.selected && selected) {
        self.alpha = 1;
        [UIView animateWithDuration:0.1 animations:^{
            imgView.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.15, 1.15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imgView.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            }];
        }];
    }
    else if (self.selected && !selected) {
        self.alpha = TabBarItemAlpha;
    }
    [super setSelected:selected];
}

@end
