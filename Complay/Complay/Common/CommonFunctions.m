//
//  CommonFunction.m
//  FineExCRM
//
//  Created by FineexMac on 16/3/15.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import "CommonConstants.h"
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>
#import <UIKit/UIKit.h>

#pragma mark - 颜色
///RGB颜色
UIColor *ColorRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red/255.l green:green/255.l blue:blue/255.l alpha:alpha];
}

///RGB颜色（透明值为1）
UIColor *ColorRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red/255.l green:green/255.l blue:blue/255.l alpha:1];
}

///黑白色
UIColor *ColorGray(CGFloat gray) {
    return [UIColor colorWithWhite:gray/255.l alpha:1];
}









#pragma mark - 日期时间
@implementation NSDate (Category)

///转化为日期组件
- (NSDateComponents *)components
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:self];
    return components;
}

///转为特定格式字符串
- (NSString *)stringWithFormatterString:(NSString *)formStr
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:formStr];
    return [formatter stringFromDate:self];
}

///转化为软文字符串
- (NSString *)softString:(BOOL)essay
{
    //目标日期组件
    NSDateComponents *tagComp = [self components];
    //此时日期组件
    NSDateComponents *nowComp = [[NSDate date] components];
    //今天已过秒数
    const NSTimeInterval todaySecs = nowComp.hour*3600 + nowComp.minute*60 + nowComp.second;
    //目标日期到现在的秒数
    const NSTimeInterval intervalSecs = [[NSDate date] timeIntervalSinceDate:self];
    
    //未来
    if (intervalSecs < 0) {
        return [self stringWithFormatterString:@"yyyy-MM-dd hh:mm"];
    }
    //刚刚
    else if (intervalSecs <= 5) {
        return @"刚刚";
    }
    //刚才
    else if (intervalSecs <= 60) {
        return [NSString stringWithFormat:@"%.0f秒前", intervalSecs];
    }
    //今天
    else if (intervalSecs <= todaySecs) {
        if (essay) return [self stringWithFormatterString:@"hh:mm"];
        else return [self stringWithFormatterString:@"今天hh:mm"];
    }
    //昨天
    else if (intervalSecs <= todaySecs + 84600) {
        if (essay) return @"昨天";
        else return [self stringWithFormatterString:@"昨天hh:mm"];
    }
    //今年
    else if (tagComp.year == nowComp.year) {
        if (essay) return [self stringWithFormatterString:@"MM-dd"];
        else return [self stringWithFormatterString:@"yyyy-MM-dd"];
    }
    //往年
    else {
        if (essay) return [self stringWithFormatterString:@"yy-MM-dd"];
        else return [self stringWithFormatterString:@"yyyy-MM-dd"];
    }
    return [self stringWithFormatterString:@"yyyy-MM-dd hh:mm"];
}

@end






#pragma mark - 数字
///将较大数字转化为软文, 如数字 12400 转化为 “1.2万”
NSString *StringFromNumber(NSInteger num) {
    if (num<10000) {
        return [NSString stringWithFormat:@"%lu", MAX(0, num)];
    }else if (num<100000000) {
        return [NSString stringWithFormat:@"%.1lf万", num/10000.0];
    }else {
        return [NSString stringWithFormat:@"%.2lf亿", num/10000.00];
    }
}






#pragma mark - 字符串
///是否为空
BOOL StringIsNull(NSString *string) {
    if (string == nil) {
        return YES;
    }else if ([string isEqual:[NSNull null]]) {
        return YES;
    }else if (!string.length) {
        return YES;
    }else if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

@implementation NSString (Category)

///去掉空格和换行符
- (NSString *)cleanString
{
    if (self && self.length) {
        //去除掉首尾的空白字符和换行字符
        NSString *newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return newStr;
    }
    return self;
}

///是否为手机或电话号码(数字或“-”)
- (BOOL)isTelNum
{
    NSString *regular = @"^((400[0-9]{7})|(\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    return [self predicate:regular];
}

///检查是否为指定位数内的纯数字
- (BOOL)isNum:(NSInteger)count
{
    NSString *regular = [NSString stringWithFormat:@"^[0-9]{1,%ld}$", count];
    return [self predicate:regular];
}

//正则表达式匹配结果
- (BOOL)predicate:(NSString *)regular
{
    if (self) {
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
        return [regextestct evaluateWithObject:self];
    }
    return NO;
}

@end







#pragma mark - URL打开本地scheme
///跳转到AppStore
void ViewAppInStore(NSString *appId) {
    NSString* url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=";
    url = [url stringByAppendingString:appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}








/*
#pragma mark - MD5加密、GZip加压解压、JSONData
///MD5加密
NSString *Md5(NSString *key) {
    const char* str = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return [ret lowercaseString];
}

///GZip加压
NSData *GZip(NSData *data) {
    if (data && [data length]) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        static const NSUInteger ChunkSize = 16384;
        if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
            NSMutableData *data = [NSMutableData dataWithLength:ChunkSize];
            while (stream.avail_out == 0) {
                if (stream.total_out >= [data length]) {
                    data.length += ChunkSize;
                }
                stream.next_out = (uint8_t *)[data mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

///GZip解压
NSData *GUnZip(NSData *data) {
    if (data && [data length]) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *newData = [NSMutableData dataWithLength:(NSUInteger)([data length] * 1.5)];
        if (inflateInit2(&stream, 47) == Z_OK) {
            int status = Z_OK;
            while (status == Z_OK) {
                if (stream.total_out >= [newData length]) {
                    newData.length += [data length] / 2;
                }
                stream.next_out = (uint8_t *)[newData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([newData length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK) {
                if (status == Z_STREAM_END) {
                    newData.length = stream.total_out;
                    return newData;
                }
            }
        }
    }
    return nil;
}

///JSONData
NSData *JSONData(NSDictionary *string) {
    NSString *jsonStr = [string JSONString];
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
}
*/