//
//  MsgListViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ConvListViewController.h"
#import "ConversationCell.h"
#import "ChatViewController.h"
#import "MainTabBarController.h"
#import "CommonConstants.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import "MsgTool.h"
#import "NetTool.h"

static NSString *convCellIdentifier = @"convCell";

@interface ConvListViewController ()<UITableViewDataSource, UITableViewDelegate, ConversationCellDelegate>
{
    __weak IBOutlet UIView *isnotLoginView;
    __weak IBOutlet UITableView *convListTable;
    
    ///会话表中的所有聊天对象的objectId
    NSMutableArray *convDataArray;
}
@end

@implementation ConvListViewController

#pragma mark 测试临时代码*****************************
//- (void)viewDidAppear:(BOOL)animated
//{
//    BmobIMConversation *conv = [BmobIMConversation new];
//    conv.conversationId = @"2EW0444X";
//    conv.conversationType = BmobIMConversationTypeSingle;
//    //创建BmobIMTextMessage对象
//    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:@"测试啦" attributes:nil];
//    message.conversationType =  BmobIMConversationTypeSingle;//单聊
//    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
//    message.updatedTime = message.createdTime;
//    
//    //会话
//    [conv sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
//        NSLog(@"发送%@：%@", isSuccessful?@"成功":@"失败", message.content);
//    }];
//}
#pragma mark

#pragma mark - 重写以及加载处理
- (void)viewWillAppear:(BOOL)animated
{
    [self loadConversations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self loginOrLogout];
    [self registNotifications];
}

//界面
- (void)initView
{
    //注册cell
    NSString *nibName = NSStringFromClass([ConversationCell class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [convListTable registerNib:nib forCellReuseIdentifier:convCellIdentifier];
}

//设置是否登录提示
- (void)loginOrLogout
{
    if ([BmobUser getCurrentUser]) {
        isnotLoginView.hidden = YES;
        [self loadConversations];
    }else{
        isnotLoginView.hidden = NO;
        convDataArray = [NSMutableArray array];
        [convListTable reloadData];
    }
}

///注册通知
- (void)registNotifications
{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(loginOrLogout) name:kLoginOrLogoutNotification object:nil];
    [noti addObserver:self selector:@selector(loadConversations) name:kNewMsgNotifacation object:nil];
    [noti addObserver:self selector:@selector(loadConversations) name:kNewChaterNotifacation object:nil];
    [noti addObserver:self selector:@selector(loadConversations) name:kClearAllNewMsgNotifacation object:nil];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [BmobUser dealBlock:^{
        [self loginOrLogout];
    }];
}

#pragma mark - 加载本地会话列表
- (void)loadConversations
{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if (array && array.count > 0) {
        convDataArray = [NSMutableArray arrayWithArray:array];
        [convListTable reloadData];
    }
}

#pragma mark - <ConversationCellDelegate>协议
//点击头像
- (void)didClickAvatarAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//清除某行新消息数
- (void)didClearNewMsgNumberBadgeAtIndexPath:(NSIndexPath *)indexPath
{
    BmobIMConversation *conv = [convDataArray objectAtIndex:indexPath.row];
    [conv updateLocalCache];
    //刷新未读消息总数
    [MainTabBarController updateNewMsgTotal];
}

#pragma mark - <UITableViewDataSource, UITabBarDelegate>协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return convDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:convCellIdentifier];
    cell.delegate = self;
    BmobIMConversation *conv = [convDataArray objectAtIndex:indexPath.row];
    [cell setAvatarUrl:conv.conversationIcon];
    [cell setTitle:conv.conversationTitle];
    [cell setDetail:conv.conversationDetail];
    [cell setDateInterval:conv.updatedTime];
    [cell setNewMsgNum:conv.unreadCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *cVC = [ChatViewController new];
    cVC.conversation = [convDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cVC animated:YES];
    //清空该对话未读消息数
    BmobIMConversation *conv = [convDataArray objectAtIndex:indexPath.row];
    [conv updateLocalCache];
    //刷新未读消息总数
    [MainTabBarController updateNewMsgTotal];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BmobIMConversation *conv = [convDataArray objectAtIndex:indexPath.row];
    [conv deleteMessageWithdeleteMessageListOrNot:YES updateTime:conv.updatedTime];
    [convDataArray removeObjectAtIndex:indexPath.row];
    [convListTable reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ConversationCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .5;
}


@end
