//
//  OldTasksViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/19.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "OldTasksViewController.h"

@interface OldTasksViewController ()

@end

@implementation OldTasksViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务历史";
    
}

@end
