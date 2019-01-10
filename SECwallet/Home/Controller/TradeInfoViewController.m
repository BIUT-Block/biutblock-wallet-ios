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
    [moreBT greenBorderBtnStyle:Localized(@"查看更多",nil) andBkgImg:@"centerRightBtn"];
    [moreBT addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBT];
    
    //标题
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(15), Size(200), Size(20))];
    desLb.textColor = TEXT_BLACK_COLOR;
    desLb.font = BoldSystemFontOfSize(20);
    desLb.text = Localized(@"交易记录",nil);
    [headerView addSubview:desLb];
    
    //状态图片
    UIImageView *statusIV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(50))/2, desLb.maxY +Size(35), Size(50), Size(48))];
    [headerView addSubview:statusIV];
    //金额
    UILabel *sumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, statusIV.maxY +Size(10), kScreenWidth, Size(20))];
    sumLb.font = BoldSystemFontOfSize(15);
    sumLb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:sumLb];
    UILabel *statusLb = [[UILabel alloc] initWithFrame:CGRectMake(sumLb.minX, sumLb.maxY, sumLb.width, Size(10))];
    statusLb.font = SystemFontOfSize(9);
    statusLb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:statusLb];
    if (_tradeModel.type == 1) {
        statusIV.image = [UIImage imageNamed:@"recived"];
        sumLb.textColor = TEXT_GREEN_COLOR;
        sumLb.text = [NSString stringWithFormat:@"+%@ sec",_tradeModel.sum];
        statusLb.textColor = TEXT_GREEN_COLOR;
        statusLb.text = Localized(@"转入成功",nil);
    }else if (_tradeModel.type == 2) {
        statusIV.image = [UIImage imageNamed:@"sent"];
        sumLb.textColor = TEXT_GREEN_COLOR;
        sumLb.text = [NSString stringWithFormat:@"-%@ sec",_tradeModel.sum];
        statusLb.textColor = TEXT_GREEN_COLOR;
        statusLb.text = Localized(@"转出成功",nil);
    }else{
        statusIV.image = [UIImage imageNamed:@"minied"];
        sumLb.textColor = COLOR(253, 152, 0, 1);
        sumLb.text = [NSString stringWithFormat:@"+%@ sec",_tradeModel.sum];
        statusLb.textColor = COLOR(253, 152, 0, 1);
        statusLb.text = Localized(@"挖矿",nil);
    }
    if (_tradeModel.status == 0) {
        statusIV.image = [UIImage imageNamed:@"transferFailed"];
        sumLb.textColor = TEXT_RED_COLOR;
        statusLb.textColor = TEXT_RED_COLOR;
        statusLb.text = Localized(@"交易失败",nil);
    }
    if (_tradeModel.status == 2) {
        statusIV.image = [UIImage imageNamed:@"pending"];
        sumLb.textColor = COLOR(253, 152, 0, 1);
        statusLb.textColor = COLOR(253, 152, 0, 1);
        statusLb.text = Localized(@"交易打包中",nil);
    }
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.maxY, kScreenWidth, Size(185))];
    centerView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:centerView];
    NSArray *titleArr = @[Localized(@"发款方", nil),Localized(@"收款方", nil),Localized(@"矿工费用", nil),Localized(@"备注", nil)];
    NSArray *contentArr = @[_tradeModel.transferAddress,_tradeModel.gatherAddress,_tradeModel.gas,_tradeModel.tip];
    for (int i = 0; i< titleArr.count; i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.minX, Size(15) +i*Size(10 +20 +15), kScreenWidth -desLb.minX*2, Size(15))];
        titleLb.font = BoldSystemFontOfSize(11);
        titleLb.textColor = TEXT_BLACK_COLOR;
        titleLb.text = titleArr[i];
        [centerView addSubview:titleLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY, titleLb.width, Size(20))];
        contentLb.font = SystemFontOfSize(11);
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
        titleLb.font = BoldSystemFontOfSize(11);
        titleLb.textColor = TEXT_BLACK_COLOR;
        titleLb.text = titleArr1[i];
        [bottomView addSubview:titleLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.maxX, titleLb.minY, kScreenWidth-Size(150)-desLb.minX*2, Size(25))];
        contentLb.font = SystemFontOfSize(11);
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
