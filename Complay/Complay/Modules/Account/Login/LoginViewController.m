//
//  LoginViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonHeaders.h"

@interface LoginViewController ()
{
    __weak IBOutlet UITextField *userTextField;
    __weak IBOutlet UITextField *psdTextField;
}

@property (strong, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取记住的账号密码
    NSArray *accountInfo = [CacheTool getAccountAndPsd];
    userTextField.text = accountInfo.firstObject;
    psdTextField.text = accountInfo.lastObject;
}

#pragma mark - 登录
- (IBAction)loginButtonPressed:(UIButton *)sender {
    //收起键盘
    [userTextField resignFirstResponder];
    [psdTextField resignFirstResponder];
    
    
    //验证
    NSString *account = userTextField.text;
    if (!account || !account.length) {
        [AlertView showWithTitle:@"请输入账号!" message:nil buttonTitle:TITLE_CONFIRM block:^{
            [userTextField becomeFirstResponder];
        }];
        return;
    }
    NSString *psd = psdTextField.text;
    if (!psd || !psd.length) {
        [AlertView showWithTitle:@"请输入密码!" message:nil buttonTitle:TITLE_CONFIRM block:^{
            [psdTextField becomeFirstResponder];
        }];
        return;
    }
    
    //开始登录
    [LPCustomHUD startLoading];
    [NetTool loginWithAccount:account psd:psd succeed:^(BmobObject *object) {
        [LPCustomHUD endLoading];
        //记住账号密码
        [CacheTool rememberAccount:account psd:psd];
        //登录成功后回调
        if (_loginBlock) _loginBlock();
        //返回上一页面
        [self dismissViewControllerAnimated:YES completion:nil];
    } failed:^(NSString *msg) {
        [LPCustomHUD endLoading];
        [AlertView showWithTitle:@"警告" message:msg buttonTitle:TITLE_CONFIRM block:^{
            [userTextField becomeFirstResponder];
        }];
    }];
}

#pragma mark - 注册
- (IBAction)registButtonPressed:(UIButton *)sender {
    
}

#pragma mark - 找回密码
- (IBAction)findPsdButtonPressed:(UIButton *)sender {
    
}

#pragma mark - 退出登录
- (IBAction)cancelLoginButtonPressed:(UIButton *)sender {
    [userTextField resignFirstResponder];
    [psdTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [userTextField resignFirstResponder];
    [psdTextField resignFirstResponder];
}

@end