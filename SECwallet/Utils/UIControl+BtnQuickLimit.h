//
//  UIControl+BtnQuickLimit.h
//  SECwallet
//
//  Created by 通证控股 on 2019/2/20.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BtnQuickLimit)
// 间隔多少秒才能响应事件
@property(nonatomic, assign) NSTimeInterval  acceptEventInterval;
//是否能执行方法
@property(nonatomic, assign) BOOL ignoreEvent;

@end
