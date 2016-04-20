//
//  ChatViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatViewController.h"
#import <BmobIMSDK/BmobIMSDK.h>

@interface ChatViewController ()
{
    
    __weak IBOutlet UITextField *textField;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setChatUserId:(NSString *)chatUserId
{
    _chatUserId = chatUserId;
    self.title = chatUserId;
}


- (IBAction)send:(UIButton *)sender {
    [textField endEditing:YES];
    
    //创建BmobIMTextMessage对象
    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:textField.text attributes:nil];
    message.conversationType =  BmobIMConversationTypeSingle;//单聊
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    
    //会话
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:_chatUserId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = @"测试";
//    conversation.conversationId = _chatUserId;
    [conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message);
    }];
}

@end
