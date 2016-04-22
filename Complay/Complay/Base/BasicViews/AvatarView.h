//
//  HeadImgView.h
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarView : UIImageView

///点击事件
@property (strong, nonatomic) void (^clickBlock)();

///下载头像
- (void)getAvatar:(NSString *)url;

@end
