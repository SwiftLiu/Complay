//
//  LoadView.h
//  Complay
//
//  Created by FineexMac on 16/4/12.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadViewDelegate <NSObject>

@optional
- (void)loadViewDidReloading;

@end

@interface LoadView : UIView

///代理
@property (weak, nonatomic) id <LoadViewDelegate> delegate;

///便利初始化
+ (LoadView *)loadView;

///加载中
- (void)startLoading;
///加载成功
- (void)endLoadSucceed;
///加载成功，但无数据
- (void)endLoadNoData;
///加载失败
- (void)endLoadFailed;


@end
