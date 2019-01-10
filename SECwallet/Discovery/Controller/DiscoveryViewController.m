//
//  DiscoveryViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/29.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DappModel.h"

@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *exchangeBT;
    UIButton *gameBT;
    UIView *bottomLine;
    
    NSMutableArray *_dataArrays;
}

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArrays = [NSMutableArray array];
    DappModel *model1 = [[DappModel alloc]init];
    model1.dappLogo = @"DDEX";
    model1.name = @"DDEX";
    model1.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model1];
    DappModel *model2 = [[DappModel alloc]init];
    model2.dappLogo = @"KYBER";
    model2.name = @"Kyber Network";
    model2.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model2];
    DappModel *model3 = [[DappModel alloc]init];
    model3.dappLogo = @"FORK";
    model3.name = @"Fork Delta";
    model3.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model3];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = COLOR(243, 244, 245, 1);
}

- (void)addContentView
{
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(165))];
    headerView.image = [UIImage imageNamed:@"walletHomeBg"];
    [self.view addSubview:headerView];
    //标题
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(25), Size(60), kScreenWidth, Size(30))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.text = Localized(@"发现",nil);
    [headerView addSubview:titLb];
    
    exchangeBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), titLb.maxY+Size(15), Size(60), Size(25))];
    exchangeBT.titleLabel.font = BoldSystemFontOfSize(12);
    [exchangeBT setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
    [exchangeBT setTitle:Localized(@"交易所", nil) forState:UIControlStateNormal];
    [exchangeBT addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBT];
    gameBT = [[UIButton alloc]initWithFrame:CGRectMake(exchangeBT.maxX, exchangeBT.minY, exchangeBT.width, exchangeBT.height)];
    gameBT.titleLabel.font = BoldSystemFontOfSize(12);
    [gameBT setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
    [gameBT setTitle:Localized(@"游戏", nil) forState:UIControlStateNormal];
    [gameBT addTarget:self action:@selector(gameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gameBT];
    //下划线
    bottomLine = [[UIView alloc]initWithFrame:CGRectMake(exchangeBT.minX, exchangeBT.maxY, exchangeBT.width, Size(1.4))];
    bottomLine.backgroundColor = TEXT_GREEN_COLOR;
    bottomLine.layer.cornerRadius = Size(2);
    [self.view addSubview:bottomLine];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(Size(20), bottomLine.maxY +Size(20), kScreenWidth -Size(20)*2, kScreenHeight-bottomLine.maxY -Size(20 +5) -KTabbarHeight) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = COLOR(243, 244, 245, 1);
    [self.view addSubview:_infoTableView];
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Size(3);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = COLOR(243, 244, 245, 1);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(48);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = Size(5);
    cell.imageView.image = [UIImage imageNamed:@""];
    cell.textLabel.font = BoldSystemFontOfSize(12);
    cell.textLabel.textColor = TEXT_BLACK_COLOR;
    cell.detailTextLabel.font = SystemFontOfSize(9);
    cell.detailTextLabel.textColor = TEXT_DARK_COLOR;
    cell.detailTextLabel.numberOfLines = 2;
    
    DappModel *model = _dataArrays[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:model.dappLogo];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)exchangeAction
{
    _dataArrays = [NSMutableArray array];
    DappModel *model1 = [[DappModel alloc]init];
    model1.dappLogo = @"DDEX";
    model1.name = @"DDEX";
    model1.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model1];
    DappModel *model2 = [[DappModel alloc]init];
    model2.dappLogo = @"KYBER";
    model2.name = @"Kyber Network";
    model2.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model2];
    DappModel *model3 = [[DappModel alloc]init];
    model3.dappLogo = @"FORK";
    model3.name = @"Fork Delta";
    model3.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model3];
    [_infoTableView reloadData];
    
    //从右向左移动
    [UIView animateWithDuration:0.20 animations:^{
        [exchangeBT setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
        [gameBT setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
        bottomLine.frame = CGRectMake(exchangeBT.minX, exchangeBT.maxY, exchangeBT.width, Size(1.4));
    }];
}

-(void)gameAction
{
    _dataArrays = [NSMutableArray array];
    DappModel *model1 = [[DappModel alloc]init];
    model1.dappLogo = @"DDEX";
    model1.name = @"DDEX";
    model1.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    DappModel *model2 = [[DappModel alloc]init];
    model2.dappLogo = @"KYBER";
    model2.name = @"Kyber Network";
    model2.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    DappModel *model3 = [[DappModel alloc]init];
    model3.dappLogo = @"FORK";
    model3.name = @"Fork Delta";
    model3.content = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry";
    [_dataArrays addObject:model3];
    [_dataArrays addObject:model2];
    [_dataArrays addObject:model3];
    [_dataArrays addObject:model1];
    [_dataArrays addObject:model2];
    [_dataArrays addObject:model1];
    [_dataArrays addObject:model3];
    [_dataArrays addObject:model2];
    [_dataArrays addObject:model1];
    [_infoTableView reloadData];
    //从左向右移动
    [UIView animateWithDuration:0.20 animations:^{
        [exchangeBT setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
        [gameBT setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
        bottomLine.frame = CGRectMake(exchangeBT.maxX, exchangeBT.maxY, exchangeBT.width, Size(1.4));
    }];
}

@end
