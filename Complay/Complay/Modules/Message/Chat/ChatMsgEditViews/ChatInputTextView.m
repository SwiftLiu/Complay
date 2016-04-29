//
//  ChatMsgTextView.m
//  Test4
//
//  Created by FineexMac on 16/4/28.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatInputTextView.h"

#define ChatExprMinUnicode 0xEEA0
static NSString *ChatExprImgName = @"ChatExpressions.bundle/chat_expr_";

@interface ChatInputTextView ()<UITextViewDelegate>
{
    //代理
    id <UITextViewDelegate> msgDelegate;
    //表情边长
    CGFloat fontSize;
    //能够识别自定义表情Unicode的字符串
    NSString *exprText;
}
@end

@implementation ChatInputTextView

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
    __weak ChatInputTextView *weakSelf = self;
    [super setDelegate:weakSelf];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    fontSize = font.pointSize;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineBreakMode = NSLineBreakByCharWrapping;
    para.alignment = NSTextAlignmentNatural;
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName : para};
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttributes:attrs range:range];
    [super setAttributedText:attrStr];
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
            NSAttributedString *exprStr = ExpressionAt(cha-ChatExprMinUnicode, fontSize+1);
            [attrStr replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:exprStr];
        }
    }
    self.attributedText = attrStr;
    
    //调用协议方法
    if (msgDelegate) [msgDelegate textViewDidChange:self];
}

- (NSString *)text
{
    return exprText;
}


//初始化设置
- (void)initData
{
    __weak ChatInputTextView *weakSelf = self;
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
    self.attributedText = attrStr;
    
    //修改选中range
    self.selectedRange = NSMakeRange(range.location+1, 0);
    
    //调用协议方法
    if (msgDelegate) [msgDelegate textViewDidChange:self];
}

#pragma mark - 删除表情
- (void)deleteAExpression
{
    NSRange selectRange = [self selectedRange];
    if (selectRange.location) {
        NSRange range;
        if (selectRange.length) range = selectRange;
        else range = NSMakeRange(selectRange.location-1, 1);
        //修改属性string
        [self updateStringRange:range replacementText:@""];
        
        //修改输入框显示的富文本
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSAttributedString *attrReplace = [[NSAttributedString alloc] initWithString:@""];
        [attrStr replaceCharactersInRange:range withAttributedString:attrReplace];
        self.attributedText = attrStr;
        
        //修改选中range
        self.selectedRange = NSMakeRange(range.location, 0);
        
        //调用协议方法
        if (msgDelegate) [msgDelegate textViewDidChange:self];
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
    NSString *exprName = [NSString stringWithFormat:@"%@%04d", ChatExprImgName, index+1];
    //表情富文本
    NSTextAttachment *exprAtta = [NSTextAttachment new];
    exprAtta.bounds = CGRectMake(0, -3, size, size);
    exprAtta.image = [UIImage imageNamed:exprName];
    return [NSAttributedString attributedStringWithAttachment:exprAtta];
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
