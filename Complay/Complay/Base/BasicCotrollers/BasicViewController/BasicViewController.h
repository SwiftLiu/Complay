//
//  BasicViewController.h
//  Complay
//
//  Created by FineexMac on 16/4/11.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController

///子视图首次布局
- (void)viewDidLayoutSubviewsWhenFirst;

///开始加载动画
- (void)loadBegin:(void (^)())block;
///加载成功
- (void)loadSucceed;
///加载成功，但无数据
- (void)loadNoData;
///加载失败
- (void)loadFailed;

@end
