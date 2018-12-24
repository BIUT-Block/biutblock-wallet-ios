//
//  CommonAlertView.h
//  Topzrt
//
//  Created by Laughing on 16/6/30.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    //图片、标题，内容，按钮
    CommonAlertViewType_exclamation_mark  = 0,
    CommonAlertViewType_question_mark     = 1,
    CommonAlertViewType_Check_mark        = 2,
    //标题，内容，按钮
    CommonAlertViewType_remind            = 3,
    
} CommonAlertViewType;

@interface CommonAlertView : UIView


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
          imageName:(NSString *)imageName
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      alertViewType:(CommonAlertViewType)alertViewType;


- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;


@end
