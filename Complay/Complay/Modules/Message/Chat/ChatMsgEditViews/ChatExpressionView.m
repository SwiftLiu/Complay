//
//  ChatExpressionView.m
//  Complay
//
//  Created by FineexMac on 16/4/27.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatExpressionView.h"
#import "ChatInputTextView.h"

const NSUInteger expressionCount = 20;

static NSString *exprCellID = @"collectionExpressionCellId";
static NSString *deleCellID = @"collectionDeleteCellId";

@interface ChatExpressionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *exprCollectionView;
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
    exprCollectionView.delegate = self;
    exprCollectionView.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    [exprCollectionView registerClass:[ChatExpressionCell class] forCellWithReuseIdentifier:exprCellID];
    [exprCollectionView registerClass:[ChatDeleteCell class] forCellWithReuseIdentifier:deleCellID];
}

//发送
- (IBAction)sendButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSendButton)]) {
        [self.delegate didClickSendButton];
    }
}


#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return expressionCount+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //表情cell
    if (indexPath.row < expressionCount) {
        ChatExpressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:exprCellID forIndexPath:indexPath];
        cell.emojLabel.attributedText = ExpressionAt((int)indexPath.row, cell.emojLabel.font.pointSize);
        return cell;
    }
    //删除cell
    else{
        ChatDeleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deleCellID forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //添加表情
    if (indexPath.row < expressionCount) {
        if ([self.delegate respondsToSelector:@selector(didSelectedExpressionIndex:)]) {
            [self.delegate didSelectedExpressionIndex:(int)indexPath.row];
        }
    }
    //删除
    else if ([self.delegate respondsToSelector:@selector(didClickDeleteButton)]) {
        [self.delegate didClickDeleteButton];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGSize size = collectionView.bounds.size;
    return CGSizeMake((size.width-50)/7.0l, (size.height-30)/3.0l);
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
        imgView.image = [UIImage imageNamed:@"chat_expr_delete"];
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
