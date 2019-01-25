//
//  MineViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonTableViewCell.h"
#import "WalletManageViewController.h"
#import "TradeListViewController.h"
#import "TokenCoinModel.h"
#import "AddressListViewController.h"
#import "RootViewController.h"

@interface SettingViewController ()
{
    int _updateType;     //1不升级  2升级 3强制升级
    NSString *APP_DownloadUrl;
    UIButton *remindBT;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = COLOR(243, 244, 245, 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //请求数据
        [self checkVersion];
    });
}
#pragma mark 版本检测
-(void)checkVersion
{
    NSURL *zoneUrl = [NSURL URLWithString:@"http://scan.secblock.io/publishversionapi"];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _updateType = [[dataDic objectForKey:@"status"] intValue];
        APP_DownloadUrl = [dataDic objectForKey:@"link"];
        NSString *versionName = [dataDic objectForKey:@"version"];
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ((_updateType == 2 || _updateType == 3) && ![versionName isEqualToString:app_Version]) {
            remindBT.hidden = NO;
        }else{
            remindBT.hidden = YES;
        }
    }else{
        remindBT.hidden = YES;
    }
}

- (void)addContentView
{
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(165))];
    headerView.image = [UIImage imageNamed:@"walletHomeBg"];
    [self.view addSubview:headerView];
    //标题
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(25), Size(55), kScreenWidth, Size(35))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.text = Localized(@"我的钱包",nil);
    [headerView addSubview:titLb];
    
    UIView *btView = [[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.maxY+Size(15), kScreenWidth, Size(122))];
    btView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:btView];
    
    NSArray *titArr = @[Localized(@"管理钱包",nil),Localized(@"交易记录",nil)];
    NSArray *imgArr = @[@"manageWalletIcon",@"tradeRecordIcon"];
    //快捷功能入口
    CGFloat btWidth = Size(45);
    CGFloat insert = (kScreenWidth -btWidth *imgArr.count)/(imgArr.count +2);
    for (int i = 0; i< titArr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(insert +(insert*2 +btWidth)*i, Size(122-70)/2, btWidth, btWidth-Size(3))];
        iv.image = [UIImage imageNamed:imgArr[i]];
        [btView addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(iv.minX -Size(50), iv.maxY, Size(150), Size(35))];
        lb.font = BoldSystemFontOfSize(11);
        lb.textColor = TEXT_BLACK_COLOR;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = titArr[i];
        [btView addSubview:lb];
        UIButton *lnkBtn = [[UIButton alloc]initWithFrame:CGRectMake(lb.minX, btView.minY +iv.minY, lb.width, btWidth+lb.height)];
        lnkBtn.tag = 1000+i;
        [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lnkBtn];
    }
    //中间线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, Size(20), Size(0.5), Size(122 -20 *2))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [btView addSubview:line];
    
    //地址薄
    CommonTableViewCell *addressCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addressCell.frame = CGRectMake(Size(20), btView.maxY +Size(52), kScreenWidth -Size(20 *2), Size(45));
    addressCell.contentView.backgroundColor = WHITE_COLOR;
    addressCell.smallIcon.image = [UIImage imageNamed:@"addressBook"];
    addressCell.staticTitleLb.text = Localized(@"地址薄",nil);
    addressCell.accessoryIV.image = [UIImage imageNamed:@"rightArrow"];
    [self.view addSubview:addressCell];
    UIButton *lnkBtn = [[UIButton alloc]initWithFrame:addressCell.frame];
    lnkBtn.tag = 1002;
    [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lnkBtn];
    
    //版本提示
    UILabel *versionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, addressCell.maxY +Size(40), kScreenWidth, Size(10))];
    versionLb.font = SystemFontOfSize(10);
    versionLb.textColor = TEXT_DARK_COLOR;
    versionLb.textAlignment = NSTextAlignmentCenter;
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLb.text = [NSString stringWithFormat:@"%@：V%@",Localized(@"版本号", nil),app_Version];
    [self.view addSubview:versionLb];
    remindBT = [[UIButton alloc]initWithFrame:CGRectMake(0, versionLb.maxY, kScreenWidth, Size(20))];
    remindBT.titleLabel.font = SystemFontOfSize(10);
    [remindBT setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    [remindBT setTitle:Localized(@"版本更新", nil) forState:UIControlStateNormal];
    [remindBT addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remindBT];
    remindBT.hidden = YES;
}

-(void)updateAction
{
    //升级跳转
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_DownloadUrl]];
    //立即重启
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}
#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            //管理钱包
        {
            WalletManageViewController *controller = [[WalletManageViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1001:
            //交易记录
        {
            TradeListViewController *controller = [[TradeListViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1002:
            //地址薄
        {
            AddressListViewController *controller = [[AddressListViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
