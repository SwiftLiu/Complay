//
//  SettingViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/18.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "SettingViewController.h"
#import "UserModel.h"
#import "NetTool.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray<NSArray<NSString*>*> *titles;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    titles = @[@[@"关于来撸", @"我要吐槽"]];
}

#pragma mark - 退出登录
- (void)logout
{
    [NetTool logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //发送通知(退出登录)
    NSNotification *noti = [NSNotification notificationWithName:UserDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark - <UITableViewDataSource, UITabBarDelegate>协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[titles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [[titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == titles.count-1 && [UserModel shareModel].isLogin) {
        UIButton *logoutBtn = [UIButton new];
        logoutBtn.frame = CGRectMake(20, 15, tableView.bounds.size.width-40, 40);
        logoutBtn.clipsToBounds = YES;
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.backgroundColor = [UIColor redColor];
        logoutBtn.alpha = 0.9;
        [logoutBtn setTintColor:[UIColor whiteColor]];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *title = [NSString stringWithFormat:@"退出登录(%@)", [UserModel shareModel].nickname];
        [logoutBtn setTitle:title forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        UIView *logoutView = [UIView new];
        [logoutView addSubview:logoutBtn];
        return logoutView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == titles.count-1) {
        return 60;
    }
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


@end
