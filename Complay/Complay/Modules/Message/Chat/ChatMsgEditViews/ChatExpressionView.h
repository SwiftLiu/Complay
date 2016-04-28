//
//  ChatExpressionView.h
//  Complay
//
//  Created by FineexMac on 16/4/27.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMsgTextView.h"

@protocol ChatExpressionViewDelegate <NSObject>

@optional
- (void)didSelectedExpressionIndex:(int)index;
- (void)willDeleteAExpression;

@end

@interface ChatExpressionView : UIView

///关联的输入框
@property (weak, nonatomic) id <ChatExpressionViewDelegate> delegate;

///便利初始化
+ (ChatExpressionView *)expressionView;

@end



///表情输入cell
@interface ChatExpressionCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *emojLabel;
@end

///删除按钮cell
@interface ChatDeleteCell : UICollectionViewCell
@end