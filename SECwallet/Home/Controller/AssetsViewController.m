//
//  HomeViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "AssetsViewController.h"
#import "WalletModel.h"
#import "TokenCoinModel.h"
#import "AssetsSwitchViewController.h"
#import "AddressCodePayViewController.h"
#import "TradeDetailViewController.h"
#import "TokenCoinListViewController.h"
#import "WalletDetailViewController.h"
#import <ethers/ethers.h>

#import "CardPageView.h"
#import "JXMovableCellTableView.h"

#define kHeaderHeight    Size(200)
#define USD_to_CNY       6.8872

@interface AssetsViewController ()<JXMovableCellTableViewDataSource,JXMovableCellTableViewDelegate,CardPageViewDelegate>
{
    NSMutableArray *_walletList;  //钱包列表
    WalletModel *currentWallet;
    
    NSMutableArray *_dataArrays;  //资产列表
    NSString *tokenCoin_CNY;    //代币(ETH)对人民币汇率
    
    NSMutableArray *assetsList;
    
    UIButton *noNetworkBT;
    BOOL hasGetDataInfo;   //是否获取了数据
    
}

@property (nonatomic, strong) CardPageView *walletListPageView;   //钱包列表滚动视图
@property (nonatomic, strong) JXMovableCellTableView *infoTableView;

@end

@implementation AssetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavgationRightImage:[UIImage imageNamed:@"more"] withAction:@selector(rightClick)];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    currentWallet = _walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];

    [self addSubView];
    [self addNoNetworkView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:NotificationUpdateWalletPageView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:NotificationUpdateWalletInfoUI object:nil];
    
    if (_walletList.count > 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
    }
    
//    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"Input Password" contentText:@"Invalid Password.\nPlease Check and try again." imageName:@"exclamation_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_exclamation_mark];
    
//    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"Are you sure" contentText:@"The order of the mnemonics you backed up is verified correctly,\nwhether the mnemonic is removed for the SEC" imageName:@"question_mark" leftButtonTitle:@"Cancel" rightButtonTitle:@"Sure" alertViewType:CommonAlertViewType_question_mark];
    
//    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"Create Wallet" contentText:@"Wallet create successfully" imageName:@"Check_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_Check_mark];
    
//    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"No screenshot，Please!" contentText:@"If someone gets your mnemonic,it will get your assets directly!\nPlease copy the mnemonic and store it in a safe place." imageName:nil leftButtonTitle:@"Got It" rightButtonTitle:nil alertViewType:CommonAlertViewType_remind];
    
//    [alert show];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //网络监听
        [self networkManager];
    });
    /***********获取当前钱包信息***********/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    if (list.count == 1) {
        [self refreshWallet:0 clearCache:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowTabView object:nil];
}

//刷新页面数据
-(void)updateData
{
    //清除记录缓存
    [CacheUtil clearTokenCoinTradeListCacheFile];
    [self refreshWallet:[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] clearCache:YES];
}

//刷新页面
-(void)updateUI
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    currentWallet = _walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self addSubView];
    [self addNoNetworkView];
}

- (void)addSubView
{
    _walletListPageView = [[CardPageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight) withWalletList:_walletList];
    _walletListPageView.delegate = self;
    [self.view addSubview:_walletListPageView];
    
    _infoTableView = [[JXMovableCellTableView alloc]initWithFrame:CGRectMake(Size(20), _walletListPageView.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight) style:UITableViewStylePlain];
    _infoTableView.showsVerticalScrollIndicator = NO;
//    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.longPressGesture.minimumPressDuration = 0.5;
    [self.view addSubview:_infoTableView];
}

#pragma mark - JXMovableCellTableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrays.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(35);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //代币列表
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SystemFontOfSize(10);
    cell.textLabel.textColor = COLOR(0, 209, 70, 1);
    
    UIImageView *bkgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _infoTableView.width, Size(35))];
    bkgIV.image = [UIImage imageNamed:@"tokenListBkg"];
    [cell.contentView addSubview:bkgIV];
//    TokenCoinModel *model = _dataArrays[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:model.icon];
//    cell.textLabel.text = model.name;
//    //金额
//    CGSize size = [model.tokenNum calculateSize:SystemFontOfSize(10) maxWidth:_infoTableView.width/2];
//    if (size.width < Size(35)) {
//        size.width = Size(35);
//    }
//    UIButton *sumBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -Size(20 +15) -(size.width +Size(10) +Size(15)), Size(35 -16)/2, size.width, Size(16))];
//    sumBT.layer.borderWidth = Size(0.5);
//    sumBT.layer.borderColor = COLOR(0, 209, 70, 1).CGColor;
//    sumBT.layer.cornerRadius = Size(8);
//    sumBT.titleLabel.font = SystemFontOfSize(10);
//    [sumBT setTitleColor:COLOR(0, 209, 70, 1) forState:UIControlStateNormal];
//    [sumBT setTitle:[NSString stringWithFormat:@"%.2f",[model.tokenNum floatValue]] forState:UIControlStateNormal];
//    [cell.contentView addSubview:sumBT];
    
    return cell;
}

