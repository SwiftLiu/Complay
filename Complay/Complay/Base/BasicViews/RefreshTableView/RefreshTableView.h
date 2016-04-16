//
//  RefreshTableView.h
//  Complay
//
//  Created by liuping on 16/4/12.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshTableView : UITableView

///开始刷新
- (void)beginRefreshing;
///结束刷新
- (void)endRefreshing;

@end
