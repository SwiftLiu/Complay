//
//  ChatExpressionView.h
//  Complay
//
//  Created by FineexMac on 16/4/27.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatExpressionView : UICollectionView

///关联的输入框
@property (weak, nonatomic) UITextView *textView;

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