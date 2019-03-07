//
//  SizeUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

//--- 跳转通知
#define NotificationUpdateWalletPageView       @"update_WalletPageView"      //通知更新钱包列表

#define Size(x) ((x)*kScreenWidth/320.f)  //屏幕适配

#define SystemFontOfSize(x) ((IS_iPhone4 || IS_iPhone5) ? [UIFont systemFontOfSize:(x-2)] : [UIFont systemFontOfSize:((x)*kScreenWidth/320.f)]) //正常字体
#define BoldSystemFontOfSize(x) ((IS_iPhone4 || IS_iPhone5) ? [UIFont boldSystemFontOfSize:(x-2)] : [UIFont boldSystemFontOfSize:((x)*kScreenWidth/320.f)])  //加粗字体

#define IS_iPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)

#define KStatusBarHeight  (IS_iPhoneX ? 44.f : 20.f)
#define KNaviHeight       ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0 ? 44: (IS_iPhoneX ? 88 :64))
#define KTabbarHeight     (IS_iPhoneX ? (49.f+34.f) : 49.f)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

// =====================================================================
// 应用程序总代理
#define AppDelegateInstance	 ((AppDelegate*)([UIApplication sharedApplication].delegate))

// 操作系统是否大于等于iOS8
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// 操作系统是否大于等于iOS11
#define IS_IOS11  ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] != NSOrderedAscending)

#define IS_iPhone4 [UIScreen mainScreen].bounds.size.height == 480

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface SizeUtil : NSObject

@end
