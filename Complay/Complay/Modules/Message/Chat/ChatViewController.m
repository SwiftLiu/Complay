//
//  ChatViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgTool.h"
#import "ChatInputTextView.h"
#import "ChatExpressionView.h"
#import "ChatPhotoView.h"

#define BottomViewBottomNormal -200.0l
#define BottomViewBottomSelected 0.0l

//列表cell标识
static NSString * const ChatTextCellId = @"ChatTextCellId";

@interface ChatViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChatExpressionViewDelegate, ChatPhotoViewDelegate>
{
    __weak IBOutlet UITableView *msgTableView;
    
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
    __weak IBOutlet ChatInputTextView *msgTextView;
    __weak IBOutlet NSLayoutConstraint *msgTextViewHeightConstraint;
    __weak IBOutlet UIView *bottomEditView;
    
    
    ///选中的按钮
    __weak UIButton *selectedMsgEditButton;
    ///键盘收起时是否执行动画
    BOOL hideKeyboardShouldAnimate;
    ///输入框是否正在编辑
    BOOL msgTextViewEditing;
    ///数据源
    NSMutableArray <BmobIMMessage*> *msgsSource;
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
    [self initViewAndData];
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
- (void)initViewAndData
{
    hideKeyboardShouldAnimate = YES;
    
    bottomViewBottomConstraint.constant = BottomViewBottomNormal;
    
    msgTextView.delegate = self;
    
    msgsSource = [NSMutableArray array];
    
    //获取历史记录
    [self addMoreHistoryMsgs];
}

//键盘高度变化时
- (void)bottomViewFrameChange:(NSNotification *)noti
{
    NSValue *sizeValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [sizeValue CGRectValue].size.height;
    [self bottomViewAnimation:height+BottomViewBottomNormal block:nil];
}

//键盘收起时
- (void)bottomViewHide
{
    if (hideKeyboardShouldAnimate) {
        [self bottomViewAnimation:BottomViewBottomNormal block:nil];
    }
}

#pragma mark - 辅助方法
//插入cell
- (void)insertRowsAtIndex:(NSInteger)index
{
    if (index>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [msgTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [msgTableView reloadData];
    }
}

//滚动到指定行
- (void)scrollToRow:(NSInteger)row
{
    NSInteger index = MAX(MIN(row, msgsSource.count-1), 0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [msgTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//BottomView高度变化动画
- (void)bottomViewAnimation:(CGFloat)constant block:(void(^)())block
{
    bottomViewBottomConstraint.constant = constant;
    [UIView animateWithDuration:0.3 animations:^{
        [bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
        if (block) block();
    }];
}

//添加更多消息
- (void)addMoreHistoryMsgs
{
    NSArray *msgs = [self.conversation queryMessagesWithMessage:[msgsSource firstObject] limit:20];
    NSMutableArray *messages = [NSMutableArray arrayWithArray:msgs];
    [messages addObjectsFromArray:msgsSource];
    msgsSource = messages;
    [msgTableView reloadData];
    [self scrollToRow:msgs.count];
}


#pragma mark - 接收到新消息
- (void)receiveNewMsg:(NSNotification *)noti
{
    BmobIMMessage *message = noti.object;
    if (message.extra[KEY_IS_TRANSIENT] && [message.extra[KEY_IS_TRANSIENT] boolValue]) {
        return;
    }
    //添加
    if ([message.fromId isEqualToString:self.conversation.conversationId]) {
        [msgsSource addObject:message];
        [self insertRowsAtIndex:msgsSource.count-1];
        [self scrollToRow:msgsSource.count-1];
    }
}



#pragma mark - 各种消息编辑
- (IBAction)didSelectEditMsgButton:(UIButton *)sender {
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
        //移除所有子视图
        void (^removeSubViews)()  = ^{
            for (UIView *sub in bottomEditView.subviews) {
                [sub removeFromSuperview];
            }
        };
        
        if (sender.selected) {
            if (selectedMsgEditButton) selectedMsgEditButton.selected = NO;
            selectedMsgEditButton = sender;
            if (msgTextViewEditing) {
                hideKeyboardShouldAnimate = NO;
                [msgTextView endEditing:YES];
            }
            removeSubViews();
            [self bottomViewAnimation:BottomViewBottomSelected block:nil];
        }else{
            selectedMsgEditButton = nil;
            [self bottomViewAnimation:BottomViewBottomNormal block:removeSubViews];
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
            ChatPhotoView *pView = [ChatPhotoView photoView];
            pView.frame = bottomEditView.bounds;
            pView.delegate = self;
            [bottomEditView addSubview:pView];
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
            exprView.delegate = self;
            [bottomEditView addSubview:exprView];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 消息发送
#pragma mark ①发送文本消息
- (void)sendTextMsg
{
    NSString *text = msgTextView.text;
    if (text && text.length) {
        //创建BmobIMTextMessage对象
        BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:text attributes:nil];
        message.conversationType =  BmobIMConversationTypeSingle;//单聊
        message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        message.updatedTime = message.createdTime;
        
        //会话
        [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message.content);
        }];
    }
}



#pragma mark ②发送图片消息 <ChatPhotoViewDelegate>
- (void)chatPhotoViewDidSendPhotos:(NSArray<UIImage *> *)photos
{
    
}



#pragma mark ③发送表情 <ChatExpressionViewDelegate>
- (void)chatExpressionViewDidClickSendButton
{
    [self sendTextMsg];
    msgTextView.text = nil;
}

- (void)chatExpressionViewDidSelectedExpressionIndex:(int)index
{
    [msgTextView insertExpressionIndex:index];
}

- (void)chatExpressionViewDidClickDeleteButton
{
    [msgTextView deleteAExpression];
}


#pragma mark - <UITableViewDataSource, UITabBarDelegate>协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgsSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatTextCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:ChatTextCellId];
    }
    BmobIMMessage *msgModel = [msgsSource objectAtIndex:indexPath.row];
    cell.textLabel.text = msgModel.fromId;
    cell.detailTextLabel.text = msgModel.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .5;
}



#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击return键发送文本信息
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMsg];
        textView.text = nil;
        return NO;
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



//表情
NSAttributedString *ChatExpression(unichar exprChar, CGFloat size) {
    //表情icon名
    static NSString *ChatExprImgName = @"ChatExpressions.bundle/chat_expr_";
    int index = exprChar - ChatExprMinUnicode + 1;
    NSString *exprName = [NSString stringWithFormat:@"%@%04d", ChatExprImgName, index];
    //表情富文本
    NSTextAttachment *exprAtta = [NSTextAttachment new];
    exprAtta.bounds = CGRectMake(0, -3, size, size);
    exprAtta.image = [UIImage imageNamed:exprName];
    return [NSAttributedString attributedStringWithAttachment:exprAtta];
}