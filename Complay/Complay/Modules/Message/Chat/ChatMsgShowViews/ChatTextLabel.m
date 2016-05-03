//
//  ChatShowTextView.m
//  Complay
//
//  Created by FineexMac on 16/5/3.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatTextLabel.h"
#import "ChatInputTextView.h"
#import "ChatViewController.h"

@interface ChatTextLabel ()
{
    //表情边长
//    CGFloat fontSize;
    //能够识别自定义表情Unicode的字符串
    NSString *exprText;
}
@end

@implementation ChatTextLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}


- (void)setText:(NSString *)text
{
    text = text?:@"";
    exprText = text;
    //表情
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    for (int i=0; i<attrStr.length; i++) {
        unichar cha = [text characterAtIndex:i];
        if (cha >= ChatExprMinUnicode && cha < 0xEEEE) {
            NSAttributedString *exprStr = ChatExpression(cha, self.font.pointSize+1);
            [attrStr replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:exprStr];
        }
    }
    self.attributedText = attrStr;
}

- (NSString *)text
{
    return exprText;
}


- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    UIFont *font = self.font;
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineBreakMode = NSLineBreakByCharWrapping;
    para.alignment = NSTextAlignmentNatural;
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName : para};
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttributes:attrs range:range];
    [super setAttributedText:attrStr];
}

@end
