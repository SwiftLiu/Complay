//
//  ChatExpressionView.m
//  Complay
//
//  Created by FineexMac on 16/4/27.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatExpressionView.h"

static NSString *exprCellID = @"collectionExpressionCellId";
static NSString *deleCellID = @"collectionDeleteCellId";

@interface ChatExpressionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *exprDataArray;
}
@end

@implementation ChatExpressionView

+ (ChatExpressionView *)expressionView
{
    NSString *nibName = NSStringFromClass([self class]);
    ChatExpressionView *exprView = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    return exprView;
}

- (void)awakeFromNib
{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    [self registerClass:[ChatExpressionCell class] forCellWithReuseIdentifier:exprCellID];
    [self registerClass:[ChatDeleteCell class] forCellWithReuseIdentifier:deleCellID];
    
    exprDataArray = @[@"😄", @"😊", @"😃", @"☺️", @"😉", @"😍", @"😘",
                      @"😳", @"😁", @"😜", @"😝", @"😋", @"😏", @"😔",
                      @"😖", @"😥", @"😰", @"😂", @"😭", @"😱", @"😫",
                      @"😷", @"😪", @"😡", @"😠", @"😲", @"😇"];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return exprDataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //表情
    if (indexPath.row < exprDataArray.count) {
        ChatExpressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:exprCellID forIndexPath:indexPath];
        cell.emojLabel.text = [exprDataArray objectAtIndex:indexPath.row];
        return cell;
    }
    //删除
    else{
        ChatDeleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deleCellID forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange range = [self.textView selectedRange];
    NSMutableString *text = [NSMutableString stringWithString:self.textView.text];
    //添加表情
    if (indexPath.row < exprDataArray.count) {
        NSString *code = [exprDataArray objectAtIndex:indexPath.row];
        [text replaceCharactersInRange:range withString:code];
    }
    //删除
    else if (text.length) {
        NSRange delRange = NSMakeRange(MAX(range.location-1, 0), range.length+1);
        [text replaceCharactersInRange:delRange withString:@""];
    }
    self.textView.text = text;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width-50)/7.0l, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}



@end




@implementation ChatExpressionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.emojLabel = [UILabel new];
        self.emojLabel.textAlignment = NSTextAlignmentCenter;
        self.emojLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:self.emojLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.emojLabel.frame = self.bounds;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.emojLabel.frame = self.bounds;
}

@end


@interface ChatDeleteCell ()
{
    UIImageView *imgView;
}
@end

@implementation ChatDeleteCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = [UIImage imageNamed:@""];
        [self addSubview:imgView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    imgView.frame = self.bounds;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    imgView.frame = self.bounds;
}

@end
