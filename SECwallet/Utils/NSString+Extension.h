//
//  NSString+Extension.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/*
 * 字符串解析
 */
+(NSString *)jsonUtils:(id)stringValue;

// 手机号码验证
+(BOOL)validateMobile:(NSString *)mobile;

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

// 把地址中间位变成星号
+(NSString *)addressToAsterisk:(NSString*)address;

// 邮箱验证
+(BOOL)validateEmail:(NSString *)email;

// 密码验证
+(BOOL)validatePassword:(NSString *)password;

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width;

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);

#pragma mark - 返回时间戳
+ (NSString *)timestampChange:(NSDate *)date;

#pragma mark - 时间戳13位转10位
+ (NSString *)convertTimeStampsToString:(NSNumber *)timestamp;

//字典格式的字符串转换成字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

#pragma mark - 生成二维码
+ (UIImage *)twoDimensionCodeWithUrl:(NSString *)url;

@end
