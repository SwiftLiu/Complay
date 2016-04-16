//
//  MineViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MineViewController.h"
#import "HeadImgView.h"
#import "UserModel.h"
#import "LoginViewController.h"


@implementation MineLabel

- (void)awakeFromNib
{
    [self shadow];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self shadow];
    }
    return self;
}

- (void)shadow
{
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
}

@end

@interface MineViewController ()<UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UIView *navBar;
    __weak IBOutlet MineLabel *navTitleLabel;
    
    __weak IBOutlet UIView *personView;
    __weak IBOutlet HeadImgView *headImgView;
    __weak IBOutlet UIImageView *bgImgView;
    
    __weak IBOutlet UIButton *loginButton;
    
    __weak IBOutlet UIView *careFansView;
    __weak IBOutlet MineLabel *careCountLabel;
    __weak IBOutlet MineLabel *fansCountLabel;
    
    
    __weak IBOutlet UILabel *newTaskNumLabel;
    __weak IBOutlet UILabel *oldTaskNumLabel;
    
}
@end

@implementation MineViewController

#pragma mark - 重写
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCustomView];
    [self updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    scroll.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+100);
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - 布局
- (void)initCustomView
{
    navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
}

#pragma mark - 刷新个人中心数据
- (void)updateInfo
{
    UserModel *user = [UserModel shareModel];
    if (user.isLogin) {
        loginButton.hidden = YES;
        careFansView.hidden = NO;
    }else{
        loginButton.hidden = NO;
        careFansView.hidden = YES;
    }
    
    careCountLabel.text = [NSString stringWithFormat:@"%lu", user.careCount];
    fansCountLabel.text = [NSString stringWithFormat:@"%lu", user.fansCount];
    
    NSInteger newTaskNum = user.newSendTaskCount + user.newGetTaskCount;
    newTaskNumLabel.text = [NSString stringWithFormat:@"%lu", newTaskNum];
    NSInteger oldTaskNum = user.oldSendTaskCount + user.oldGetTaskCount;
    oldTaskNumLabel.text = [NSString stringWithFormat:@"%lu", oldTaskNum];
    
}

#pragma mark - 获取数据
- (void)getInfoFormServer
{
    
}


#pragma mark - 事件
///我的任务
- (IBAction)newTaskButtonPressed:(UIButton *)sender {
    
}

///任务历史
- (IBAction)oldTaskButtonPressed:(UIButton *)sender {
    
}

///设置
- (IBAction)settingButtonPressed:(UIButton *)sender {
    
}

///登录
- (IBAction)loginButtonPressed:(UIButton *)sender {
    LoginViewController *lVC = [LoginViewController new];
    [lVC setLoginBlock:^{ [self updateInfo]; }];
    lVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:lVC animated:YES completion:nil];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    //导航栏背景色
    if (y > 0) {
        navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:MIN(y/60.0l-0.05, 0.9)];
    }
}


@end
