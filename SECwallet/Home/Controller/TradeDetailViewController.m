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
    UILabel *secSumLb;
    UILabel *secCNYLb;
    UILabel *frozenLb;
    UILabel *frozenCNYLb;
    UILabel *amountLb;
    UILabel *amountCNYLb;
    
    BOOL isHeaderRefresh;
    NSMutableArray *_dataArrays;  //交易列表列表
    UIView *_noneListView;
    UIButton *transferBT;
    UIButton *gatherBT;
    
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
    [self readTradeRecordListCache];
    //网络监听
    [self networkManager];
    if (recodeListCache != nil) {
        _dataArrays = [NSMutableArray arrayWithArray:recodeListCache];
        //计算代币总额,冻结资产
        [self calculateSum:_dataArrays];
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
    [self requestSECblance];
}
-(void)requestSECblance
{
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
    //地址去掉0x
    NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
    [client invokeMethod:@"sec_getBalance" withParameters:@[from,@"latest"] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            _walletModel.balance = [NSString jsonUtils:dic[@"value"]];
        }else{
            _walletModel.balance = @"0";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudShowWithString:Localized(@"数据获取失败", nil) delayTime:1.5];
    }];
}

#pragma TransferViewControllerDelegate 转账成功事件
-(void)transferSuccess:(TokenCoinModel *)tokenCoinModel
{
//    _tokenCoinModel = tokenCoinModel;
    [self requestTransactionHash];
}
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
    NSArray *contentArr = @[_walletModel.balance,@"",_walletModel.balance];
    NSArray *CNYArr = @[_walletModel.balance,@"",_walletModel.balance];
    for (int i = 0; i< titleArr.count; i++) {
        UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(20) +i*Size(35), Size(80), Size(35))];
        desLb.font = SystemFontOfSize(14);
        desLb.textColor = TEXT_BLACK_COLOR;
        desLb.text = titleArr[i];
        [self.view addSubview:desLb];
        if (i == 0) {
            secSumLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.maxX, desLb.minY+Size(5), kScreenWidth -desLb.minX*2 -desLb.width, (desLb.height-Size(5*2))/2)];
            secSumLb.font = SystemFontOfSize(13);
            secSumLb.textColor = TEXT_GREEN_COLOR;
            secSumLb.textAlignment = NSTextAlignmentRight;
            secSumLb.text = contentArr[i];
            [self.view addSubview:secSumLb];
            secCNYLb = [[UILabel alloc]initWithFrame:CGRectMake(secSumLb.minX, secSumLb.maxY, secSumLb.width, secSumLb.height)];
            secCNYLb.font = SystemFontOfSize(13);
            secCNYLb.textColor = TEXT_DARK_COLOR;
            secCNYLb.textAlignment = NSTextAlignmentRight;
            secCNYLb.text = CNYArr[i];
            [self.view addSubview:secCNYLb];
        }else if (i == 1) {
            frozenLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.maxX, desLb.minY+Size(5), kScreenWidth -desLb.minX*2 -desLb.width, (desLb.height-Size(5*2))/2)];
            frozenLb.font = SystemFontOfSize(13);
            frozenLb.textColor = TEXT_GREEN_COLOR;
            frozenLb.textAlignment = NSTextAlignmentRight;
            frozenLb.text = contentArr[i];
            [self.view addSubview:frozenLb];
            frozenCNYLb = [[UILabel alloc]initWithFrame:CGRectMake(frozenLb.minX, frozenLb.maxY, frozenLb.width, frozenLb.height)];
            frozenCNYLb.font = SystemFontOfSize(13);
            frozenCNYLb.textColor = TEXT_DARK_COLOR;
            frozenCNYLb.textAlignment = NSTextAlignmentRight;
            frozenCNYLb.text = CNYArr[i];
            [self.view addSubview:frozenCNYLb];
        }else if (i == 2) {
            amountLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.maxX, desLb.minY+Size(5), kScreenWidth -desLb.minX*2 -desLb.width, (desLb.height-Size(5*2))/2)];
            amountLb.font = SystemFontOfSize(13);
            amountLb.textColor = TEXT_GREEN_COLOR;
            amountLb.textAlignment = NSTextAlignmentRight;
            amountLb.text = contentArr[i];
            [self.view addSubview:amountLb];
            amountCNYLb = [[UILabel alloc]initWithFrame:CGRectMake(amountLb.minX, amountLb.maxY, amountLb.width, amountLb.height)];
            amountCNYLb.font = SystemFontOfSize(13);
            amountCNYLb.textColor = TEXT_DARK_COLOR;
            amountCNYLb.textAlignment = NSTextAlignmentRight;
            amountCNYLb.text = CNYArr[i];
            [self.view addSubview:amountCNYLb];
        }
        
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
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"链接错误", nil) contentText:Localized(@"暂无网络链接", nil) imageName:@"networkError" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"重试", nil) alertViewType:CommonAlertViewType_exclamation_mark];
        [alert show];
        alert.rightBlock = ^() {
            [self refreshNetworkAction];
        };
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
                
                //计算代币总额,冻结资产
                [self calculateSum:_dataArrays];
                
            }else{
                _dataArrays = [NSMutableArray array];
                [_infoTableView reloadData];
                _noneListView.hidden = NO;
            }
            
        }else{
            _dataArrays = [NSMutableArray array];
            [_infoTableView reloadData];
            _noneListView.hidden = NO;
        }
        isHeaderRefresh = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudShowWithString:Localized(@"数据获取失败", nil) delayTime:4.5];
        [self hiddenLoadingView];
        [self hiddenRefreshView];
    }];
}

-(void)calculateSum:(NSArray *)dataArrays
{
    //冻结资产
    CGFloat frozenSum = 0;
    for (TradeModel *model in dataArrays) {
        if (model.status == 2) {
            if (model.type == 1) {
                frozenSum += [model.sum doubleValue];
            }else{
                frozenSum -= [model.sum doubleValue];
            }
        }
    }
    secSumLb.text = [NSString stringWithFormat:@"%.8f",[_walletModel.balance doubleValue]];
    secCNYLb.text = [NSString stringWithFormat:@"%.8f",[_walletModel.balance doubleValue]];
    frozenLb.text = [NSString stringWithFormat:@"%.8f",frozenSum];
    frozenCNYLb.text = [NSString stringWithFormat:@"%.8f",frozenSum];
    amountLb.text = [NSString stringWithFormat:@"%.8f",[_walletModel.balance doubleValue]+frozenSum];
    amountCNYLb.text = [NSString stringWithFormat:@"%.8f",[_walletModel.balance doubleValue]+frozenSum];
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
            [self hiddenLoadingView];
            [self hiddenRefreshView];
            //无网络视图
            if (recodeListCache == nil) {
                CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"链接错误", nil) contentText:Localized(@"暂无网络链接", nil) imageName:@"networkError" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"重试", nil) alertViewType:CommonAlertViewType_exclamation_mark];
                [alert show];
                alert.rightBlock = ^() {
                    [self refreshNetworkAction];
                };
            }
        }else{
            connectNetwork = YES;
        }
    }];
}

-(void)refreshNetworkAction
{
    _isLoading  = NO;
    [self requestTransactionHash];
}

@end
