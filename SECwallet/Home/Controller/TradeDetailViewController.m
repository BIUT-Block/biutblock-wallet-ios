//
//  TradeDetailViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeListTableViewCell.h"
#import "TradeModel.h"
#import "TransferViewController.h"
#import "AddressCodePayViewController.h"
#import "TradeInfoViewController.h"

@interface TradeDetailViewController()<UITableViewDelegate,UITableViewDataSource,TransferViewControllerDelegate>
{
    BOOL isHeaderRefresh;
    NSMutableArray *_dataArrays;  //交易列表列表
    UIView *_noneListView;
    //转账
    UIButton *transferBT;
    //收款
    UIButton *gatherBT;
    
    UIView *_noNetworkView;
    BOOL connectNetwork;
    NSArray *recodeListCache;   //缓存的数据
}
@property (nonatomic, strong) UITableView *infoTableView;
@property(nonatomic, assign) NSInteger listCount;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubView];
    [self addNoNetworkView];
    [self readTradeRecordListCache];
    //网络监听
    [self networkManager];
    if (recodeListCache != nil) {
        _dataArrays = [NSMutableArray arrayWithArray:recodeListCache];
        [_infoTableView reloadData];
    }else{
        [self requestTransactionHash];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma TransferViewControllerDelegate 转账成功事件
//-(void)transferSuccess:(TokenCoinModel *)tokenCoinModel
//{
//    _tokenCoinModel = tokenCoinModel;
//    [self requestTransactionHash];
//}
-(void) readTradeRecordListCache
{
    /*************获取交易列表*************/
    NSString *fileName = [NSString stringWithFormat:@"recodeList_%@",_tokenCoinModel.name];
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    recodeListCache = [unarchiver decodeObjectForKey:fileName];
    [unarchiver finishDecoding];
}

- (void)addSubView
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];
    
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(10), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = [NSString stringWithFormat:@"SEC %@",Localized(@"收款",nil)];
    [self.view addSubview:titleLb];
    
    NSArray *titleArr = @[Localized(@"可用", nil),Localized(@"冻结", nil),Localized(@"总计", nil)];
    NSArray *contentArr = @[_walletModel.balance,_walletModel.balance,_walletModel.balance];
    NSArray *CNYArr = @[_walletModel.balance,_walletModel.balance,_walletModel.balance];
    for (int i = 0; i< titleArr.count; i++) {
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(20) +i*Size(35), Size(80), Size(35))];
        desLb.font = SystemFontOfSize(14);
        desLb.textColor = TEXT_BLACK_COLOR;
        desLb.text = titleArr[i];
        [self.view addSubview:desLb];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.maxX, desLb.minY+Size(5), kScreenWidth -desLb.minX*2 -desLb.width, (desLb.height-Size(5*2))/2)];
        contentLb.font = SystemFontOfSize(13);
        contentLb.textColor = TEXT_GREEN_COLOR;
        contentLb.textAlignment = NSTextAlignmentRight;
        contentLb.text = contentArr[i];
        [self.view addSubview:contentLb];
        UILabel *CNYLb = [[UILabel alloc]initWithFrame:CGRectMake(contentLb.minX, contentLb.maxY, contentLb.width, contentLb.height)];
        CNYLb.font = SystemFontOfSize(13);
        CNYLb.textColor = TEXT_DARK_COLOR;
        CNYLb.textAlignment = NSTextAlignmentRight;
        CNYLb.text = CNYArr[i];
        [self.view addSubview:CNYLb];
        //横线
        if (i!=2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth -desLb.minX*2, Size(0.5))];
            line.backgroundColor = DIVIDE_LINE_COLOR;
            [self.view addSubview:line];
        }
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLb.maxY +Size(20) +3*Size(35), kScreenWidth, Size(0.3))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line];
    
    UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, line.maxY+Size(15), Size(200), Size(25))];
    desLb.font = BoldSystemFontOfSize(12);
    desLb.textColor = TEXT_LightDark_COLOR;
    desLb.text = Localized(@"最近交易记录", nil);
    [self.view addSubview:desLb];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, desLb.maxY+Size(10), kScreenWidth, kScreenHeight -desLb.maxY-Size(10 +75)) style:UITableViewStylePlain];
    _infoTableView.showsVerticalScrollIndicator = NO;
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
    
    _noneListView = [[UIView alloc]initWithFrame:CGRectMake(0, _infoTableView.minY, kScreenWidth, _infoTableView.height)];
    [self.view addSubview:_noneListView];
    UIImageView *noneIV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(60))/2, Size(60), Size(60), Size(60))];
    noneIV.image = [UIImage imageNamed:@"noRecordFound"];
    [_noneListView addSubview:noneIV];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, noneIV.maxY, kScreenWidth, Size(40))];
    lb.font = BoldSystemFontOfSize(15);
    lb.textColor = COLOR(175, 176, 177, 1);
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = Localized(@"暂无记录", nil);
    [_noneListView addSubview:lb];
    _noneListView.hidden = YES;
    
    CGFloat padddingLeft = Size(20);
    CGFloat btWidth = (kScreenWidth -padddingLeft*2 -Size(10))/2;
    //转账
    transferBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, _infoTableView.maxY +Size(15), btWidth, Size(45))];
    [transferBT goldSmallBtnStyle:Localized(@"转账",nil)];
    [transferBT addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transferBT];
    //收款
    gatherBT = [[UIButton alloc] initWithFrame:CGRectMake(transferBT.maxX+Size(10), transferBT.minY, transferBT.width, transferBT.height)];
    [gatherBT customerBtnStyle:Localized(@"收款",nil) andBkgImg:@"receipt"];
    [gatherBT addTarget:self action:@selector(gatherAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gatherBT];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (connectNetwork == YES) {
        [self readTradeRecordListCache];
        isHeaderRefresh = YES;
        _noneListView.hidden = YES;
        _isLoading  = NO;
        [self requestTransactionHash];
    }else{
        [self hiddenRefreshView];
        _infoTableView.hidden = YES;
        transferBT.hidden = YES;
        gatherBT.hidden = YES;
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    TradeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[TradeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeModel *model = _dataArrays[indexPath.row];
    [cell fillCellWithObject:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel *model = _dataArrays[indexPath.row];
    TradeInfoViewController *viewController = [[TradeInfoViewController alloc] init];
    viewController.tradeModel = model;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 获取交易记录列表
-(void)requestTransactionHash
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
                NSString *fileName = [NSString stringWithFormat:@"recodeList_%@",_tokenCoinModel.name];
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:_dataArrays forKey:fileName];
                [archiver finishEncoding];
                [data writeToFile:path atomically:YES];
                _noneListView.hidden = YES;
                [_infoTableView reloadData];
                
                //当刷新出了新数据则弹出提示  recodeListCache
                if (_dataArrays.count > recodeListCache.count && isHeaderRefresh == YES) {
                    [self hudShowWithString:[NSString stringWithFormat:@"已更新%ld条数据",_dataArrays.count-recodeListCache.count] delayTime:3];
                }
                
            }else{
                _dataArrays = [NSMutableArray array];
                [_infoTableView reloadData];
                _noneListView.hidden = NO;
            }
            
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
            
        }else{
            _dataArrays = [NSMutableArray array];
            [_infoTableView reloadData];
            _noneListView.hidden = NO;
            
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
        }
        isHeaderRefresh = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取区块详情失败");
        [self hiddenLoadingView];
        [self hiddenRefreshView];
    }];
}

#pragma 转账
-(void)transferAction
{
    TransferViewController *viewController = [[TransferViewController alloc] init];
    viewController.tokenCoinModel = _tokenCoinModel;
    viewController.walletModel = _walletModel;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma 收款
-(void)gatherAction
{
    AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
    viewController.walletModel = _walletModel;
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
            connectNetwork = NO;
            //无网络视图
            if (recodeListCache == nil) {
                _infoTableView.hidden = YES;
                transferBT.hidden = YES;
                gatherBT.hidden = YES;
                _noNetworkView.hidden = NO;
            }
        }else{
            connectNetwork = YES;
            _infoTableView.hidden = NO;
            transferBT.hidden = NO;
            gatherBT.hidden = NO;
            _noNetworkView.hidden = YES;
        }
    }];
}

-(void)addNoNetworkView
{
    _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, -Size(20), kScreenWidth, kScreenHeight)];
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
    [self requestTransactionHash];
}

@end
