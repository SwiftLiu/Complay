//
//  AddView.m
//  Complay
//
//  Created by liuping on 16/4/10.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height-49);
    [window addSubview:self];
    
    NSArray *titles = @[@"", @"", @"", @""];
    NSArray *imgNames = @[@"", @"", @"", @""];
    for (int i=0; i<titles.count; i++) {
        [self initaItem:titles[i] imgName:imgNames[i]];
    }

    //动画
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        for (int i=0; i<self.subviews.count; i++) {
            UIView *item = [self.subviews objectAtIndex:i];
            item.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            double angle = (i+0.5) * M_PI / self.subviews.count;
            CGFloat x = CGRectGetMidX(self.bounds) + cos(angle) * 100;
            CGFloat y = CGRectGetMaxY(self.bounds) - sin(angle) * 100;
            item.center = CGPointMake(x, y);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            for (int i=0; i<self.subviews.count; i++) {
                UIView *item = [self.subviews objectAtIndex:i];
                double angle = (i+0.5) * M_PI / self.subviews.count;
                CGFloat x = CGRectGetMidX(self.bounds) + cos(angle) * 80;
                CGFloat y = CGRectGetMaxY(self.bounds) - sin(angle) * 80;
                item.center = CGPointMake(x, y);
            }
        }];
    }];
}

- (void)hide
{
    if (_hideBlock) _hideBlock();
    [self removeFromSuperview];
}

- (UIButton *)initaItem:(NSString *)title imgName:(NSString *)imgName
{
    UIButton *item = [UIButton new];
    item.backgroundColor = [UIColor redColor];
    item.bounds = CGRectMake(0, 0, 40, 40);
    item.center = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height + 20);
    item.layer.cornerRadius = item.bounds.size.width/2.0l;
    item.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [self addSubview:item];
    return item;
}



@end
