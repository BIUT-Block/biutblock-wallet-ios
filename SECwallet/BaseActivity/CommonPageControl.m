//
//  CommonPageControl.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/21.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "CommonPageControl.h"

@implementation CommonPageControl

#define dotW          Size(5)
#define activeDotW    Size(5)
#define margin        Size(5)

- (void)layoutSubviews
{
    [super layoutSubviews];
    //计算圆点间距
    CGFloat marginX = margin + 5;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1) * marginX;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
    }
    
//    //设置圆点照片、当前照片用KVC
//    [pagecontrol setValue:[UIImage imageNamed:@"icon_xuanzhong"] forKeyPath:@"_currentPageImage"];
//    [pagecontrol setValue:[UIImage imageNamed:@"icon_weixuanzhong"] forKeyPath:@"_pageImage"];
}


@end
