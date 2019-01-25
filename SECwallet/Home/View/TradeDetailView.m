//
//  TradeDetailView.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeDetailView.h"

#define kAssetsViewWidth      kScreenWidth
#define kAssetsViewHeight     Size(285)

@interface TradeDetailView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *infoView;

@end


@implementation TradeDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//视图
-(void)initTradeDetailViewWith:(NSString *)adress payAddress:(NSString *)payAddress gasPrice:(NSString *)gasPrice sum:(NSString *)sum tokenName:(NSString *)tokenName
{
    self.frame = [UIScreen mainScreen].bounds;
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
    //设置阴影
    CALayer *layer = [self layer];
    layer.shadowOffset = CGSizeMake(0, -Size(3));
    layer.shadowRadius = Size(3);
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    layer.shadowOpacity = Size(0.3);
    
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kAssetsViewWidth, kAssetsViewHeight)];
    _infoView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self addSubview:_infoView];
    
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), Size(20), Size(15), Size(15))];
    [backBT setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(tradeDetailViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:backBT];
    //交易详情
    UILabel *detailLb = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(20), kScreenWidth, Size(20))];
    detailLb.font = BoldSystemFontOfSize(14);
    detailLb.textColor = COLOR(56, 142, 218, 1);
    detailLb.textAlignment = NSTextAlignmentCenter;
    detailLb.text = Localized(@"交易详情", nil);
    [_infoView addSubview:detailLb];
    
    NSArray *titArr =@[Localized(@"转入地址", nil),Localized(@"付款钱包", nil),Localized(@"金额", nil)];
    NSArray *contentArr =@[payAddress,adress,[NSString stringWithFormat:@"%@ SEC\n",sum]];
    for (int i = 0; i< titArr.count; i++) {
        UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), detailLb.maxY+Size(25) +Size(45)*i, Size(100), Size(20))];
        titLb.font = SystemFontOfSize(13);
        titLb.textColor = COLOR(147, 147, 148, 1);
        titLb.text = titArr[i];
        [_infoView addSubview:titLb];
        
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titLb.maxX, titLb.minY, kScreenWidth -titLb.maxX -Size(20), Size(35))];
        contentLb.font = SystemFontOfSize(13);
        contentLb.textColor = TEXT_BLACK_COLOR;
        contentLb.textAlignment = NSTextAlignmentRight;
        contentLb.numberOfLines = 2;
        contentLb.text = contentArr[i];
        [_infoView addSubview:contentLb];
    }

    /*****************确认*****************/
    UIButton *confirmBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), detailLb.maxY +Size(180), kScreenWidth - 2*Size(20), Size(45))];
    [confirmBT goldBigBtnStyle:Localized(@"确 认", nil)];
    [confirmBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:confirmBT];
    
    //消失视图
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tradeDetailViewHidden)];
    tapGes.delegate = self;
    [self addGestureRecognizer:tapGes];
    
    [self tradeDetailViewShow];
}

/**
 展示view
 */
-(void)tradeDetailViewShow
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 1;
        CGRect frame = _infoView.frame;
        frame.origin.y = kScreenHeight -kAssetsViewHeight;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished){
    }];
}

/**
 隐藏view
 */
-(void)tradeDetailViewHidden
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = _infoView.frame;
        frame.origin.y = kScreenHeight;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished){
        self.alpha = 0;
    }];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)nextAction
{
    [self.delegate clickFinish];
    [self tradeDetailViewHidden];
}

@end
