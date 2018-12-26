//
//  CommonSidePullView.h
//  SECwallet
//
//  Created by 通证控股 on 2018/12/25.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CommonSidePullViewType_address      = 0,
    CommonSidePullViewType_privateKey   = 1,
    CommonSidePullViewType_keyStore     = 2,
    
} CommonSidePullViewType;

@interface CommonSidePullView : UIView

- (id)initWithWidth:(CGFloat)width
      sidePullViewType:(CommonSidePullViewType)sidePullViewType;


- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;


@end

