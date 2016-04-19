//
//  NewTasksViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/19.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "NewTasksViewController.h"

@interface NewTasksViewController ()

@end

@implementation NewTasksViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的任务";
    
}

@end
