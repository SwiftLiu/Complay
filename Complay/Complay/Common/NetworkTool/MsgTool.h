//
//  MsgTool.h
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "UserModel.h"

///新消息
static NSString *kNewMsgNotifacation = @"newMsgNotifacation";
///新聊天用户
static NSString *kNewChaterNotifacation = @"newChaterNotifacation";

@interface MsgTool : NSObject <BmobIMDelegate>


@end
