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

#import "WalletListCollectionViewCell.h"
#import "WalletListFlowLayout.h"
#import "CommonPageControl.h"
#import "JXMovableCellTableView.h"

#import "BackupRemindViewController.h"

#define kHeaderHeight    Size(195)

@interface AssetsViewController ()<JXMovableCellTableViewDataSource,JXMovableCellTableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *_walletList;  //钱包列表
    WalletModel *currentWallet;
    
    NSMutableArray *_dataArrays;  //资产列表
    NSString *tokenCoin_CNY;    //代币(ETH)对人民币汇率
    
    NSMutableArray *assetsList;
    
    UIButton *noNetworkBT;
    BOOL connectNet;
    
    BOOL fromNotifi;
    UIButton *moreBT;
}

@property (nonatomic,strong) UICollectionView *walletListView;
@property (nonatomic,strong) CommonPageControl *pageControl;
@property (nonatomic, strong) JXMovableCellTableView *infoTableView;

@end

@implementation AssetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self refreshWallet:[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] clearCache:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = COLOR(241, 242, 243, 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //网络监听
        [self networkManager];
    });
}

//刷新页面数据
-(void)updateData
{
    fromNotifi = YES;
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    currentWallet = _walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
    [_walletListView reloadData];
    
    [self refreshWallet:[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] clearCache:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue] inSection:0];
    [_walletListView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _pageControl.numberOfPages = _walletList.count;
    _pageControl.currentPage = [[AppDefaultUtil sharedInstance].defaultWalletIndex intValue];
    fromNotifi = NO;
}

