//
//  CommonHtmlJumpViewController.h
//  Huitai
//
//  Created by Laughing on 2017/6/17.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    CommonHtmlShowViewType_RgsProtocol =  0,            /**用户协议**/
    CommonHtmlShowViewType_remindTip =    1,            /**描述介绍*/
    CommonHtmlShowViewType_other     =    2,            /**其他*/
    
} CommonHtmlShowViewType;

@interface CommonHtmlShowViewController : BaseViewController

@property (nonatomic, assign) CommonHtmlShowViewType commonHtmlShowViewType;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *adUrl;

@end
