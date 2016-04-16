//
//  AddView.h
//  Complay
//
//  Created by liuping on 16/4/10.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddView : UIView

@property (strong, nonatomic) void (^hideBlock)();

- (void)show;
- (void)hide;

@end
