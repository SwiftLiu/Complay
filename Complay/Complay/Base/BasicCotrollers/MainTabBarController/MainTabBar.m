//
//  MainTabBar.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MainTabBar.h"
#import "TabBarItem.h"
#import "CommonConstants.h"

@interface MainTabBar ()


@end

@implementation MainTabBar

+ (MainTabBar *)tabBar
{
    MainTabBar *bar = [MainTabBar new];
    bar.backgroundColor = MainAppColor;
    bar.layer.shadowColor = [UIColor blackColor].CGColor;
    bar.layer.shadowOffset = CGSizeMake(0, 1);
    bar.layer.shadowOpacity = 2;
    bar.layer.shadowRadius = 1;
    
    NSArray *titles = @[@"首页", @"任务", @"消息", @"我的"];
    NSArray *imgNames = @[@"tabBar_home", @"tabBar_task", @"tabBar_message", @"tabBar_me"];
    for (int i=0; i<4; i++) {
        TabBarItem *item = [TabBarItem new];
        item.selected = !i;
        [item addTarget:bar action:@selector(itemPressed:) forControlEvents:(UIControlEventTouchUpInside)];
        [item setTitle:titles[i]];
        [item setImage:[UIImage imageNamed:imgNames[i]]];
        [bar addSubview:item];
        [item setHideBadgeBlock:^(int value) {
            if (bar.hideBadgeBlock) bar.hideBadgeBlock(value, i);
        }];
    }
    
    UIButton *addButton = [UIButton new];
    addButton.alpha = 0.9;
    [addButton setImage:[UIImage imageNamed:@"tabBar_add"] forState:(UIControlStateNormal)];
    [addButton setImage:[UIImage imageNamed:@"tabBar_add_rotate"] forState:(UIControlStateSelected)];
    [addButton addTarget:bar action:@selector(addButtonPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    [bar addSubview:addButton];
    return bar;
}

- (void)setBadgeNum:(int)badgeNum atIndex:(NSInteger)index
{
    TabBarItem *item = [self.subviews objectAtIndex:index];
    [item setBadgeNum:badgeNum];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat wide = size.width * 4/21.0l;
    CGFloat width = size.width * 5/21.0l;
    UIView *item0 = [self.subviews objectAtIndex:0];
    item0.frame = CGRectMake(0, 0, wide, size.height);
    UIView *item1 = [self.subviews objectAtIndex:1];
    item1.frame = CGRectMake(wide, 0, wide, size.height);
    UIView *item2 = [self.subviews objectAtIndex:2];
    item2.frame = CGRectMake(size.width-wide*2, 0, wide, size.height);
    UIView *item3 = [self.subviews objectAtIndex:3];
    item3.frame = CGRectMake(size.width-wide, 0, wide, size.height);
    UIView *addBtn = [self.subviews objectAtIndex:4];
    addBtn.frame = CGRectMake(wide*2, 0, width, size.height);
}


//点击item
- (void)itemPressed:(UIButton *)sender
{
    UIButton *button = [self.subviews objectAtIndex:4];
    if (button.selected) return;
    
    for (int i=0; i<4; i++) {
        UIButton *button = [self.subviews objectAtIndex:i];
        button.selected = NO;
    }
    sender.selected = YES;
    
    NSInteger index = [self.subviews indexOfObject:sender];
    [self.delegate didSelectedIndex:index];
}

//点击添加按钮
- (void)addButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.delegate pressedAddButton:sender];
}

@end
