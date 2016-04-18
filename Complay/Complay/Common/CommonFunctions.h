//
//  CommonFunctions.h
//  FineExCRM
//
//  Created by FineexMac on 16/3/15.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#ifndef CommonFunctions_h
#define CommonFunctions_h

#import <Foundation/Foundation.h>


#pragma mark - 函数:

#pragma mark - 颜色
///RGB颜色
UIColor *ColorRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
///RGB颜色（透明值为1）
UIColor *ColorRGB(CGFloat red, CGFloat green, CGFloat blue);
///黑白色
UIColor *ColorGray(CGFloat gray);





#pragma mark - 日期时间
///时间转标准字符串
NSString *StringFromDate(NSDate *date);
///时间转年月日
NSString *YMDString(NSDate *date);


#pragma mark - 数字
///将较大数字转化为软文
NSString *StringFromNumber(NSInteger num);


#pragma mark - 字符串
///是否为空
BOOL StringIsNull(NSString *string);

@interface NSString (Category)
///去掉空格和换行符
- (NSString *)cleanString;
///检查电话是否符合规范(包含手机和座机 分机)(数字或“-”)
- (BOOL)isTelNum;
///检查是否为指定位数内的纯数字
- (BOOL)isNum:(NSInteger)count;

@end



#pragma mark - URL打开本地scheme
///跳转到AppStore
void ViewAppInStore(NSString *appId);




/*
#pragma mark - MD5加密、GZip加压、JSONData
///MD5加密
NSString *Md5(NSString *key);

///GZip加压
NSData *GZip(NSData *data);
///CZip解压
NSData *GUnZip(NSData *data);

///JSONData
NSData *JSONData(NSDictionary *string);
 */

#endif /* CommonFunctions_h */
