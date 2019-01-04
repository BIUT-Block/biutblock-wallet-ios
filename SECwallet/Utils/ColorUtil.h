//
//  ColorUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置RGB颜色值
#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

// app 灰背景色
#define BACKGROUND_DARK_COLOR    COLOR(254,255,255,1)

//app导航栏背景色
#define Navi_COLOR	COLOR(52,152,219,1)

//app标签栏背景色
#define Tabbar_COLOR  [UIColor whiteColor]

//无色
#define CLEAR_COLOR	[UIColor clearColor]

// 白色
#define WHITE_COLOR	[UIColor whiteColor]

// 黑色
#define BLACK_COLOR	[UIColor blackColor]

// 灰色
#define DARK_COLOR	    COLOR(245,246,247,1)

//警告色
#define REMIND_COLOR    COLOR(251,220,225,1)

// 浅蓝色
#define LightGreen_COLOR    COLOR(246,252,251,1)

/***********************字体***********************/
// 字体黑色
#define TEXT_BLACK_COLOR   COLOR(64, 83, 92, 1)

// 字体灰色
#define TEXT_DARK_COLOR	   COLOR(144,162,171,1)

//浅灰色
#define TEXT_LightDark_COLOR  COLOR(179,180,181,1)

//字体绿色
#define TEXT_GREEN_COLOR    COLOR(40, 217, 148, 1)

//字体红色
#define TEXT_RED_COLOR    COLOR(237, 28, 57, 1)

// 分割线颜色
#define DIVIDE_LINE_COLOR  COLOR(222, 223, 224, 1)



@interface ColorUtil : NSObject
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color color
 *
 *  @return UIColor
 */
+ (UIColor *) myToolsColorWithHexString: (NSString *)color;

@end

