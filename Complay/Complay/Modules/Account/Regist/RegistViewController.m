//
//  RegistViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/21.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "RegistViewController.h"
#import <BmobSDK/Bmob.h>

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 注册
- (void)regist
{
    BmobUser *user = [[BmobUser alloc] init];
    [user setUsername:@"撸呀撸"];
    [user setPassword:@"123"];
    [user signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"注册成功");
        } else {
            NSLog(@"注册失败：%@",error);
        }
    }];
}
@end
