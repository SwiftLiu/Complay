//
//  ChatMsgTextView.h
//  Test4
//
//  Created by FineexMac on 16/4/28.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ChatInputTextView : UITextView

///插入表情
- (void)insertExpressionIndex:(int)index;
///删除
- (void)deleteAExpression;

///获取表情
NSAttributedString *ExpressionAt(int index, CGFloat size);

@end
