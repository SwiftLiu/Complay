//
//  BasicViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "BasicViewController.h"
#import "LoadView.h"

@interface BasicViewController ()<LoadViewDelegate>
{
    BOOL isDid;
    
    LoadView *loadView;
    void (^loadBlock)();
}
@end

@implementation BasicViewController

#pragma mark - 重写
- (void)viewDidAppear:(BOOL)animated
{
    loadView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    if (!isDid) {
        isDid = YES;
        [self viewDidLayoutSubviewsWhenFirst];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}


#pragma mark - 导航栏
- (void)initNav
{
    //返回按钮
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index) {
        UIImage *img = [UIImage imageNamed:@"navigation_back"];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 子视图首次布局
- (void)viewDidLayoutSubviewsWhenFirst { }



#pragma mark - 加载
///开始加载动画
- (void)loadBegin:(void (^)())block
{
    if (!loadView) {
        loadView = [LoadView loadView];
        loadView.delegate = self;
        [self.view addSubview:loadView];
        loadBlock = block;
    }
    [loadView startLoading];
    if (loadBlock) loadBlock();
}

///加载成功
- (void)loadSucceed
{
    [UIView animateWithDuration:0.3 animations:^{
        loadView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadView endLoadSucceed];
        [loadView removeFromSuperview];
        loadView = nil;
        loadBlock = nil;
    }];
}

///加载成功，但无数据
- (void)loadNoData
{
    [loadView endLoadNoData];
}

///加载失败
- (void)loadFailed
{
    [loadView endLoadFailed];
}

///<LoadViewDelegate>中重写加载
- (void)loadViewDidReloading
{
    [self loadBegin:nil];
}

@end
