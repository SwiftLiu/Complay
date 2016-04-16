//
//  BasicImgView.m
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "BasicImgView.h"

@implementation BasicImgView

#pragma mark - 重写
- (void)awakeFromNib
{
    if (!self.image) {
        self.image = nil;
    }
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        [super setImage:image];
    }else{
        [super setImage:[UIImage imageNamed:@"default_img"]];
    }
}

@end
