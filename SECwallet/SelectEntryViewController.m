//
//  SelectEntryViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "SelectEntryViewController.h"
#import "CreatWalletViewController.h"
#import "ImportWalletManageViewController.h"

@interface SelectEntryViewController ()

@end

@implementation SelectEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)initSubViews
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    topView.backgroundColor = COLOR(246, 252, 251, 1);
    [self.view addSubview:topView];
    UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(60), kScreenWidth, Size(35))];
    nameLb.font = BoldSystemFontOfSize(20);
    nameLb.textColor = TEXT_BLACK_COLOR;
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.text = Localized(@"SEC轻钱包", nil);
    [self.view addSubview:nameLb];
    
    UIButton *creatBT = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -Size(60))/2, nameLb.maxY+Size(55), Size(60), Size(60))];
    creatBT.titleLabel.font = BoldSystemFontOfSize(10);
    [creatBT setImage:[UIImage imageNamed:@"wallet1"] forState:UIControlStateNormal];
    [creatBT setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
    [creatBT setTitle:Localized(@"创建钱包",nil) forState:UIControlStateNormal];
    creatBT.titleEdgeInsets = UIEdgeInsetsMake(0, -creatBT.imageView.frame.size.width, -creatBT.imageView.frame.size.height-Size(20)/2, 0);
    creatBT.imageEdgeInsets = UIEdgeInsetsMake(-creatBT.titleLabel.intrinsicContentSize.height-Size(20)/2, 0, 0, -creatBT.titleLabel.intrinsicContentSize.width);
    [creatBT addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:creatBT];
    //描述
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(0, creatBT.maxY, kScreenWidth, Size(20))];
    desLb.textAlignment = NSTextAlignmentCenter;
    desLb.textColor = TEXT_DARK_COLOR;
    desLb.font = SystemFontOfSize(8);
    desLb.text = Localized(@"创建一个新钱包",nil);
    [topView addSubview:desLb];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.maxY, kScreenWidth, kScreenHeight/2)];
    bottomView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:bottomView];
    UIButton *importBT = [[UIButton alloc]initWithFrame:CGRectMake(creatBT.minX, Size(105), creatBT.width, creatBT.height)];
    importBT.titleLabel.font = BoldSystemFontOfSize(10);
    [importBT setImage:[UIImage imageNamed:@"wallet0"] forState:UIControlStateNormal];
    [importBT setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    [importBT setTitle:Localized(@"导入钱包",nil) forState:UIControlStateNormal];
    importBT.titleEdgeInsets = UIEdgeInsetsMake(0, -importBT.imageView.frame.size.width, -importBT.imageView.frame.size.height-Size(20)/2, 0);
    importBT.imageEdgeInsets = UIEdgeInsetsMake(-importBT.titleLabel.intrinsicContentSize.height-Size(20)/2, 0, 0, -importBT.titleLabel.intrinsicContentSize.width);
    [importBT addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:importBT];
    //描述
    UILabel *desLb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, importBT.maxY, kScreenWidth, desLb.height)];
    desLb1.textAlignment = NSTextAlignmentCenter;
    desLb1.textColor = TEXT_DARK_COLOR;
    desLb1.font = SystemFontOfSize(8);
    desLb1.text = Localized(@"导入一个已存在钱包",nil);
    [bottomView addSubview:desLb1];
    
}

#pragma mark 创建钱包
-(void)creatAction
{
    CreatWalletViewController *viewController = [[CreatWalletViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark 导入钱包
-(void)importAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
