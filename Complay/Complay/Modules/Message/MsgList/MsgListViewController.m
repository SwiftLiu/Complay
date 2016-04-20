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

@interface MsgListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *msgListTable;
    
    ///会话表中的所有聊天对象的objectId
    NSArray *converUsersIds;
}
@end

@implementation MsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg:) name:kNewMsgNotifacation object:nil];
}

- (void)receiveNewMsg:(NSNotification *)noti
{
    [self reloadList];
    NSLog(@"消息列表界面接收到新消息：%@", noti.object);
}

- (void)reloadList
{
    NSMutableArray *ids = [NSMutableArray arrayWithArray:[[BmobIM sharedBmobIM] allConversationUsersIds]];
    [ids removeObject:[BmobUser getCurrentUser].objectId];
    converUsersIds = ids;
    [msgListTable reloadData];
}

#pragma mark - <UITableViewDataSource, UITabBarDelegate>协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return converUsersIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"msgListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [converUsersIds objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *cVC = [ChatViewController new];
    cVC.chatUserId = [converUsersIds objectAtIndex:indexPath.row];
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
