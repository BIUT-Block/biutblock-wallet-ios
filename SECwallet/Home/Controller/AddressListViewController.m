//
//  AddressListViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "AddressListViewController.h"
#import "ScanQRCodeViewController.h"
#import "ManageAddressViewController.h"
#import "AddressModel.h"

@interface AddressListViewController()<UITableViewDelegate,UITableViewDataSource,ScanQRCodeViewControllerDelegate>
{
    UIButton *addBT;
    NSMutableArray *_dataArrays;  //数据列表
    UIView *_noneContactView;
}
@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isDelegate == YES) {
       [self setNavgationRightImage:[UIImage imageNamed:@"scanIcon1"] withAction:@selector(scanAction)];
    }
    
    [self addSubView];
    
}

- (void)addSubView
{
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), Size(7), Size(200), Size(15))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"地址薄",nil);
    [self.view addSubview:titleLb];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleLb.maxY +Size(33), kScreenWidth, kScreenHeight -KNaviHeight-(titleLb.maxY +Size(33) +Size(105))) style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.backgroundColor = BACKGROUND_DARK_COLOR;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self.view addSubview:_infoTableView];
    //底部添加按钮
    addBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), _infoTableView.maxY+Size(30), kScreenWidth-Size(20*2), Size(45))];
    [addBT goldBigBtnStyle:Localized(@"点击添加",nil)];
    [addBT addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBT];
    /*************获取地址列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    
    //无地址薄视图
    _noneContactView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_noneContactView];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, Size(187), kScreenWidth, Size(20))];
    lb.font = SystemFontOfSize(12);
    lb.textColor = COLOR(175, 176, 177, 1);
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = Localized(@"暂无联系人", nil);
    [_noneContactView addSubview:lb];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -Size(180))/2, lb.maxY+Size(73), Size(180), Size(45))];
    [bt customerBtnStyle:Localized(@"点击添加",nil) andBkgImg:@"continue"];
    [bt addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [_noneContactView addSubview:bt];
    
    if (_dataArrays.count > 0) {
        _noneContactView.hidden = YES;
        addBT.hidden = NO;
        [_infoTableView reloadData];
    }else{
        addBT.hidden = YES;
        _noneContactView.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*************获取地址列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _dataArrays = [NSMutableArray array];
    _dataArrays = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    if (_dataArrays.count > 0) {
        _noneContactView.hidden = YES;
        addBT.hidden = NO;
        [_infoTableView reloadData];
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Size(1);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Size(1))];
    footer.backgroundColor = BACKGROUND_DARK_COLOR;
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(57);
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
    cell.backgroundColor = DARK_COLOR;
    cell.imageView.image = [UIImage imageNamed:@""];
    cell.textLabel.font = BoldSystemFontOfSize(12);
    cell.textLabel.textColor = TEXT_BLACK_COLOR;
    cell.detailTextLabel.font = BoldSystemFontOfSize(12);
    cell.detailTextLabel.textColor = COLOR(209, 210, 211, 1);
    
    AddressModel *model = _dataArrays[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"      %@  %@",model.name,model.phone];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"      %@",[NSString addressToAsterisk:model.address]];
    //编辑按钮
    UIButton *editBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(40), Size(57-35)/2, Size(40), Size(35))];
    editBT.tag = indexPath.row;
    [editBT setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBT addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editBT];
    return cell;
}

#pragma 编辑
-(void)editAction:(UIButton *)sender
{
    ManageAddressViewController *controller = [[ManageAddressViewController alloc]init];
    controller.manageAddressViewType = ManageAddressViewType_edit;
    AddressModel *model = _dataArrays[sender.tag];
    controller.currentModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isDelegate == YES) {
        AddressModel *model = _dataArrays[indexPath.row];
        [self.delegate sendScanCode:model.address];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Localized(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //删除地址
        AddressModel *model = _dataArrays[indexPath.row];
        [_dataArrays removeObject:model];
        //替换list中当前地址信息
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:_dataArrays forKey:@"addressList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        [_infoTableView reloadData];
        if (_dataArrays.count == 0) {
            addBT.hidden = YES;
            _noneContactView.hidden = NO;
        }
    }];
    return @[deleteAction];
}

#pragma 扫一扫
-(void)scanAction
{
    ScanQRCodeViewController *controller = [[ScanQRCodeViewController alloc]init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma ScanQRCodeViewControllerDelegate
-(void)getScanCode:(NSString *)codeStr
{
    [self.delegate sendScanCode:codeStr];
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index>2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma 添加地址
-(void)addAddressAction
{
    ManageAddressViewController *controller = [[ManageAddressViewController alloc]init];
    controller.manageAddressViewType = ManageAddressViewType_add;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
