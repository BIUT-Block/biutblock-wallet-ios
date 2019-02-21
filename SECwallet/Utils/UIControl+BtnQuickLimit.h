//
//  UIControl+BtnQuickLimit.h
//  SECwallet
//
//  Created by 通证控股 on 2019/2/20.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BtnQuickLimit)

@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,assign) BOOL isIgnoreEvent;

@end
