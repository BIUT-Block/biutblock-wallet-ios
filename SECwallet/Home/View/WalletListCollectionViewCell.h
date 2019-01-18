//
//  WalletListCollectionViewCell.h
//  SECwallet
//
//  Created by 通证控股 on 2019/1/18.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletListCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *bkgIV;    //背景图
@property (nonatomic,strong) UILabel* nameLb;

@property (nonatomic,strong) UILabel* totalSumLb;  //总资产
@property (nonatomic,strong) UIButton* addressBT;  //地址
@property (nonatomic,strong) UIButton* backupBT;  //备份按钮
@property (nonatomic,strong) UIButton *codeBT;
@end

NS_ASSUME_NONNULL_END
