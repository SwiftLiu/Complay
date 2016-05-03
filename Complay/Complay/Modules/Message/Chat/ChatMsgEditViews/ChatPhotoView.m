//
//  ChatPhotoView.m
//  Complay
//
//  Created by FineexMac on 16/5/3.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "ChatPhotoView.h"
#import "CommonConstants.h"


#pragma mark - Chat图片选择器
static NSString *cellID = @"collectionPhotoCellId";

@interface ChatPhotoView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ChatPhotoViewCellDelegate>
{
    __weak IBOutlet UICollectionView *photoCollectionView;
    __weak IBOutlet UIButton *isOriginalPhotoButton;
    __weak IBOutlet UIButton *sendButton;
    
    NSArray *photoAlbumPhotos;
    
    NSMutableArray <NSNumber *> *selectedIndexs;
}

@property (assign, nonatomic) NSUInteger selectedCount;

@end

@implementation ChatPhotoView

- (void)setSelectedCount:(NSUInteger)selectedCount
{
    _selectedCount = selectedCount;
    NSString *title = [NSString stringWithFormat:@"发送(%ld)", selectedCount];
    [sendButton setTitle:title forState:(UIControlStateNormal)];
}

- (void)awakeFromNib
{
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    [photoCollectionView registerClass:[ChatPhotoViewCell class] forCellWithReuseIdentifier:cellID];
    
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    photoAlbumPhotos = @[img, img, img, img, img, img, img, img, img, img, img, img, img];
    
    selectedIndexs = [NSMutableArray array];
}

+ (ChatPhotoView *)photoView
{
    NSString *nibName = NSStringFromClass([self class]);
    ChatPhotoView *pView = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    return pView;
}

- (IBAction)originalPhotoButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatPhotoViewDidSendPhotos:)]) {
        NSMutableArray *selectedPhotos = [NSMutableArray array];
        for (NSNumber *index in selectedIndexs) {
            UIImage *img = [photoAlbumPhotos objectAtIndex:index.longValue];
            if (isOriginalPhotoButton.selected) {
                
            }
            [selectedPhotos addObject:img];
        }
        [self.delegate chatPhotoViewDidSendPhotos:selectedPhotos];
    }
}


#pragma mark - <ChatPhotoViewCellDelegate>
- (void)chatPhotoViewCellDidSelectedIndex:(NSUInteger)index
{
    [selectedIndexs addObject:@(index)];
    self.selectedCount = selectedIndexs.count;
    //滚动
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [photoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
}

- (void)chatPhotoViewCellDidDeselectedIndex:(NSUInteger)index
{
    [selectedIndexs removeObject:@(index)];
    self.selectedCount = selectedIndexs.count;
}


#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoAlbumPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    UIImage *img = [photoAlbumPhotos objectAtIndex:indexPath.row];
    cell.hasSelected = [selectedIndexs containsObject:@(indexPath.row)];
    [cell setImg:img];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIImage *img = [photoAlbumPhotos objectAtIndex:indexPath.row];
    CGFloat scale = img.size.width / img.size.height;
    CGFloat height = collectionView.bounds.size.height;
    return CGSizeMake(height*scale, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end


#pragma mark
#pragma mark - Chat图片选择器Cell
@interface ChatPhotoViewCell ()
{
    UIImageView *imgView;
    UIImageView *selectView;
}
@end

@implementation ChatPhotoViewCell

- (void)setImg:(UIImage *)img
{
    imgView.image = img;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgView = [UIImageView new];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        
        selectView = [UIImageView new];
        CGFloat wide = 20;
        selectView.bounds = CGRectMake(0, 0, wide, wide);
        selectView.layer.cornerRadius = wide/2.0l;
        selectView.clipsToBounds = YES;
        [imgView addSubview:selectView];
        
        self.hasSelected = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)select
{
    self.hasSelected = !self.hasSelected;
    if (self.hasSelected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatPhotoViewCellDidSelectedIndex:)]) {
            [self.delegate chatPhotoViewCellDidSelectedIndex:self.index];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatPhotoViewCellDidDeselectedIndex:)]) {
            [self.delegate chatPhotoViewCellDidDeselectedIndex:self.index];
        }
    }
}

- (void)setHasSelected:(BOOL)hasSelected
{
    _hasSelected = hasSelected;
    if (hasSelected) {
        selectView.image = [UIImage imageNamed:@"image_select"];
    }else{
        selectView.image = [UIImage imageNamed:@"image_deselect"];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetFrame];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resetFrame];
}

- (void)resetFrame
{
    imgView.frame = self.bounds;
    CGFloat w = selectView.bounds.size.width/2.0l;
    selectView.center = CGPointMake(imgView.frame.size.width-w-5, w+5);
}

@end

