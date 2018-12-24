//
//  WalletManageViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "WalletManageViewController.h"
#import "CommonTableViewCell.h"
#import "WalletModel.h"
#import "WalletDetailViewController.h"
#import "CreatWalletViewController.h"
#import "ImportWalletManageViewController.h"

@interface WalletManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrays;  //资产列表
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*************获取钱包信息*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    [_infoTableView reloadData];
    
    if (_dataArrays.count == 0) {
        CreatWalletViewController *viewController = [[CreatWalletViewController alloc] init];
        viewController.isNoBack = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:navi animated:YES completion:nil];
    }    
}
- (void)setupUI
{
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), 0, Size(200), Size(35))];
    titleLb.textColor = COLOR(70, 81, 85, 1);
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = @"Manage Wallet";
    [self.view addSubview:titleLb];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(Size(20), titleLb.maxY +Size(23), kScreenWidth -Size(20)*2, kScreenHeight-KNaviHeight -Size(35 +200 +5)) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:_infoTableView];
    
    //底部视图按钮
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight -Size(220), kScreenWidth, Size(220))];
    bottomView.backgroundColor = COLOR(244, 252, 250, 1);
    [self.view addSubview:bottomView];
    UIButton *importBT = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth/2 -Size(60))/2, Size(50), Size(60), Size(60))];
    importBT.titleLabel.font = BoldSystemFontOfSize(10);
    [importBT setImage:[UIImage imageNamed:@"wallet0"] forState:UIControlStateNormal];
    [importBT setTitleColor:COLOR(50, 66, 74, 1) forState:UIControlStateNormal];
    [importBT setTitle:@"Import Wallet" forState:UIControlStateNormal];
    importBT.titleEdgeInsets = UIEdgeInsetsMake(0, -importBT.imageView.frame.size.width, -importBT.imageView.frame.size.height-Size(20)/2, 0);
    importBT.imageEdgeInsets = UIEdgeInsetsMake(-importBT.titleLabel.intrinsicContentSize.height-Size(20)/2, 0, 0, -importBT.titleLabel.intrinsicContentSize.width);
    [importBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    importBT.tag = 1000;
    [bottomView addSubview:importBT];
    //描述
    UILabel *desLb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, importBT.maxY, kScreenWidth/2, Size(20))];
    desLb1.textAlignment = NSTextAlignmentCenter;
    desLb1.textColor = COLOR(137, 138, 141, 1);
    desLb1.font = SystemFontOfSize(8);
    desLb1.text = @"Import an existing SEC wallet";
    [bottomView addSubview:desLb1];
    UIButton *creatBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 +(kScreenWidth/2 -importBT.width)/2, importBT.minY, importBT.width, importBT.height)];
    creatBT.titleLabel.font = BoldSystemFontOfSize(10);
    [creatBT setImage:[UIImage imageNamed:@"wallet1"] forState:UIControlStateNormal];
    [creatBT setTitleColor:COLOR(50, 66, 74, 1) forState:UIControlStateNormal];
    [creatBT setTitle:@"Creat Wallet" forState:UIControlStateNormal];
    creatBT.titleEdgeInsets = UIEdgeInsetsMake(0, -creatBT.imageView.frame.size.width, -creatBT.imageView.frame.size.height-Size(20)/2, 0);
    creatBT.imageEdgeInsets = UIEdgeInsetsMake(-creatBT.titleLabel.intrinsicContentSize.height-Size(20)/2, 0, 0, -creatBT.titleLabel.intrinsicContentSize.width);
    [creatBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    creatBT.tag = 1001;
    [bottomView addSubview:creatBT];
    //描述
    UILabel *desLb2 = [[UILabel alloc] initWithFrame:CGRectMake(desLb1.maxX, desLb1.minY, desLb1.width, desLb1.height)];
    desLb2.textAlignment = NSTextAlignmentCenter;
    desLb2.textColor = COLOR(137, 138, 141, 1);
    desLb2.font = SystemFontOfSize(8);
    desLb2.text = @"Create a new SEC wallet";
    [bottomView addSubview:desLb2];
    
    //中间线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, importBT.minY, Size(0.5), Size(70))];
    line.backgroundColor = COLOR(198, 200, 201, 1);
    [bottomView addSubview:line];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.1f : Size(5);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = WHITE_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == _dataArrays.count ? Size(5) : 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = WHITE_COLOR;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //列表
    static NSString *itemCell = @"cell_item";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WalletModel *model = _dataArrays[indexPath.section];
    [cell fillCellWithObject:model];
    return cell;
    
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //钱包详情
    WalletDetailViewController *viewController = [[WalletDetailViewController alloc]init];
    viewController.walletModel = _dataArrays[indexPath.section];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            //导入钱包
        {
            ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 1001:
            //创建钱包
        {
            CreatWalletViewController *viewController = [[CreatWalletViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
