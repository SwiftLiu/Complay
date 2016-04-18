//
//  MsgViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadBegin:^{
        [self getInfo];
    }];
}


#pragma mark - 获取数据
- (void)getInfo
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int t = arc4random()%3;
        if (t==0) {
            [self loadFailed];
        }else if (t==1) {
            [self loadNoData];
        }else{
            [self loadSucceed];
        }
    });
}

@end
