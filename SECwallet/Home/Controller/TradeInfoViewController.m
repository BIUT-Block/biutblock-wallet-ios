//
//  TradeInfoViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/16.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeInfoViewController.h"
#import "CommonHtmlShowViewController.h"

#define kHeaderHeight    KStatusBarHeight+Size(225)

@interface TradeInfoViewController ()

@end

@implementation TradeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 底部收款视图
- (void)addContentView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    headerView.backgroundColor = LightGreen_COLOR;
    [self.view addSubview:headerView];
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [headerView addSubview:backBT];
    
    UIButton *moreBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(65 +20), KStatusBarHeight+Size(11), Size(65), Size(24))];
    [moreBT greenBorderBtnStyle:Localized(@"查看更多",nil) andBkgImg:@"continue"];
    [moreBT addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBT];
    
    //标题
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(15), Size(200), Size(20))];
    desLb.textColor = TEXT_BLACK_COLOR;
    desLb.font = BoldSystemFontOfSize(20);
    desLb.text = Localized(@"交易记录",nil);
    [headerView addSubview:desLb];
    
    //状态图片
    UIImageView *statusIV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(60))/2, desLb.maxY +Size(35), Size(60), Size(60))];
    if (_tradeModel.status == 0) {
        statusIV.image = [UIImage imageNamed:@"tradeInfoIcon_fail"];
    }else{
        statusIV.image = [UIImage imageNamed:@"tradeInfoIcon_success"];
    }
    [headerView addSubview:statusIV];
    //金额
    UILabel *sumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, statusIV.maxY +Size(5), kScreenWidth, Size(30))];
    sumLb.font = SystemFontOfSize(14);
    sumLb.textColor = TEXT_GREEN_COLOR;
    sumLb.textAlignment = NSTextAlignmentCenter;
    sumLb.text = [NSString stringWithFormat:@"+%@ sec",_tradeModel.sum];
    [headerView addSubview:sumLb];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.maxY, kScreenWidth, Size(185))];
    centerView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:centerView];
    NSArray *titleArr = @[Localized(@"发款方", nil),Localized(@"收款方", nil),Localized(@"矿工费用", nil),Localized(@"备注", nil)];
    NSArray *contentArr = @[_tradeModel.transferAddress,_tradeModel.gatherAddress,_tradeModel.gas,_tradeModel.tip];
    for (int i = 0; i< titleArr.count; i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.minX, Size(15) +i*Size(10 +20 +15), kScreenWidth -desLb.minX*2, Size(10))];
        titleLb.font = SystemFontOfSize(10);
        titleLb.textColor = TEXT_BLACK_COLOR;
        titleLb.text = titleArr[i];
        [centerView addSubview:titleLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY, titleLb.width, Size(20))];
        contentLb.font = SystemFontOfSize(10);
        contentLb.textColor = COLOR(175, 176, 177, 1);
        contentLb.text = contentArr[i];
        [centerView addSubview:contentLb];
    }
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, centerView.maxY, kScreenWidth, kScreenHeight-KNaviHeight-kHeaderHeight-centerView.height)];
    bottomView.backgroundColor = DARK_COLOR;
    [self.view addSubview:bottomView];
    NSArray *titleArr1 = @[Localized(@"交易号", nil),Localized(@"区块", nil),Localized(@"交易时间", nil)];
    NSArray *contentArr1 = @[[NSString addressToAsterisk:_tradeModel.tradeNum],_tradeModel.blockNum,_tradeModel.time];
    for (int i = 0; i< titleArr1.count; i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.minX, Size(15) +i*Size(25), Size(150), Size(25))];
        titleLb.font = SystemFontOfSize(10);
        titleLb.textColor = TEXT_BLACK_COLOR;
        titleLb.text = titleArr1[i];
        [bottomView addSubview:titleLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.maxX, titleLb.minY, kScreenWidth-Size(150)-desLb.minX*2, Size(25))];
        contentLb.font = SystemFontOfSize(10);
        contentLb.textColor = TEXT_DARK_COLOR;
        contentLb.textAlignment = NSTextAlignmentRight;
        contentLb.text = contentArr1[i];
        [bottomView addSubview:contentLb];
    }

}

#pragma 查看更多信息
-(void)moreAction
{
    NSURL *jumpURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SECBrowserUrl,_tradeModel.tradeNum]];
    [[UIApplication sharedApplication] openURL:jumpURL];
}

@end
