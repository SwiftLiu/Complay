//
//  ChatViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgTool.h"

@interface ChatViewController ()
{
    
    __weak IBOutlet UITextField *textField;
}
@end

@implementation ChatViewController

#pragma mark - 重写以及加载处理
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registNotifications];
}

//返回(重写)
- (void)goback
{
    //更新缓存
    [self.conversation updateLocalCache];
    //返回
    [super goback];
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//设置会话
- (void)setConversation:(BmobIMConversation *)conversation
{
    _conversation = conversation;
    self.title = conversation.conversationTitle;
}


///注册通知
- (void)registNotifications
{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(receiveNewMsg:) name:kNewMsgNotifacation object:nil];
}


#pragma mark - 界面处理
//滚动到底部
- (void)scrollToBottom
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - 接收到新消息
- (void)receiveNewMsg:(NSNotification *)noti
{
    BmobIMMessage *message = noti.object;
    if (message.extra[KEY_IS_TRANSIENT] && [message.extra[KEY_IS_TRANSIENT] boolValue]) {
        return;
    }
    
    if ([message.fromId isEqualToString:self.conversation.conversationId]) {
//        [self.messagesArray addObject:tmpMessage];
//        [self scrollToBottom];
    }
    
}

#pragma mark - 发送消息
//发送文本消息
- (IBAction)send:(UIButton *)sender {
    [textField endEditing:YES];
    
    //创建BmobIMTextMessage对象
    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:textField.text attributes:nil];
    message.conversationType =  BmobIMConversationTypeSingle;//单聊
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    
    //会话
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message.content);
    }];
}

@end
