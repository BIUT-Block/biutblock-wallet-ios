//
//  AssetsSwitchViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/14.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "AssetsSwitchViewController.h"
#import "CommonTableViewCell.h"
#import "WalletModel.h"

@interface AssetsSwitchViewController()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrays;  //列表列表
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation AssetsSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArrays = [NSMutableArray array];
    [self addSubView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavgationLeftImage:[UIImage imageNamed:@"backIcon"] withAction:@selector(backAction)];
}

- (void)addSubView
{
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), 0, Size(200), Size(35))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"切换账户",nil);
    [self.view addSubview:titleLb];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(Size(20), titleLb.maxY +Size(23), kScreenWidth-Size(20)*2, kScreenHeight -KNaviHeight-titleLb.maxY) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:_infoTableView];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //如果默认钱包位置大于9，则让cell自动滚动到默认钱包位置
    if ([[AppDefaultUtil sharedInstance].defaultWalletIndex intValue] > 8) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
            [_infoTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
    return _assetsList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Size(10);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUND_DARK_COLOR;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(42);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WalletModel *model = _assetsList[indexPath.section];
    cell.bigIcon.image = [UIImage imageNamed:model.walletIcon];
    cell.staticTitleLb.text = model.walletName;
    
    if (indexPath.section == [[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue]) {
        cell.bkgIV.frame = CGRectMake(0, 0, _infoTableView.width, Size(42));
        cell.bkgIV.image = [UIImage imageNamed:@"switchwallet"];
        
        cell.staticTitleLb.textColor = WHITE_COLOR;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != [[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue]) {
        /***********更新当前选中的钱包位置信息***********/
        [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",indexPath.section]];
        /*************切换钱包后删除之前代币数据缓存*************/
        [CacheUtil clearTokenCoinTradeListCacheFile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
    }
    
    [self backAction];
}

@end
