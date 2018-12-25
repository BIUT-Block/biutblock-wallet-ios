//
//  Localized.h
//  SECwallet
//
//  Created by 通证控股 on 2018/12/25.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import <Foundation/Foundation.h>

//语言切换
static NSString * const AppLanguage = @"appLanguage";
#define Localized(key, comment)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]

@interface Localized : NSObject

+ (Localized *)sharedInstance;

//初始化多语言功能
- (void)initLanguage;

//当前语言
- (NSString *)currentLanguage;

//设置要转换的语言
- (void)setLanguage:(NSString *)language;

//设置为系统语言
- (void)systemLanguage;

@end
