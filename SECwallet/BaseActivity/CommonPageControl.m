//
//  CommonPageControl.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/21.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "CommonPageControl.h"

@implementation CommonPageControl

-(void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size = CGSizeMake(Size(5), Size(5));
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,size.width,size.height)];
        
//        if (subviewIndex == currentPage) {
////        subview.image =[UIImage imageNamed:@"60.png"];   //设置圆点图片
////            subview.layer.cornerRadius = 0;    //设置圆点形状
//            subview.layer.masksToBounds = YES;
//        }else{
////            subview.image =[UIImage imageNamed:@"60.png"];
////            subview.layer.cornerRadius = 0;
//            subview.layer.masksToBounds = YES;
//        }
    }
}

@end
