//
//  TabBarItem.h
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarItemAlpha 0.4l

@interface TabBarItem : UIButton

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setBadgeNum:(int)badgeNum;
- (void)setHideBadgeBlock:(void(^)(int value))block;

@end
