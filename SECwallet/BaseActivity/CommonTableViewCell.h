//
//  CommonTableViewCell.h
//  SECwallet
//
//  Created by 通证控股 on 2018/12/21.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *bkgIV;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *staticTitleLb;
@property (nonatomic, strong) UIImageView *accessoryIV;

-(void) fillCellWithObject:(id) object;

@end

