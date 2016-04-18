//
//  AlertView.h
//  FineExCRM
//
//  Created by FineexMac on 16/3/23.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_CONFIRM @"确定"
#define TITLE_CANCEL  @"取消"

@interface AlertView : UIAlertView

///显示单按钮
+ (void)showWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSString *)buttonTitle block:(void (^)())block;

///显示
+ (void)showWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)left rightTitle:(NSString *)right leftBlock:(void (^)())leftBlock rightBlock:(void (^)())rightBlock;

@end
