//
//  UIView+LPLine.m
//  FineExCRM
//
//  Created by FineexMac on 16/3/25.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import "LPLine.h"
#import <objc/runtime.h>


#define DefaultLineColor [UIColor colorWithWhite:180/255.l alpha:1]

@implementation UIView (LPLine)

#pragma mark - 属性getter和setter方法(rumtime机制)
static char LPBorderLayerKey;
- (void)setBorderLayer:(CALayer *)borderLayer
{
    [self.borderLayer removeFromSuperlayer];
    
    [self willChangeValueForKey:@"borderLayer"];
    objc_setAssociatedObject(self, &LPBorderLayerKey, borderLayer, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"borderLayer"];
    
    self.borderLayer.masksToBounds = YES;
    [self.layer addSublayer:self.borderLayer];
}
- (CALayer *)borderLayer
{
    return objc_getAssociatedObject(self, &LPBorderLayerKey);
}

#pragma mark - 添加边框
/// 添加边框（默认颜色，0.5）
- (void)addBordersTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left right:(BOOL)right
{
    [self addBordersWithColor:nil weight:.5 top:top bottom:bottom left:left right:right];
}

/// 添加边框
- (void)addBordersWithColor:(UIColor *)color weight:(CGFloat)weight top:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left right:(BOOL)right
{
    if (top && bottom && left && right) {
        self.layer.borderWidth = weight;
        self.layer.borderColor = (color?:DefaultLineColor).CGColor;
    }else if (top || bottom || left || right) {
        CGImageRef img = [self drawWithColor:color block:^(CGContextRef ctx, CGSize size) {
            if (top) CGContextFillRect(ctx, CGRectMake(0, 0, size.width, weight));
            if (bottom) CGContextFillRect(ctx, CGRectMake(0, size.height-weight, size.width, weight));
            if (left) CGContextFillRect(ctx, CGRectMake(0, 0, weight, size.height));
            if (right) CGContextFillRect(ctx, CGRectMake(size.width-weight, 0, weight, size.height));
        }];
        //重置图层
        if (!self.borderLayer) self.borderLayer = [CALayer layer];//懒加载
        self.borderLayer.frame = self.layer.bounds;
        self.borderLayer.contents = (__bridge id _Nullable)(img);
    }
}


#pragma mark - 添加单条直线
/// 添加横线（默认颜色，0.5）
- (void)addLineWithOffsetY:(CGFloat)y
{
    [self addLineWithColor:nil cross:YES weight:.5 offset:y lead:0 cover:NO];
}

/// 添加竖线（默认颜色，0.5）
- (void)addLineWithOffsetX:(CGFloat)x
{
    [self addLineWithColor:nil cross:NO weight:.5 offset:x lead:0 cover:NO];
}

// 绘制自定义直线
- (void)addLineWithColor:(UIColor *)color cross:(BOOL)cross weight:(CGFloat)weight offset:(CGFloat)offset lead:(CGFloat)lead cover:(BOOL)cover
{
    //绘制
    CGImageRef img = [self drawWithColor:color block:^(CGContextRef ctx, CGSize size) {
        CGRect frame = Frame(size, cross, MAX(weight, .5), offset, lead);
        CGContextFillRect(ctx, frame);
    }];
    
    //图层
    CALayer *layer = [CALayer layer];
    layer.frame = self.layer.bounds;
    layer.contents = (__bridge id _Nullable)(img);
    [self.layer addSublayer:layer];
}

#pragma mark - 绘制纵向分布横线
/// 添加纵向分布横线（默认颜色，0.5）
- (void)addLinesDistributeCount:(NSInteger)count lead:(CGFloat)lead
{
    [self addLinesDistributeCount:count color:nil lead:lead cover:NO];
}

/// 纵向分布横线（横线，0.5）
- (void)addLinesDistributeCount:(NSInteger)count color:(UIColor *)color lead:(CGFloat)lead cover:(BOOL)cover
{
    //绘制
    CGImageRef img = [self drawWithColor:color block:^(CGContextRef ctx, CGSize size) {
        for (int i=0; i<count; i++) {
            CGFloat offsetY = (i+1) * (size.height) / (count+1);
            CGRect frame = Frame(size, YES, 0.5, offsetY, lead);
            CGContextFillRect(ctx, frame);
        }
    }];
    
    //图层
    CALayer *layer = [CALayer layer];
    layer.frame = self.layer.bounds;
    layer.contents = (__bridge id _Nullable)(img);
    [self.layer addSublayer:layer];
}

#pragma mark - 辅助方法
// 绘制
- (CGImageRef)drawWithColor:(UIColor *)color block:(void (^)(CGContextRef ctx, CGSize size))block
{
    //初始化画布
    CGSize size = self.layer.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!color) color = DefaultLineColor;
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    //绘制新的直线
    if (block) block(ctx, size);
    
    //结束绘制,提取img
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(ctx);
    UIGraphicsEndImageContext();
    return newImg.CGImage;
}

//计算直线Frame
CGRect Frame(CGSize size, BOOL cross, CGFloat weight, CGFloat offset, CGFloat lead) {
    CGRect frame;
    frame.origin.x = cross ? lead : offset;
    frame.origin.y = cross ? offset : lead;
    frame.size.width = cross ? (size.width-lead) : weight;
    frame.size.height = cross ? weight : (size.height - lead);
    return frame;
}

@end
