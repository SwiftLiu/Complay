//
//  ChatViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgTool.h"
#import "ChatExpressionView.h"

#define BottomViewBottomNormal -200.0l
#define BottomViewBottomSelected 0.0l

@interface ChatViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UITableView *msgTableView;
    
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
    __weak IBOutlet UITextView *msgTextView;
    __weak IBOutlet NSLayoutConstraint *msgTextViewHeightConstraint;
    __weak IBOutlet UIView *bottomEditView;
    
    
    ///选中的按钮
    __weak UIButton *selectedMsgEditButton;
    ///键盘收起时是否执行动画
    BOOL hideKeyboardShouldAnimate;
    ///输入框是否正在编辑
    BOOL msgTextViewEditing;
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
    hideKeyboardShouldAnimate = YES;
    
    bottomViewBottomConstraint.constant = BottomViewBottomNormal;
    
    msgTextView.delegate = self;
    
}

//键盘高度变化时
- (void)bottomViewFrameChange:(NSNotification *)noti
{
    NSValue *sizeValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [sizeValue CGRectValue].size.height;
    [self bottomViewAnimationWithBottom:height+BottomViewBottomNormal];
}

//键盘收起时
- (void)bottomViewHide
{
    if (hideKeyboardShouldAnimate) {
        [self bottomViewAnimationWithBottom:BottomViewBottomNormal];
    }
}

#pragma mark - 辅助方法
//滚动到底部
- (void)scrollToBottom
{
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
    //    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//BottomView高度变化动画
- (void)bottomViewAnimationWithBottom:(CGFloat)constant
{
    bottomViewBottomConstraint.constant = constant;
    [UIView animateWithDuration:0.3 animations:^{
        [bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
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



#pragma mark - 各种消息编辑
- (IBAction)didSelectEditMsgButton:(UIButton *)sender {
    NSLog(@"%ld, %ld", [msgTextView selectedRange].location, [msgTextView selectedRange].length);
    //界面处理
    //定位或相机
    if (sender.tag == 11 || sender.tag == 13) {
        sender.selected = YES;
        if (msgTextViewEditing) {
            [msgTextView endEditing:YES];
        }
    }
    //语言、图片或表情
    else{
        sender.selected = !sender.selected;
        for (UIView *sub in bottomEditView.subviews) {
            [sub removeFromSuperview];
        }
        if (sender.selected) {
            if (selectedMsgEditButton) selectedMsgEditButton.selected = NO;
            selectedMsgEditButton = sender;
            if (msgTextViewEditing) {
                hideKeyboardShouldAnimate = NO;
                [msgTextView endEditing:YES];
            }
            [self bottomViewAnimationWithBottom:BottomViewBottomSelected];
        }else{
            selectedMsgEditButton = nil;
            [self bottomViewAnimationWithBottom:BottomViewBottomNormal];
        }
    }
    
    //消息编辑
    if (!sender.selected) return;
    switch (sender.tag) {
        case 10: {//语音
            
        }
            break;
        case 11: {//定位
            
        }
            break;
        case 12: {//图片
            
        }
            break;
        case 13: {//相机
            UIImagePickerController *iPC = [UIImagePickerController new];
            iPC.sourceType = UIImagePickerControllerSourceTypeCamera;
            iPC.delegate = self;
            [self presentViewController:iPC animated:YES completion:^{
                sender.selected = NO;
            }];
        }
            break;
        case 14: {//表情
            ChatExpressionView *exprView = [ChatExpressionView expressionView];
            exprView.frame = bottomEditView.bounds;
            exprView.textView = msgTextView;
            [bottomEditView addSubview:exprView];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 发送消息
//发送文本消息
- (void)sendTextMsg
{
    //创建BmobIMTextMessage对象
    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:msgTextView.text attributes:nil];
    message.conversationType =  BmobIMConversationTypeSingle;//单聊
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    
    //会话
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message.content);
    }];
}







#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击return键发送文本信息
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMsg];
        textView.text = nil;
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //输入框高度变化动画
    CGFloat height = textView.contentSize.height;
    msgTextViewHeightConstraint.constant = MIN(height, 124);
    [UIView animateWithDuration:0.2 animations:^{
        [bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    msgTextViewEditing = YES;
    hideKeyboardShouldAnimate = YES;
    if (selectedMsgEditButton) selectedMsgEditButton.selected = NO;
    selectedMsgEditButton = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    msgTextViewEditing = NO;
}



#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
//    [self uploadHeadData:UIImagePNGRepresentation(img)];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
