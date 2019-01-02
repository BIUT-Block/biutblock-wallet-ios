//
//  ConfirmPasswordViewController.h
//  SECwallet
//
//  Created by 通证控股 on 2019/1/2.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

typedef enum {
    ConfirmPasswordViewType_privateKey    =  0,
    ConfirmPasswordViewType_keystore      =  1,
    ConfirmPasswordViewType_transfer      =  2,
    ConfirmPasswordViewType_deletWallet   =  3,
    
} ConfirmPasswordViewType;

@interface ConfirmPasswordViewController : BaseViewController

@property (nonatomic, assign) ConfirmPasswordViewType confirmPasswordViewType;
@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic, copy) dispatch_block_t sureBlock;

@end

