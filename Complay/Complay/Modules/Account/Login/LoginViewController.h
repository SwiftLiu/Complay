//
//  LoginViewController.h
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "BasicViewController.h"

@interface LoginViewController : BasicViewController

///登录完成后回调
@property (strong, nonatomic) void (^loginBlock)();

@end
