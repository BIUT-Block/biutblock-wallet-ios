//
//  TradeListViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/13.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeListViewController.h"
#import "CommonTableViewCell.h"
#import "TradeModel.h"
#import "WalletModel.h"
#import "AssetsSwitchViewController.h"
#import "TradeInfoViewController.h"

#define KXHeight  (IS_iPhoneX ? 64 : 0)

@interface TradeListViewController()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *nameLb;
    BOOL isHeaderRefresh;
    NSMutableArray *_walletList;  //钱包列表
    NSMutableArray *_dataArrays;  //交易列表
    UIImageView *_noRemindView;
    
    UIView *_noNetworkView;
    BOOL connectNetwork;
    BOOL hasGetDataInfo;   //是否获取了数据
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) WalletModel *walletModel;

@end

@implementation TradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    [self addNoNetworkView];
    
    //网络监听
    [self networkManager];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    _walletList = [NSMutableArray array];
    _walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    _walletModel = _walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
    nameLb.text = _walletModel.walletName;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 延时加载，解决一个因为启动过快，AFN判断网络的类未启动完成导致判断网络无网络的Bug
        [self readTradeRecordListCache];
    });
}

-(void) readTradeRecordListCache
{
    /*************获取交易列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray *recodeList = [NSMutableArray array];
    recodeList = [unarchiver decodeObjectForKey:@"walletRecodeList"];
    [unarchiver finishDecoding];
    if (recodeList !=nil) {
        _dataArrays = [NSMutableArray arrayWithArray:recodeList];
        [_infoTableView reloadData];
    }else{
        [self requestTransactionList];
    }
}
- (void)addSubView
{
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), 0, Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"SEC交易记录",nil);
    [self.view addSubview:titleLb];
    
    //钱包名
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(5), Size(100), Size(10))];
    desLb.textColor = TEXT_LightDark_COLOR;
    desLb.font = SystemFontOfSize(8);
    desLb.text = Localized(@"钱包名称",nil);
    [self.view addSubview:desLb];
    nameLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.minX, desLb.maxY, Size(100), Size(30))];
    nameLb.textColor = TEXT_GREEN_COLOR;
    nameLb.font = BoldSystemFontOfSize(18);
    nameLb.text = _walletModel.walletName;
    [self.view addSubview:nameLb];
    //横线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(nameLb.minX, nameLb.maxY, kScreenWidth -nameLb.minX*2, Size(0.5))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line];
    UIView *greenLine = [[UIView alloc]initWithFrame:CGRectMake(line.minX, line.minY-Size(1.5 -0.5)/2, Size(60), Size(1.5))];
    greenLine.backgroundColor = TEXT_GREEN_COLOR;
    [self.view addSubview:greenLine];
    
    //交换钱包按钮
    UIButton *exchangeBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(65 +20), desLb.maxY-Size(2), Size(65), Size(25))];
    [exchangeBT greenBorderBtnStyle:Localized(@"切换钱包",nil) andBkgImg:@"continue"];
    [exchangeBT addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBT];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(Size(20), greenLine.maxY +Size(25), kScreenWidth -Size(20)*2, kScreenHeight-KNaviHeight -Size(105)) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = BACKGROUND_DARK_COLOR;
    //解决MJ控件IOS11刷新问题
    _infoTableView.estimatedRowHeight =0;
    _infoTableView.estimatedSectionHeaderHeight =0;
    _infoTableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:_infoTableView];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_infoTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (connectNetwork == YES) {
        isHeaderRefresh = YES;
        [_noRemindView removeFromSuperview];
        _isLoading  = NO;
        [self requestTransactionList];
    }else{
        [self hiddenRefreshView];
        _infoTableView.hidden = YES;
        self.view.backgroundColor = BACKGROUND_DARK_COLOR;
        _noNetworkView.hidden = NO;
    }
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_infoTableView.isHeaderHidden)
    {
        [_infoTableView headerEndRefreshing];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUND_DARK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Size(8);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(42);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCell = @"cell_item";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeModel *model = _dataArrays[indexPath.section];
    [cell fillCellWithObject:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel *model = _dataArrays[indexPath.section];
    TradeInfoViewController *viewController = [[TradeInfoViewController alloc] init];
    viewController.tradeModel = model;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 获取交易记录列表
-(void)requestTransactionList
{
    if (isHeaderRefresh == NO) {
        [self createLoadingView:nil];
    }
    //地址去掉0x
    NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
    [client invokeMethod:@"sec_getTransactions" withParameters:@[from] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger status = [dic[@"status"] integerValue];
        [self hiddenLoadingView];
        [self hiddenRefreshView];
        _dataArrays = [NSMutableArray array];
        if (status == 1) {
            NSArray *Chainlist = dic[@"resultInChain"];
            if (Chainlist.count > 0) {
                for (NSDictionary *dic in Chainlist) {
                    TradeModel *model = [[TradeModel alloc]initWithDictionary:dic walletAddress:from];
                    [_dataArrays addObject:model];
                }
            }
            NSArray *Poollist = dic[@"resultInPool"];
            if (Poollist.count > 0) {
                for (NSDictionary *dic in Poollist) {
                    TradeModel *model = [[TradeModel alloc]initWithDictionary:dic walletAddress:from];
                    [_dataArrays addObject:model];
                }
            }
            if (_dataArrays.count > 0) {
                /*************保存交易记录*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:_dataArrays forKey:@"walletRecodeList"];
                [archiver finishEncoding];
                [data writeToFile:path atomically:YES];
                [_noRemindView removeFromSuperview];
                [_infoTableView reloadData];
                
            }else{
                _dataArrays = [NSMutableArray array];
                [_infoTableView reloadData];
                [_noRemindView removeFromSuperview];
                _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2, Size(200), Size(200))];
                _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
                [_infoTableView addSubview:_noRemindView];
            }
            
        }else{
            
            _dataArrays = [NSMutableArray array];
            [_infoTableView reloadData];
            [_noRemindView removeFromSuperview];
            _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2 -KXHeight, Size(200), Size(200))];
            _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
            [_infoTableView addSubview:_noRemindView];
        }
        
        isHeaderRefresh = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hiddenLoadingView];
        [self hiddenRefreshView];
        _dataArrays = [NSMutableArray array];
        [_infoTableView reloadData];
        [_noRemindView removeFromSuperview];
        _noRemindView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -Size(200))/2, (kScreenHeight -Size(220))/2 -KXHeight, Size(200), Size(200))];
        _noRemindView.image = [UIImage imageNamed:@"noTradeInfoBkg"];
        [_infoTableView addSubview:_noRemindView];
    }];
}

#pragma 切换账户
-(void)exchangeAction
{
    AssetsSwitchViewController *viewController = [[AssetsSwitchViewController alloc]init];
    viewController.assetsList = _walletList;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 网络监听管理
- (void)networkManager
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _isLoading  = NO;
        [self hiddenRefreshView];
        if (status == 0) {
            //无网络视图
            connectNetwork = NO;
            _infoTableView.hidden = YES;
            [_noRemindView removeFromSuperview];
            self.view.backgroundColor = BACKGROUND_DARK_COLOR;
            _noNetworkView.hidden = NO;
        }else{
            connectNetwork = YES;
        }
    }];
}
-(void)addNoNetworkView
{
    _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, Size(8), kScreenWidth, kScreenHeight)];
    _noNetworkView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:_noNetworkView];
    _noNetworkView.hidden = YES;
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(150))/2, Size(120), Size(150), Size(120))];
    iv.image = [UIImage imageNamed:@"noNetwork"];
    [_noNetworkView addSubview:iv];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, iv.maxY +Size(30), kScreenWidth, Size(20))];
    lb.font = SystemFontOfSize(14);
    lb.textColor = TEXT_BLACK_COLOR;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"你的钱包掉～掉线了！";
    [_noNetworkView addSubview:lb];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -Size(100))/2, lb.maxY, Size(100), Size(30))];
    bt.titleLabel.font = SystemFontOfSize(14);
    [bt setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
    [bt setTitle:@"点击重试" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(refreshNetworkAction) forControlEvents:UIControlEventTouchUpInside];
    [_noNetworkView addSubview:bt];
}

-(void)refreshNetworkAction
{
    _isLoading  = NO;
    [self requestTransactionList];
}

@end
