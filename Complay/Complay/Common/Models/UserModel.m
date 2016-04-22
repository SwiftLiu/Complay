//
//  UserModel.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "UserModel.h"
#import "LoginViewController.h"

@implementation BmobUser (UserModel)

//#pragma mark - 单利
//+ (UserModel *)currentUser
//{
//    static UserModel *model = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        model = [[UserModel alloc] init];
//    });
//    return model;
//}

#pragma mark - getter
- (NSString *)userId    { return [NSString stringWithFormat:@"%d", [[self objectForKey:@"userId"] intValue] ]; };
- (NSString *)avatarUrl   { return ((BmobFile *)[self objectForKey:@"headImg"]).url; };
- (NSInteger)stage      { return [[self objectForKey:@"stage"] intValue]; };
- (NSString *)stageName { return [self objectForKey:@"stageName"]; };

- (NSString *)weboName { return [self objectForKey:@"weboName"]; };
- (NSString *)link     { return [self objectForKey:@"link"]; };
- (NSString *)linkName { return [self objectForKey:@"linkName"]; };

- (NSInteger)fansCount { return [[self objectForKey:@"fansCount"] intValue]; };
- (NSInteger)careCount { return [[self objectForKey:@"careCount"] intValue]; };
- (NSInteger)newSendTaskCount { return [[self objectForKey:@"newSendTaskCount"] intValue]; };
- (NSInteger)newGetTaskCount  { return [[self objectForKey:@"newGetTaskCount"] intValue]; };
- (NSInteger)oldSendTaskCount { return [[self objectForKey:@"oldSendTaskCount"] intValue]; };
- (NSInteger)oldGetTaskCount  { return [[self objectForKey:@"oldGetTaskCount"] intValue]; };


#pragma mark - 登录后才处理
+ (void)dealBlock:(void (^)())block
{
    if ([BmobUser getCurrentUser]) {
        if (block) block();
    }else {
        LoginViewController *lVC = [LoginViewController new];
        [lVC setLoginBlock:block];
        UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
        [vc presentViewController:lVC animated:YES completion:nil];
    }
}

@end
