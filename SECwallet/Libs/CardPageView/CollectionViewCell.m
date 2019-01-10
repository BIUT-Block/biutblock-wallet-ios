//
//  CollectionViewCell.m
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        _bkgIV = [[UIImageView alloc] initWithFrame:self.bounds];
        _bkgIV.layer.cornerRadius = Size(5);
        _bkgIV.layer.masksToBounds = YES;
        [self.contentView addSubview:_bkgIV];
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), Size(20), self.width/2, Size(30))];
        _nameLb.font = SystemFontOfSize(20);
        _nameLb.textColor = WHITE_COLOR;
        [self.contentView addSubview:_nameLb];
        
        _totalSumLb = [[UILabel alloc]initWithFrame:CGRectMake(_nameLb.minX, _nameLb.maxY +Size(35), self.width, Size(20))];
        _totalSumLb.font = BoldSystemFontOfSize(15);
        _totalSumLb.textColor = WHITE_COLOR;
        [self.contentView addSubview:_totalSumLb];
        //地址
        _addressBT = [[UIButton alloc]initWithFrame:CGRectMake(_totalSumLb.minX, _totalSumLb.maxY, self.width/2, Size(15))];
        _addressBT.titleLabel.font = SystemFontOfSize(10);
        [_addressBT setTitleColor:COLOR(254, 255, 255, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:_addressBT];
        
        _backupBT = [[UIButton alloc]initWithFrame:CGRectMake(self.width -Size(50 +25), _totalSumLb.minY +Size(5), Size(50), Size(20))];
        _backupBT.titleLabel.font = SystemFontOfSize(10);
        [_backupBT setTitleColor:COLOR(1, 216, 108, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:_backupBT];

        //二维码
        _codeBT = [[UIButton alloc]initWithFrame:CGRectMake(_addressBT.minX, _addressBT.maxY +Size(10), Size(25), Size(25))];
        [self.contentView addSubview:_codeBT];
        
    }
    return self;
}

@end

