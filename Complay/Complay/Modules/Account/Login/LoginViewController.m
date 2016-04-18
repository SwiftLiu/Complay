//
//  LoginViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "NetTool.h"
#import "CacheTool.h"

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
    [userTextField resignFirstResponder];
    [psdTextField resignFirstResponder];
    
    NSString *account = userTextField.text;
    NSString *psd = psdTextField.text;
    [NetTool loginWithAccount:account psd:psd succeed:^(BmobObject *object) {
        //记住账号密码
        [CacheTool rememberAccount:account psd:psd];
        //登录成功后回调
        if (_loginBlock) _loginBlock();
        //返回上一页面
        [self dismissViewControllerAnimated:YES completion:nil];
    } failed:^{
        
    }];
}

#pragma mark - 注册
- (IBAction)registButtonPressed:(UIButton *)sender {
    
}

#pragma mark - 找回密码
- (IBAction)findPsdButtonPressed:(UIButton *)sender {
    
}

#pragma mark
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [userTextField resignFirstResponder];
    [psdTextField resignFirstResponder];
}

@end