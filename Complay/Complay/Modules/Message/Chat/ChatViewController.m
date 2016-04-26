//
//  ChatViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgTool.h"

#define BottomViewHeightNormal 75.0l
#define BottomViewHeightEditing 275.0l

@interface ChatViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
    __weak IBOutlet UITextField *msgTextField;
    
    
}
@end

@implementation ChatViewController

#pragma mark - 重写以及加载处理
//返回(重写)
- (void)goback
{
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self registNotifications];
}

///注册通知
- (void)registNotifications
{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(receiveNewMsg:) name:kNewMsgNotifacation object:nil];
    [noti addObserver:self selector:@selector(bottomViewFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [noti addObserver:self selector:@selector(bottomViewHide) name:UIKeyboardWillHideNotification object:nil];
}


//界面处理
- (void)initView
{
    bottomViewHeightConstraint.constant = BottomViewHeightNormal;
    
    msgTextField.delegate = self;
    msgTextField.leftViewMode = UITextFieldViewModeAlways;
    msgTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    
}

//滚动到底部
- (void)scrollToBottom
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//键盘高度变化时
- (void)bottomViewFrameChange:(NSNotification *)noti
{
    bottomViewHeightConstraint.constant = BottomViewHeightNormal;
    NSValue *sizeValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [sizeValue CGRectValue].size.height;
    bottomViewBottomConstraint.constant = height;
    [UIView animateWithDuration:0.3 animations:^{
        [bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
}

//键盘收起时
- (void)bottomViewHide
{
    bottomViewBottomConstraint.constant = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
}

#pragma mark - 各种消息编辑
- (IBAction)didSelectEditMsgButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [msgTextField resignFirstResponder];
    if (sender.selected) {
        bottomViewHeightConstraint.constant = BottomViewHeightEditing;
    }else{
        bottomViewHeightConstraint.constant = BottomViewHeightNormal;
    }
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
- (void)sendTextMsg
{
    //创建BmobIMTextMessage对象
    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:msgTextField.text attributes:nil];
    message.conversationType =  BmobIMConversationTypeSingle;//单聊
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    
    //会话
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message.content);
    }];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendTextMsg];
    [textField resignFirstResponder];
    return YES;
}

@end
