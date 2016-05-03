//
//  ChatViewController.h
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "BasicViewController.h"
#import <BmobIMSDK/BmobIMSDK.h>

@interface ChatViewController : BasicViewController

@property (strong, nonatomic) BmobIMConversation *conversation;

@end



#pragma mark - 表情管理
#define ChatExprMinUnicode 0xEEA0

///获取表情
NSAttributedString *ChatExpression(unichar exprChar, CGFloat size);