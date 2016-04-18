//
//  LPAlertView.m
//  FineExAPP
//
//  Created by FineexMac on 15/12/21.
//  Copyright © 2015年 FineEX-LF. All rights reserved.
//

#import "LPAlertView.h"

@interface LPAlertView ()

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleMsgMargin;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelMaxHeight;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftRightButtonLineWidth;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonLeftMargin;

@property (strong, nonatomic) void (^leftBlock)();
@property (strong, nonatomic) void (^rightBlock)();

@end

@implementation LPAlertView

#pragma mark -
+ (void)showComfireWithMessage:(NSString *)message
{
    [LPAlertView showComfireWithTitle:@"温馨提示" message:message];
}

+ (void)showComfireWithTitle:(NSString *)title message:(NSString *)message
{
    [LPAlertView showOneButtonWithTitle:title message:message buttonTitle:@"确定"];
}

#pragma mark -
+ (void)showOneButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    [LPAlertView showOneButtonWithTitle:@"温馨提示" message:message buttonTitle:buttonTitle];
}

+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    [LPAlertView showOneButtonWithTitle:title message:message buttonTitle:buttonTitle block:nil];
}

+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(void (^)())block
{
    [LPAlertView showWithTitle:title message:message leftTitle:nil rightTitle:buttonTitle leftBlock:nil rightBlock:block];
}

#pragma mark - 
+ (void)showOkCancelWithTitle:(NSString *)title message:(NSString *)message okBlock:(void (^)())okBlock
{
    [LPAlertView showOkCancelWithTitle:title message:message cancelBlock:nil okBlock:okBlock];
}

+ (void)showOkCancelWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock okBlock:(void (^)())okBlock
{
    [LPAlertView showWithTitle:title message:message leftTitle:@"取消" rightTitle:@"确定" leftBlock:cancelBlock rightBlock:okBlock];
}


#pragma mark - 高度自定义
+ (void)showWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftBlock:(void (^)())leftBlock rightBlock:(void (^)())rightBlock
{
    LPAlertView *alertView = [LPAlertView alertViewWithTitle:title message:message leftTitle:leftTitle rightTitle:rightTitle leftBlock:leftBlock rightBlock:rightBlock cancelButton:NO];
    [alertView show];
}

+ (void)showCancelWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftBlock:(void (^)())leftBlock rightBlock:(void (^)())rightBlock
{
    LPAlertView *alertView = [LPAlertView alertViewWithTitle:title message:message leftTitle:leftTitle rightTitle:rightTitle leftBlock:leftBlock rightBlock:rightBlock cancelButton:YES];
    [alertView show];
}

#pragma mark - 便利初始化
+ (LPAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftBlock:(void (^)())leftBlock rightBlock:(void (^)())rightBlock cancelButton:(BOOL)hasCancel
{
    //背景
    NSString *nibName = NSStringFromClass([LPAlertView class]);
    LPAlertView *alertView = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    alertView.alpha = 0.98;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    alertView.frame = window.bounds;
    [window addSubview:alertView];
    
    //投影图层
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 2;
    layer.cornerRadius = alertView.baseView.layer.cornerRadius;
    layer.frame = alertView.baseView.frame;
    [alertView.layer insertSublayer:layer below:alertView.baseView.layer];
    
    //左上角取消按钮
    if (hasCancel) {
        [alertView.cancelButton setTitle:nil forState:UIControlStateNormal];
        [alertView drawFork:alertView.cancelButton];
    }else{
        [alertView.cancelButton removeFromSuperview];
    }
    
    //分割线
    if (title && title.length && message && message.length) {
        alertView.lineHeight.constant = 0.5;
    }else {
        alertView.lineHeight.constant = 0;
        alertView.titleMsgMargin.constant = 0;
    }
    
    //主题
    if (title && title.length > 12) {
        alertView.titleLabel.text = [title substringToIndex:12];
    }else{
        alertView.titleLabel.text = title;
    }
    
    //详情
    if (message && message.length) {
        if (message.length > 40) {
            alertView.msgLabel.text = [message substringToIndex:40];
        }else{
            alertView.msgLabel.text = message;
        }
    }else{
        alertView.msgLabel.hidden = YES;
        alertView.msgLabelMaxHeight.constant = 0;
    }
    
    //两个按钮
    if (leftTitle && leftTitle.length && rightTitle && rightTitle.length) {
        [alertView.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [alertView.rightButton setTitle:rightTitle forState:UIControlStateNormal];
        alertView.leftBlock = leftBlock;
        alertView.rightBlock = rightBlock;
        alertView.leftRightButtonLineWidth.constant = 0.5;
    }
    //只有一个按钮
    else {
        alertView.leftButton.hidden = YES;
        alertView.rightButtonLeftMargin.constant = 0;
        if (leftTitle && leftTitle.length) {
            alertView.rightBlock = leftBlock;
            [alertView.rightButton setTitle:leftTitle forState:UIControlStateNormal];
        }else{
            alertView.rightBlock = rightBlock;
            [alertView.rightButton setTitle:rightTitle forState:UIControlStateNormal];
        }
    }
    
    return alertView;
}

#pragma mark - 动画
//弹出
- (void)show
{
    //动画
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.baseView.transform = CGAffineTransformMakeScale(1.15, 1.15);
    self.baseView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.baseView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.baseView.userInteractionEnabled = YES;
    }];
}

//消失
- (void)hideBlock:(void (^)())block
{
    self.baseView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
        self.baseView.transform = CGAffineTransformMakeScale(1.04, 1.04);
    } completion:^(BOOL finished) {
        if (block) block();
        [self removeFromSuperview];
    }];
}

#pragma mark - 绘制左上角按钮图标（叉）
- (void)drawFork:(UIView *)view
{
    //路径
    CGFloat wide = 13;//叉边长
    CGSize size = view.bounds.size;
    CGFloat x = (size.width - wide) / 2.l;
    CGFloat y = (size.height - wide) / 2.l;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y);
    CGPathAddLineToPoint(path, NULL, x + wide, y + wide);
    CGPathMoveToPoint(path, NULL, x + wide, y);
    CGPathAddLineToPoint(path, NULL, x, y + wide);
    //图层
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path;
    CGPathRelease(path);
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = self.bounds;
    shapeLayer.masksToBounds = NO;
    [shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    shapeLayer.lineWidth = 0.5;
    shapeLayer.lineCap = kCALineCapRound;
    [view.layer addSublayer:shapeLayer];
}

#pragma mark - 按钮事件
- (IBAction)leftButtonPressed:(UIButton *)sender {
    [self hideBlock:self.leftBlock];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    [self hideBlock:self.rightBlock];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self hideBlock:nil];
}


@end
