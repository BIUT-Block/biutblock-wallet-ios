//
//  UILabel+Extension.m
//  SECwallet
//
//  Created by 通证控股 on 2019/1/2.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

-(void)remindError:(NSString *)title withY:(CGFloat)y
{
    self.frame = CGRectMake(Size(100), y, kScreenWidth -Size(100 +20), Size(25));
    self.font = SystemFontOfSize(9);
    self.textAlignment = NSTextAlignmentRight;
    self.textColor = TEXT_RED_COLOR;
    self.text = Localized(title, nil);
    //抖动效果
    [self shakeAnimationForView:self];
}

- (void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

@end
