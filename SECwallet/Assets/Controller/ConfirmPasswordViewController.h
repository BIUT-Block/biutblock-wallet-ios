//
//  ConfirmPasswordViewController.h
//  SECwallet
//
//  Created by 通证控股 on 2019/1/2.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

@interface ConfirmPasswordViewController : BaseViewController

@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic, copy) dispatch_block_t sureBlock;

@end

