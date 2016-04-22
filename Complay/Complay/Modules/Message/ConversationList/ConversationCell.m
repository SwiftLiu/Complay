//
//  ConversationCell.m
//  Complay
//
//  Created by FineexMac on 16/4/22.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ConversationCell.h"
#import "AvatarView.h"
#import "LPBadgeView.h"
#import "CommonConstants.h"
#import "NetTool.h"
#import "CommonFunctions.h"

@interface ConversationCell ()
{
    __weak IBOutlet AvatarView *avatarView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *detailLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet LPBadgeView *badgeView;
    
    NSTimer *timer;
    NSDate *date;
}
@end

@implementation ConversationCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    titleLabel.textColor = DefaultFontColor;
    detailLabel.textColor = DefaultMinorFontColor;
    dateLabel.textColor = DefaultMinorFontColor;
    badgeView.backgroundColor = LPBadgeDefalutTintColor;
    badgeView.value = 0;
    [badgeView setHiddenBlock:^(NSInteger num) {
        [self.delegate didClearNewMsgNumberBadgeAtIndexPath:self.indexPath];
    }];
    [avatarView setClickBlock:^{
        [self.delegate didClickAvatarAtIndexPath:self.indexPath];
    }];
}


- (void)setAvatarUrl:(NSString *)avaUrl
{
    [avatarView getAvatar:avaUrl];
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (void)setDetail:(NSString *)detail
{
    detailLabel.text = detail;
}

- (void)setDateInterval:(uint64_t)secs
{
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    dateLabel.text = [aDate softString:YES];
    date = aDate;
    
    [timer invalidate];
    timer = nil;
    if ([[NSDate date] timeIntervalSinceDate:aDate] < 60) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDate) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)setDate
{
    if ([[NSDate date] timeIntervalSinceDate:date] <= 60) {
        dateLabel.text = [date softString:YES];
    }else{
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)setNewMsgNum:(int)newMsgNum
{
    badgeView.value = newMsgNum;
}

@end