- (void)addSubView
{
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(165))];
    headerView.image = [UIImage imageNamed:@"walletHomeBg"];
    [self.view addSubview:headerView];
    
    moreBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -Size(25 +20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [moreBT addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [moreBT setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.view addSubview:moreBT];

    UICollectionViewFlowLayout *layout = [[WalletListFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = Size(10);   //列间距
    layout.minimumInteritemSpacing = Size(5);  //item之间的间距
    layout.itemSize = CGSizeMake(kScreenWidth-Size(40), kHeaderHeight-Size(35));
    _walletListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNaviHeight, kScreenWidth, kHeaderHeight -Size(35)) collectionViewLayout:layout];
    [_walletListView registerClass:[WalletListCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    _walletListView.backgroundColor = CLEAR_COLOR;
    _walletListView.showsHorizontalScrollIndicator = NO;
    _walletListView.delegate = self;
    _walletListView.dataSource = self;
    [self.view addSubview:_walletListView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue] inSection:0];
    [_walletListView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _pageControl = [[CommonPageControl alloc]initWithFrame:CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36))];
    _pageControl.numberOfPages = _walletList.count;
    [_pageControl setPageIndicatorTintColor:COLOR(215, 216, 217, 1)];
    [_pageControl setCurrentPageIndicatorTintColor:TEXT_GREEN_COLOR];
    [self.view addSubview:_pageControl];
    _pageControl.currentPage = [[AppDefaultUtil sharedInstance].defaultWalletIndex intValue];
    
    _infoTableView = [[JXMovableCellTableView alloc]initWithFrame:CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight) style:UITableViewStyleGrouped];
    _infoTableView.backgroundColor = CLEAR_COLOR;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.longPressGesture.minimumPressDuration = 0.5;
    [self.view addSubview:_infoTableView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _walletList.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_walletList.count == 1) {
        return UIEdgeInsetsMake(0, Size(25), 0, Size(25));
    }else{
        return UIEdgeInsetsMake(0, Size(20), 0, Size(20));
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalletListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    WalletModel *model = _walletList[indexPath.row];
    cell.bkgIV.image = [UIImage imageNamed:@"walletBkg0"];
    cell.nameLb.text = model.walletName;
    cell.totalSumLb.text = [NSString stringWithFormat:@"%@",model.balance];
    [cell.addressBT setTitle:[NSString addressToAsterisk:model.address] forState:UIControlStateNormal];
    cell.addressBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cell.addressBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addressBT.tag = 1000;
    //备份按钮
    [cell.backupBT setTitle:Localized(@"请备份", nil) forState:UIControlStateNormal];
    if (model.isBackUpMnemonic == NO) {
        cell.backupBT.hidden = NO;
        cell.backupBT.tag = 1001;
        [cell.backupBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.backupBT.hidden = YES;
    }
    [cell.codeBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.codeBT.tag = 1000;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalletDetailViewController *viewController = [[WalletDetailViewController alloc]init];
    viewController.walletModel = currentWallet;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x+_walletListView.width/2)/(kScreenWidth -Size(40));
    _pageControl.currentPage = index;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isMemberOfClass:[JXMovableCellTableView class]]) {
        int index = (scrollView.contentOffset.x+_walletListView.width/2)/(kScreenWidth -Size(40)+Size(5));
        [self refreshWallet:index clearCache:YES];
    }
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
    return Size(42)+ Size(1.5*2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //代币列表
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = Size(5);
    cell.backgroundColor = COLOR(242, 243, 244, 1);
    cell.textLabel.font = BoldSystemFontOfSize(12);
    cell.textLabel.textColor = TEXT_BLACK_COLOR;
    cell.textLabel.backgroundColor = BACKGROUND_DARK_COLOR;
    cell.detailTextLabel.font = BoldSystemFontOfSize(12);
    cell.detailTextLabel.textColor = TEXT_BLACK_COLOR;
    cell.detailTextLabel.backgroundColor = BACKGROUND_DARK_COLOR;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Size(1.5), kScreenWidth -Size(20 *2),Size(42))];
    contentView.backgroundColor = BACKGROUND_DARK_COLOR;
    contentView.layer.cornerRadius = Size(5);
    [cell.contentView addSubview:contentView];
    [cell.contentView sendSubviewToBack:contentView];
    TokenCoinModel *model = _dataArrays[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.tokenNum;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //资产详情
    TradeDetailViewController *viewController = [[TradeDetailViewController alloc]init];
    TokenCoinModel *model = _dataArrays[indexPath.section];
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
    [_dataArrays exchangeObjectAtIndex:fromIndexPath.section withObjectAtIndex:toIndexPath.section];
    //改变tokenIconList的排序
    NSMutableArray *coinlist = [NSMutableArray arrayWithArray:currentWallet.tokenCoinList];
    TokenCoinModel *coinModel = _dataArrays[toIndexPath.section];
    [coinlist removeObjectAtIndex:fromIndexPath.section];
    [coinlist insertObject:coinModel.name atIndex:toIndexPath.section];
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
        if ([model.privateKey isEqualToString:currentWallet.privateKey]) {
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
    AssetsSwitchViewController *viewController = [[AssetsSwitchViewController alloc]init];
    viewController.assetsList = assetsList;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
//    BackupRemindViewController *viewController = [[BackupRemindViewController alloc]init];
//    viewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
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

    if (fromNotifi == NO) {
        [self createLoadingView:nil];
    }
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
            if ([model.privateKey isEqualToString:currentWallet.privateKey]) {
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

        _walletListView.frame = CGRectMake(0, KNaviHeight, kScreenWidth, kHeaderHeight -Size(35));
        _pageControl.frame = CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36));
        _infoTableView.frame = CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight);
        [_walletListView reloadData];
        /*************获取钱包代币信息*************/
        TokenCoinModel *model = [[TokenCoinModel alloc]init];
        model.icon = @"SEC";
        model.name = @"SEC";
        model.tokenNum = currentWallet.balance;
        _dataArrays = [NSMutableArray arrayWithObject:model];
        [_infoTableView reloadData];
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hiddenLoadingView];
        [self hudShowWithString:Localized(@"数据获取失败", nil) delayTime:2];
        if (connectNet == 0) {
            noNetworkBT.hidden = NO;
            _walletListView.frame = CGRectMake(0, noNetworkBT.maxY, kScreenWidth, kHeaderHeight-Size(35));
            _pageControl.frame = CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36));
            _infoTableView.frame = CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight);
        }else{
            noNetworkBT.hidden = YES;
            _walletListView.frame = CGRectMake(0, KNaviHeight, kScreenWidth, kHeaderHeight -Size(35));
            _pageControl.frame = CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36));
            _infoTableView.frame = CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight);
        }
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
            connectNet = NO;
            noNetworkBT.hidden = NO;
            _walletListView.frame = CGRectMake(0, noNetworkBT.maxY, kScreenWidth, kHeaderHeight-Size(35));
            _pageControl.frame = CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36));
            _infoTableView.frame = CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight);
        }else{
            connectNet = YES;
            noNetworkBT.hidden = YES;
            _walletListView.frame = CGRectMake(0, KNaviHeight, kScreenWidth, kHeaderHeight -Size(35));
            _pageControl.frame = CGRectMake(0, _walletListView.maxY, kScreenWidth, Size(36));
            _infoTableView.frame = CGRectMake(Size(20), _pageControl.maxY, kScreenWidth -Size(20 +20), kScreenHeight-kHeaderHeight-KTabbarHeight);
        }
    }];
}
-(void)addNoNetworkView
{
    //提示视图
    noNetworkBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KNaviHeight, kScreenWidth -Size(40), Size(34))];
    noNetworkBT.userInteractionEnabled = NO;
    [noNetworkBT setBackgroundImage:[UIImage imageNamed:@"networkHeader"] forState:UIControlStateNormal];
    noNetworkBT.titleLabel.font = SystemFontOfSize(10);
    [noNetworkBT setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    [noNetworkBT setTitle:[NSString stringWithFormat:@"  %@",Localized(@"当前没有网络连接", nil)] forState:UIControlStateNormal];
    [self.view addSubview:noNetworkBT];
    noNetworkBT.hidden = YES;
}

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
            viewController.walletModel = currentWallet;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 1001:
        {
            WalletDetailViewController *viewController = [[WalletDetailViewController alloc]init];
            viewController.walletModel = currentWallet;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
