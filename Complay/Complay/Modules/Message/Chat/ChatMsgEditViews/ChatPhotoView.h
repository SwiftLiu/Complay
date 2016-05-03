//
//  ChatPhotoView.h
//  Complay
//
//  Created by FineexMac on 16/5/3.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Chat图片选择器协议
@protocol ChatPhotoViewDelegate <NSObject>

@optional
///发送图片
- (void)chatPhotoViewDidSendPhotos:(NSArray<UIImage *>*)photos;

@end


#pragma mark - Chat图片选择器
@interface ChatPhotoView : UIView

///控制器类的代理
@property (weak, nonatomic) UIViewController <ChatPhotoViewDelegate> *delegate;


///便利初始化
+ (ChatPhotoView *)photoView;

@end

#pragma mark - Chat图片选择器Cell
@protocol ChatPhotoViewCellDelegate <NSObject>
@optional
///选中
- (void)chatPhotoViewCellDidSelectedIndex:(NSUInteger)index;
///取消选中
- (void)chatPhotoViewCellDidDeselectedIndex:(NSUInteger)index;
@end

@interface ChatPhotoViewCell : UICollectionViewCell
///代理
@property (weak, nonatomic) id <ChatPhotoViewCellDelegate> delegate;
///索引
@property (assign, nonatomic) NSUInteger index;
///是否选中
@property (assign, nonatomic) BOOL hasSelected;
///设置图片
- (void)setImg:(UIImage *)img;
@end
