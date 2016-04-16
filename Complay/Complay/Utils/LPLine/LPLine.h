//
//  UIView+LPLine.h
//  FineExCRM
//
//  Created by FineexMac on 16/3/25.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewBorder) {
    ///上边框
    ViewBorderTop,
    ///下边框
    ViewBorderBottom,
    ///左边框
    ViewBorderLeft,
    ///右边框
    ViewBorderRight,
};

@interface UIView (LPLine)

#pragma mark - 添加边框
/// 添加边框（默认颜色，0.5）
- (void)addBordersTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left right:(BOOL)right;

/// 添加边框
- (void)addBordersWithColor:(UIColor *)color weight:(CGFloat)weight top:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left right:(BOOL)right;


#pragma mark - 添加单条直线
/// 添加横线（默认颜色，0.5）
- (void)addLineWithOffsetY:(CGFloat)y;

/// 添加竖线（默认颜色，0.5）
- (void)addLineWithOffsetX:(CGFloat)x;

/*
 * color   颜色
 * weight  直线厚度
 * cross   直线方向，YES:横向，NO:纵向
 * offSet  偏移坐标，横线的Y坐标，纵线的X坐标
 * lead    缩进坐标，横线的X坐标，纵线的Y坐标
 * cover   添加模式，YES:覆盖旧直线，NO:添加新直线
 */
/// 绘制自定义直线
- (void)addLineWithColor:(UIColor *)color cross:(BOOL)cross weight:(CGFloat)weight offset:(CGFloat)offset lead:(CGFloat)lead cover:(BOOL)cover;



#pragma mark - 绘制纵向分布横线
/// 纵向分布横线（默认颜色，0.5）
- (void)addLinesDistributeCount:(NSInteger)count lead:(CGFloat)lead;

/*
 * count   横线数量
 * color   颜色
 * lead    缩进坐标，横线的X坐标
 * cover   添加模式，YES:覆盖旧直线，NO:添加新直线
 */
/// 纵向分布横线（0.5）
- (void)addLinesDistributeCount:(NSInteger)count color:(UIColor *)color lead:(CGFloat)lead cover:(BOOL)cover;

@end
