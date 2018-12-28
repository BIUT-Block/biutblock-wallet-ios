//
//  AddressCodePayViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "AddressCodePayViewController.h"

@interface AddressCodePayViewController ()
{
}
@end

@implementation AddressCodePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(246, 252, 251, 1);
    [self addContentView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = COLOR(246, 252, 251, 1);
    
}

#pragma mark - 底部收款视图
- (void)addContentView
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];
    
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, backBT.maxY +Size(10), kScreenWidth, Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = Localized(@"SEC收款",nil);
    [self.view addSubview:titleLb];
    
    //地址
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(65), titleLb.maxY +Size(60), kScreenWidth -Size(65)*2, Size(40))];
    addressLb.font = SystemFontOfSize(10);
    addressLb.textColor = TEXT_DARK_COLOR;
    addressLb.numberOfLines = 2;
    addressLb.textAlignment = NSTextAlignmentCenter;
    addressLb.text = _walletModel.address;
    [self.view addSubview:addressLb];
    
    //支付码
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(addressLb.minX, addressLb.maxY +Size(15), kScreenWidth-addressLb.minX*2, Size(190))];
    bkgView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:bkgView];
    UIImageView *payCode = [[UIImageView alloc]initWithFrame:CGRectMake(Size(20), Size(20), bkgView.width-Size(20 *2), bkgView.height-Size(20 *2))];
    payCode.image = [NSString twoDimensionCodeWithUrl:_walletModel.address];
    [bkgView addSubview:payCode];
    
    //复制收款地址
    UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(bkgView.minX, bkgView.maxY +Size(30), bkgView.width, Size(45))];
    [copyBT goldBigBtnStyle:Localized(@"复制收款地址", nil)];
    [copyBT addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBT];
    
}

#pragma 复制收款地址
-(void)copyAction
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _walletModel.address;
    [self hudShowWithString:@"已复制" delayTime:1];
}

@end