#pragma mark - JXMovableCellTableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHiddenTabView object:nil];

    //资产详情
    TradeDetailViewController *viewController = [[TradeDetailViewController alloc]init];
    TokenCoinModel *model = _dataArrays[indexPath.row];
    viewController.tokenCoinModel = model;
    viewController.walletModel = currentWallet;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 选择编辑模式，添加模式很少用,默认是删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 排序 当移动了某一行时候会调用
- (void)tableView:(JXMovableCellTableView *)tableView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // 移动cell之后更换数据数组里的循序
    [_dataArrays exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    //改变tokenIconList的排序
    NSMutableArray *coinlist = [NSMutableArray arrayWithArray:currentWallet.tokenCoinList];
    TokenCoinModel *coinModel = _dataArrays[toIndexPath.row];
    [coinlist removeObjectAtIndex:fromIndexPath.row];
    [coinlist insertObject:coinModel.name atIndex:toIndexPath.row];
    [currentWallet setTokenCoinList:coinlist];
    
    /***********获取当前钱包信息***********/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    /***********更新当前钱包信息***********/
    for (int i = 0; i< list.count; i++) {
        WalletModel *model = list[i];
        if ([model.walletName isEqualToString:currentWallet.walletName]) {
            [list replaceObjectAtIndex:i withObject:currentWallet];
        }
    }
    //替换list中当前钱包信息
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:list forKey:@"walletList"];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

#pragma mark - 快捷功能入口点击
-(void)rightClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHiddenTabView object:nil];

    AssetsSwitchViewController *viewController = [[AssetsSwitchViewController alloc]init];
    viewController.assetsList = assetsList;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - CardPageViewDelegate
-(void)backUpMnemonicAction
{
    WalletDetailViewController *viewController = [[WalletDetailViewController alloc]init];
    viewController.walletModel = currentWallet;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)showAddressCodeAction
{
    AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
    viewController.walletModel = currentWallet;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)addTokenCoinAction
{
    TokenCoinListViewController *viewController = [[TokenCoinListViewController alloc]init];
    viewController.walletModel = currentWallet;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)refreshWallet:(int)page clearCache:(BOOL)clearCache
{
    /***********更新当前选中的钱包位置信息***********/
    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%d",page]];
    //清除记录缓存
    if (clearCache == YES) {
        [CacheUtil clearTokenCoinTradeListCacheFile];
    }
    
    //重新获取钱包
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    currentWallet = _walletList[page];
    assetsList = _walletList;
    
    [self createLoadingView:nil];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
    //地址去掉0x
    NSString *from = [currentWallet.address componentsSeparatedByString:@"x"].lastObject;
    [client invokeMethod:@"sec_getBalance" withParameters:@[from,@"latest"] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        noNetworkBT.hidden = YES;
        [self hiddenLoadingView];
        NSDictionary *dic = responseObject;
        NSInteger status = [dic[@"status"] integerValue];
        NSString *balance;
        if (status == 1) {
            balance = [NSString jsonUtils:dic[@"value"]];
        }else{
            balance = @"0";
        }
        //获取需要的数据
        [currentWallet setBalance:balance];
        //更新当前钱包余额
        for (int i = 0; i< _walletList.count; i++) {
            WalletModel *model = _walletList[i];
            if ([model.walletName isEqualToString:currentWallet.walletName]) {
                [_walletList replaceObjectAtIndex:i withObject:currentWallet];
                break;
            }
        }
        //替换list中当前钱包信息
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:_walletList forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        
        /*************获取钱包代币信息*************/
        TokenCoinModel *model = [[TokenCoinModel alloc]init];
        model.icon = @"SEC";
        model.name = @"SEC";
        model.tokenNum = currentWallet.balance;
        _dataArrays = [NSMutableArray arrayWithObject:model];
        if (assetsList.count == 1) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            [self addSubView];
            [self addNoNetworkView];
        }else{
            [_infoTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hiddenLoadingView];
        [self hudShowWithString:@"数据获取失败" delayTime:1.5];
    }];
}

#pragma mark - 网络监听管理
- (void)networkManager
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _isLoading  = NO;
        [self hiddenLoadingView];
        if (status == 0) {
            //无网络视图
            noNetworkBT.hidden = NO;
        }else{
            noNetworkBT.hidden = YES;
        }
    }];
}
-(void)addNoNetworkView
{
    //提示视图
    noNetworkBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(20))];
    noNetworkBT.userInteractionEnabled = NO;
    [noNetworkBT setBackgroundColor:CLEAR_COLOR];
    [noNetworkBT setBackgroundImage:[UIImage imageNamed:@"noNetworkTip"] forState:UIControlStateNormal];
    [self.view addSubview:noNetworkBT];
    noNetworkBT.hidden = YES;
}

@end
