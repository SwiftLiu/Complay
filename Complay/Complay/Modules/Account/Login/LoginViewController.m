//
//  LoginViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkTool.h"
#import "UserModel.h"

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
    
}

- (void)loginCompleteTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

#pragma mark - 登录
- (IBAction)loginButtonPressed:(UIButton *)sender {
    [UserModel shareModel].isLogin = YES;
    if (_loginBlock) _loginBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
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