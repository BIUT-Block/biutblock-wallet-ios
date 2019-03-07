//
//  Localized.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/25.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "Localized.h"

@implementation Localized

+ (Localized *)sharedInstance{
    static Localized *language=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        language = [[Localized alloc] init];
    });
    return language;
}

- (void)initLanguage{
    NSString *language=[self currentLanguage];
    if (language.length>0) {
        NSLog(@"自设置语言:%@",language);
    }else{
        [self systemLanguage];
    }
}

- (NSString *)currentLanguage{
    NSString *language=[[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    return language;
}

- (void)setLanguage:(NSString *)language{
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:AppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)systemLanguage{
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    NSLog(@"系统语言:%@",languageCode);
    if([languageCode hasPrefix:@"zh-Hant"]){
        languageCode = @"zh-Hant";//繁体中文
    }else if([languageCode hasPrefix:@"zh-Hans"]){
        languageCode = @"zh-Hans";//简体中文
    }else if([languageCode hasPrefix:@"pt"]){
        languageCode = @"pt";//葡萄牙语
    }else if([languageCode hasPrefix:@"es"]){
        languageCode = @"es";//西班牙语
    }else if([languageCode hasPrefix:@"th"]){
        languageCode = @"th";//泰语
    }else if([languageCode hasPrefix:@"hi"]){
        languageCode = @"hi";//印地语
    }else if([languageCode hasPrefix:@"ru"]){
        languageCode = @"ru";//俄语
    }else if([languageCode hasPrefix:@"ja"]){
        languageCode = @"ja";//日语
    }else if([languageCode hasPrefix:@"en"]){
        languageCode = @"en";//英语
    }else{
        languageCode = @"en";//英语
    }
    [self setLanguage:languageCode];
}

@end
