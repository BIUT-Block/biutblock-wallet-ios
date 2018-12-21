//
//  MineViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "SettingViewController.h"
#import "WalletManageViewController.h"
#import "TradeListViewController.h"
#import "TokenCoinModel.h"
#import "AddressListViewController.h"

@interface SettingViewController ()

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
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowTabView object:nil];
}

- (void)addContentView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2 +Size(20))];
    headerView.backgroundColor = COLOR(244, 252, 250, 1);
    [self.view addSubview:headerView];
    //标题
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(25), Size(55), kScreenWidth, Size(30))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = COLOR(70, 81, 85, 1);
    titLb.text = @"我的钱包";
    [headerView addSubview:titLb];
    //收款，扫一扫
    NSArray *titArr = @[@"管理钱包",@"交易记录"];
    NSArray *imgArr = @[@"manageWalletIcon",@"tradeRecordIcon"];
    //快捷功能入口
    CGFloat btWidth = Size(45);
    CGFloat insert = (kScreenWidth -btWidth *imgArr.count)/(imgArr.count +2);
    for (int i = 0; i< titArr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(insert +(insert*2 +btWidth)*i, titLb.maxY +Size(70), btWidth, btWidth)];
        iv.image = [UIImage imageNamed:imgArr[i]];
        [headerView addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(iv.minX -Size(18), iv.maxY, Size(80), Size(35))];
        lb.font = SystemFontOfSize(16);
        lb.textColor = COLOR(50, 66, 74, 1);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = titArr[i];
        [headerView addSubview:lb];
        
        UIButton *lnkBtn = [[UIButton alloc]initWithFrame:iv.frame];
        lnkBtn.tag = 1000+i;
        [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:lnkBtn];
    }
    //中间线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, titLb.maxY +Size(60), Size(0.5), Size(90))];
    line.backgroundColor = COLOR(198, 200, 201, 1);
    [headerView addSubview:line];
    
    //地址薄
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(Size(20), headerView.maxY +Size(35), kScreenWidth -Size(20 *2), Size(40));
    cell.backgroundColor = COLOR(245, 246, 247, 1);
    cell.layer.cornerRadius = Size(10);
    [self.view addSubview:cell];
    cell.imageView.image = [UIImage imageNamed:@"addressBook"];
    cell.textLabel.font = SystemFontOfSize(12);
    cell.textLabel.textColor = COLOR(50, 66, 74, 1);
    cell.textLabel.text = @"地址薄";
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory_right"]];
    UIButton *lnkBtn = [[UIButton alloc]initWithFrame:cell.frame];
    lnkBtn.tag = 1002;
    [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lnkBtn];
    
    //版本提示
    UILabel *versionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.maxY +Size(50), kScreenWidth, Size(10))];
    versionLb.font = SystemFontOfSize(10);
    versionLb.textColor = COLOR(159, 160, 162, 1);
    versionLb.textAlignment = NSTextAlignmentCenter;
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLb.text = [NSString stringWithFormat:@"V%@",app_Version];;
    [self.view addSubview:versionLb];
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(0, versionLb.maxY, kScreenWidth, Size(10))];
    remindLb.font = SystemFontOfSize(10);
    remindLb.textColor = COLOR(159, 160, 162, 1);
    remindLb.textAlignment = NSTextAlignmentCenter;
    remindLb.text = @"New Version Update";
    [self.view addSubview:remindLb];
    
}

#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHiddenTabView object:nil];
    switch (sender.tag) {
        case 1000:
            //管理钱包
        {
            WalletManageViewController *controller = [[WalletManageViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1001:
            //交易记录
        {
            TradeListViewController *controller = [[TradeListViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1002:
            //地址薄
        {
            AddressListViewController *controller = [[AddressListViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
