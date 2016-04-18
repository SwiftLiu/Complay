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
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetMidX(self.bounds);
    }
    return self;
}

- (void)awakeFromNib
{
    if (!self.image) {
        self.image = nil;
    }
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        [super setImage:image];
    }else{
        [super setImage:[UIImage imageNamed:@"default_head_img"]];
    }
}

@end
