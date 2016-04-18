//
//  AlertView.m
//  FineExCRM
//
//  Created by FineexMac on 16/3/23.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()<UIAlertViewDelegate>

@property (strong, nonatomic) void (^leftBlock)();
@property (strong, nonatomic) void (^rightBlock)();

@end

@implementation AlertView

+ (void)showWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSString *)buttonTitle block:(void (^)())block
{
    [AlertView showWithTitle:title message:msg leftTitle:buttonTitle rightTitle:nil leftBlock:nil rightBlock:block];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)left rightTitle:(NSString *)right leftBlock:(void (^)())leftBlock rightBlock:(void (^)())rightBlock
{
    AlertView *alert = [[AlertView alloc] initWithTitle:title
                                                message:msg
                                               delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:left, right, nil];
    alert.delegate = alert;
    [alert show];
    alert.leftBlock = leftBlock;
    alert.rightBlock = rightBlock;
}

#pragma mark - <UIAlertViewDelegate>协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if (_leftBlock) _leftBlock();
    }else if (buttonIndex == 1) {
        if (_rightBlock) _rightBlock();
    }
}
@end
