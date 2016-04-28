//
//  ChatMsgTextView.m
//  Test4
//
//  Created by FineexMac on 16/4/28.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatMsgTextView.h"

#define ChatExprMinUnicode 0xEEA0

@interface ChatMsgTextView ()<UITextViewDelegate>
{
    //代理
    id <UITextViewDelegate> msgDelegate;
    //表情边长
    CGFloat fontSize;
    //能够识别自定义表情Unicode的字符串
    NSString *exprText;
}
@end

@implementation ChatMsgTextView

#pragma mark - 重写
- (void)awakeFromNib
{
    [self initData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        fontSize = 15;
        [self initData];
    }
    return self;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    if (delegate != self) {
        msgDelegate = delegate;
    }
    __weak ChatMsgTextView *weakSelf = self;
    [super setDelegate:weakSelf];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    fontSize = font.pointSize;
}

- (void)setText:(NSString *)text
{
    text = text?:@"";
    exprText = text;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    for (int i=0; i<attrStr.length; i++) {
        unichar cha = [text characterAtIndex:i];
        if (cha >= ChatExprMinUnicode && cha < 0xEEEE) {
            NSAttributedString *exprStr = ExpressionAt(cha-ChatExprMinUnicode, fontSize+1);
            [attrStr replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:exprStr];
        }
    }
    [self setFontForAttributedString:attrStr];
    self.attributedText = attrStr;
}

- (NSString *)text
{
    return exprText;
}


//初始化设置
- (void)initData
{
    __weak ChatMsgTextView *weakSelf = self;
    self.delegate = weakSelf;
    
    exprText = self.text?:@"";
}


#pragma mark - 插入表情
- (void)insertExpressionIndex:(int)index
{
    NSRange range = [self selectedRange];
                         
    //修改属性string
    unichar exprChar = ChatExprMinUnicode + index;
    NSString *exprStr = [NSString stringWithCharacters:&exprChar length:1];
    [self updateStringRange:range replacementText:exprStr];
    
    //修改输入框显示的富文本
    NSAttributedString *exprAttrStr = ExpressionAt(index, fontSize+1);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (range.location >= attrStr.length) {
        [attrStr appendAttributedString:exprAttrStr];
    }else {
        [attrStr replaceCharactersInRange:range withAttributedString:exprAttrStr];
    }
    [self setFontForAttributedString:attrStr];
    self.attributedText = attrStr;
}

#pragma mark - 删除表情
- (void)deleteAExpression
{
    NSRange selectRange = [self selectedRange];
    if (selectRange.location) {
        NSRange range = NSMakeRange(selectRange.location-1, 1);
        //修改属性string
        [self updateStringRange:range replacementText:@""];
        
        //修改输入框显示的富文本
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSAttributedString *attrReplace = [[NSAttributedString alloc] initWithString:@""];
        [attrStr replaceCharactersInRange:range withAttributedString:attrReplace];
        [self setFontForAttributedString:attrStr];
        self.attributedText = attrStr;
    }
}


#pragma mark - 辅助方法
//修改string
- (void)updateStringRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *string = [NSMutableString stringWithString:exprText];
    if (range.location >= string.length) {
        [string appendString:text];
    }else {
        [string replaceCharactersInRange:range withString:text];
    }
    exprText = string;
}

//表情
NSAttributedString *ExpressionAt(int index, CGFloat size) {
    //表情icon名
    NSString *exprName = [NSString stringWithFormat:@"chat_expr_%04d", index];
    //表情富文本
    NSTextAttachment *exprAtta = [NSTextAttachment new];
    exprAtta.bounds = CGRectMake(0, -3, size, size);
    exprAtta.image = [UIImage imageNamed:exprName];
    return [NSAttributedString attributedStringWithAttachment:exprAtta];
}

//修改富文本字体
- (void)setFontForAttributedString:(NSMutableAttributedString *)attrStr
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
}


#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView
{
    if (msgDelegate) [msgDelegate textViewDidChange:textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (msgDelegate) [msgDelegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (msgDelegate) [msgDelegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (msgDelegate) [msgDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    
    //修改string
    [self updateStringRange:range replacementText:text];
    
    return YES;
}

@end
