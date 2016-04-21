//
//  MsgListViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MsgListViewController.h"
#import "ChatViewController.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import "MsgTool.h"
#import "NetTool.h"

@interface MsgListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UIView *isnotLoginView;
    __weak IBOutlet UITableView *convListTable;
    
    ///会话表中的所有聊天对象的objectId
    NSArray *convDataArray;
}
@end

@implementation MsgListViewController

#pragma mark 测试临时代码*****************************
//- (void)viewWillAppear:(BOOL)animated
//{
//    BmobQuery *query = [BmobQuery queryForUser];
//    [query getObjectInBackgroundWithId:@"SmXu3337" block:^(BmobObject *object, NSError *error) {
//        NSLog(@"%@", object);
//    }];
//}

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
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLoginView];
    [self loadConversations];
    [self registNotifications];
}

//设置是否登录提示
- (void)setLoginView
{
    isnotLoginView.hidden = [BmobUser getCurrentUser];
}

///注册通知
- (void)registNotifications
{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(setLoginView) name:kLoginOrLogoutNotification object:nil];
    [noti addObserver:self selector:@selector(loadConversations) name:kNewMsgNotifacation object:nil];
    [noti addObserver:self selector:@selector(loadConversations) name:kNewChaterNotifacation object:nil];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [BmobUser dealBlock:^{
        [self setLoginView];
    }];
}

#pragma mark - 加载本地会话列表
-(void)loadConversations
{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if (array && array.count > 0) {
        convDataArray = array;
        [convListTable reloadData];
    }
}

#pragma mark - <UITableViewDataSource, UITabBarDelegate>协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return convDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"msgListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BmobIMConversation *conv = [convDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = conv.conversationTitle;
    cell.detailTextLabel.text = conv.conversationDetail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *cVC = [ChatViewController new];
    cVC.conversation = [convDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
