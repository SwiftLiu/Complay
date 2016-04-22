//
//  ConversationCell.h
//  Complay
//
//  Created by FineexMac on 16/4/22.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ConversationCellHeight 65

@protocol ConversationCellDelegate <NSObject>

@optional
///点击头像
- (void)didClickAvatarAtIndexPath:(NSIndexPath *)indexPath;
///释放badge
- (void)didClearNewMsgNumberBadgeAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ConversationCell : UITableViewCell

///代理
@property (weak, nonatomic) id <ConversationCellDelegate> delegate;
///indexPath
@property (strong, nonatomic) NSIndexPath *indexPath;

///头像
- (void)setAvatarUrl:(NSString *)avaUrl;
///设置主题
- (void)setTitle:(NSString *)title;
///设置详情即最新消息
- (void)setDetail:(NSString *)detail;
///设置日期时间(毫秒)
- (void)setDateInterval:(uint64_t)secs;
///设置未读消息数
- (void)setNewMsgNum:(int)newMsgNum;

@end
