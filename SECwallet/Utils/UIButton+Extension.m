//
//  UIButton+Extension.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
    CGFloat widthDelta = MAX(35, 0);
    CGFloat heightDelta = MAX(35, 0);
    bounds = CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);
    return CGRectContainsPoint(bounds, point);
}

// 正常风格按钮
-(void)customerBtnStyle:(NSString *)title andBkgImg:(NSString *)bkgImg{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = BoldSystemFontOfSize(12);
    [self setBackgroundImage:[UIImage imageNamed:bkgImg] forState:UIControlStateNormal];
}

// 绿色边框风格按钮
-(void)greenBorderBtnStyle:(NSString *)title andBkgImg:(NSString *)bkgImg{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:COLOR(9, 197, 183, 1) forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(9);
    [self setBackgroundImage:[UIImage imageNamed:bkgImg] forState:UIControlStateNormal];
}

//金色大按钮
-(void)goldBigBtnStyle:(NSString *)title{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = BoldSystemFontOfSize(12);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"goldBigBtn"] forState:UIControlStateNormal];
}

// 金色小按钮
-(void)goldSmallBtnStyle:(NSString *)title{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor: BACKGROUND_DARK_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = BoldSystemFontOfSize(12);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"goldSmallBtn"] forState:UIControlStateNormal];
}

// 灰色风格按钮
-(void)darkBtnStyle:(NSString *)title
{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = BoldSystemFontOfSize(12);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"darkBigBtn"] forState:UIControlStateNormal];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef mContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(mContext, [color CGColor]);
    CGContextFillRect(mContext, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
