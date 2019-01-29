//
//  NSString+Extension.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString *)jsonUtils:(id)stringValue
{
    NSString *string = [NSString stringWithFormat:@"%@", stringValue];
    
    if([string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    
    if(string == nil)
    {
        string = @"";
    }
    
    if([string isEqualToString:@"(null)"])
    {
        string = @"";
    }
    
    if([string isEqualToString:@""])
    {
        string = @"";
    }
    
    if(string.length == 0)
    {
        string = @"";
    }
    
    return string;
}

// 密码验证
+ (BOOL)validatePassword:(NSString *)password
{
//    NSString *passwordRegex = @"^[a-zA-Z0-9]{8,30}+$";
    //特殊字符仅包括：~`@#$%^&*-_=+|\?/()<>[]{},.;'!"
    NSString *passwordRegex = @"^[a-zA-Z0-9~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]{8,30}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    BOOL isMatch = [passwordPredicate evaluateWithObject:password];
    if (!isMatch) {
        return NO;
    }
    //是否是纯数字或纯字母
    if ([self isPureNumandCharacters:password] == YES || [self isPureLetters:password] == YES) {
        return NO;
    }
    return isMatch;
}

+(int)checkIsHaveNumAndLetter:(NSString*)password
{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                     options:NSMatchingReportProgress
                                                                       range:NSMakeRange(0, password.length)];
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]"options:NSRegularExpressionCaseInsensitive error:nil];
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    if(tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    }else if(tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 1;
    }else if((tNumMatchCount+tLetterMatchCount == password.length) || (tNumMatchCount==0 && tLetterMatchCount>0&&tLetterMatchCount<password.length)|| (tLetterMatchCount==0 && tNumMatchCount>0&&tNumMatchCount<password.length)) {
        //包含两种字符
        return 2;
    }else if (tNumMatchCount>0 && tLetterMatchCount>0 && (tNumMatchCount +tLetterMatchCount)<password.length){
        return 3;
    }else{
        return 0;
    }
}

//是否是纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

//是否是纯字母
+(BOOL)isPureLetters:(NSString*)str
{    
    for(int i=0;i<str.length;i++){
        unichar c=[str characterAtIndex:i];
        if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
            return NO;
    }
    return YES;
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9]|(19[0-9])))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum
{
    if (phoneNum.length >7) {
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }else{
        return nil;
    }
}

// 把地址中间位变成星号
+(NSString *)addressToAsterisk:(NSString *)address
{
    NSString *str1 = [address substringWithRange:NSMakeRange(0,10)];
    NSString *str2 = [address substringWithRange:NSMakeRange(address.length-10,10)];
    return [NSString stringWithFormat:@"%@...%@",str1,str2];
}

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width,1000);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0){
    if (aString.length == 0) {
        return NO;
    }
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

#pragma mark - 返回时间戳
+ (NSString *)timestampChange:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSString *timeSp = [NSString stringWithFormat:@"%lo",(long)[date timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - 时间戳13位转10位
+ (NSString *)convertTimeStampsToString:(NSNumber *)timestamp
{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:timestamp.longValue/1000.0];
    return [stampFormatter stringFromDate:stampDate];
}

//字典格式的字符串转换成字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

#pragma mark - 生成二维码
+ (UIImage *)twoDimensionCodeWithUrl:(NSString *)url
{
    // 1.将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.恢复默认
    [filter setDefaults];
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGFloat size = Size(185);
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
