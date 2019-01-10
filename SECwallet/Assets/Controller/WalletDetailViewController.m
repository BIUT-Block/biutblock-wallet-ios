//
//  WalletDetailViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "CommonTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "ExportKeyStoreViewController.h"
#import "AddressCodePayViewController.h"
#import "BackupFileBeforeViewController.h"
#import "ConfirmPasswordViewController.h"

#define kHeaderHeight    Size(212) +KStatusBarHeight

@interface WalletDetailViewController ()<UITextFieldDelegate>
{
    UILabel *titLb;
    UITextField *walletNameTF;     //钱包名称
    UITextField *passwordDesTF;   //密码提示
    UIButton *secretBtn;  //加密按钮
}

@property (nonatomic, strong) CommonSidePullView *codeSidePullView;
@property (nonatomic, strong) CommonSidePullView *privateKeySidePullView;
@property (nonatomic, strong) CommonSidePullView *keystoreSidePullView;

@end

@implementation WalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    /*************获取钱包信息*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *dataArrays = [NSMutableArray array];
    dataArrays = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (WalletModel *model in dataArrays) {
        if ([model.walletName isEqualToString:_walletModel.walletName]) {
            _walletModel = model;
        }
    }
    
}

- (void)addSubView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    headerView.backgroundColor = LightGreen_COLOR;
    [self.view addSubview:headerView];
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [headerView addSubview:backBT];
    
    UIButton *QRcodeBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(55 +15 +40 +20), KStatusBarHeight+Size(11), Size(55), Size(24))];
    [QRcodeBT greenBorderBtnStyle:Localized(@"二维码",nil) andBkgImg:@"centerRightBtn"];
    [QRcodeBT addTarget:self action:@selector(showAddressCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QRcodeBT];
    
    UIButton *saveBT = [[UIButton alloc] initWithFrame:CGRectMake(QRcodeBT.maxX +Size(15), QRcodeBT.minY, Size(40), QRcodeBT.height)];
    [saveBT greenBorderBtnStyle:Localized(@"保存",nil) andBkgImg:@"smallRightBtn"];
    [saveBT addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBT];
    
    //标题
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), Size(52), Size(100), Size(10))];
    desLb.textColor = TEXT_LightDark_COLOR;
    desLb.font = SystemFontOfSize(8);
    desLb.text = Localized(@"钱包名称",nil);
    [headerView addSubview:desLb];
    titLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth, Size(20))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.text = _walletModel.walletName;
    [headerView addSubview:titLb];
    //头像
    UIImageView *headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(50))/2, titLb.maxY +Size(25), Size(50), Size(50))];
    headerIcon.image = [UIImage imageNamed:@"myWallet"];
    [headerView addSubview:headerIcon];
    //总资产
    UILabel *totalSumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, headerIcon.maxY +Size(20), kScreenWidth, Size(10))];
    totalSumLb.font = BoldSystemFontOfSize(10);
    totalSumLb.textColor = TEXT_GREEN_COLOR;
    totalSumLb.textAlignment = NSTextAlignmentCenter;
    totalSumLb.text = [NSString stringWithFormat:@"%@ SEC",_walletModel.balance];
    [headerView addSubview:totalSumLb];
    //地址
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(0, totalSumLb.maxY, kScreenWidth, Size(10))];
    addressLb.textAlignment = NSTextAlignmentCenter;
    addressLb.font = SystemFontOfSize(7);
    addressLb.textColor = TEXT_BLACK_COLOR;
    addressLb.text = _walletModel.address;
    [headerView addSubview:addressLb];
    
    //钱包名
    CommonTableViewCell *nameCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    nameCell.frame = CGRectMake(Size(20), headerView.maxY +Size(22), kScreenWidth -Size(20 *2), Size(36));
    [self.view addSubview:nameCell];
    UILabel *nameDesLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), 0, Size(85), nameCell.height)];
    nameDesLb.font = BoldSystemFontOfSize(10);
    nameDesLb.textColor = TEXT_BLACK_COLOR;
    nameDesLb.text = Localized(@"钱包名称",nil);
    [nameCell.contentView addSubview:nameDesLb];
    walletNameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameDesLb.maxX, nameDesLb.minY, nameCell.width -Size(100 +10*2), nameCell.height)];
    walletNameTF.font = SystemFontOfSize(10);
    walletNameTF.textColor = TEXT_BLACK_COLOR;
    //默认
    walletNameTF.text = _walletModel.walletName;
    walletNameTF.delegate = self;
    [nameCell.contentView addSubview:walletNameTF];
    
    //密码提示
    CommonTableViewCell *pswTipCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (_walletModel.passwordTip.length >0) {
        pswTipCell.frame = CGRectMake(nameCell.minX, nameCell.maxY +Size(7), nameCell.width, nameCell.height);
        [self.view addSubview:pswTipCell];
        UILabel *pswTipDesLb = [[UILabel alloc]initWithFrame:CGRectMake(nameDesLb.minX, 0, nameDesLb.width, nameDesLb.height)];
        pswTipDesLb.font = BoldSystemFontOfSize(10);
        pswTipDesLb.textColor = TEXT_BLACK_COLOR;
        pswTipDesLb.text = Localized(@"密码提示",nil);
        [pswTipCell.contentView addSubview:pswTipDesLb];
        passwordDesTF = [[UITextField alloc] initWithFrame:CGRectMake(pswTipDesLb.maxX, pswTipDesLb.minY, walletNameTF.width, walletNameTF.height)];
        passwordDesTF.font = SystemFontOfSize(10);
        passwordDesTF.textColor = TEXT_DARK_COLOR;
        passwordDesTF.keyboardType = UIKeyboardTypeNamePhonePad;
        passwordDesTF.secureTextEntry = YES;
        passwordDesTF.text = _walletModel.passwordTip;
        passwordDesTF.userInteractionEnabled = NO;
        [pswTipCell.contentView addSubview:passwordDesTF];
        /*****************密码可见、不可见*****************/
        secretBtn = [[UIButton alloc] initWithFrame:CGRectMake(pswTipCell.width -Size(18 +10), (pswTipCell.height -Size(14))/2, Size(18), Size(14))];
        [secretBtn setImage:[UIImage imageNamed:@"secrecy"] forState:UIControlStateNormal];
        [secretBtn setImage:[UIImage imageNamed:@"noSecrecy"] forState:UIControlStateSelected];
        [secretBtn addTarget:self action:@selector(secretBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [pswTipCell.contentView addSubview:secretBtn];
    }else{
        pswTipCell.frame = CGRectMake(nameCell.minX, nameCell.maxY, nameCell.width, 0);
    }
    
    NSArray *iconArr = @[@"lock",@"corner-up-right",@"corner-up-right"];
    NSArray *titArr = @[Localized(@"修改密码",nil),Localized(@"导出私钥",nil),Localized(@"导出KeyStore",nil)];
    for (int i = 0; i< iconArr.count; i++) {
        CommonTableViewCell *staticCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        staticCell.frame = CGRectMake(pswTipCell.minX, pswTipCell.maxY +Size(7) +(nameCell.height +Size(7))*i, pswTipCell.width, nameCell.height);
        staticCell.smallIcon.image = [UIImage imageNamed:iconArr[i]];
        staticCell.staticTitleLb.text = titArr[i];
        staticCell.accessoryIV.image = [UIImage imageNamed:@"rightArrow"];
        [self.view addSubview:staticCell];
        UIButton *lnkBtn = [[UIButton alloc]initWithFrame:staticCell.frame];
        lnkBtn.tag = 1000+i;
        [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lnkBtn];
    }
    
    /*****************删除钱包*****************/
    CGFloat padddingLeft = Size(20);
    CGFloat btWidth = (kScreenWidth -padddingLeft*2 -Size(10))/2;
    CGFloat btY = pswTipCell.maxY +Size(7) +(nameCell.height +Size(7))*3 +Size(30);
    //备份按钮
    if ((_walletModel.isBackUpMnemonic == NO && _walletModel.mnemonicPhrase.length > 0) || _walletModel.isFromMnemonicImport == YES) {
        UIButton *backupBT = [[UIButton alloc]initWithFrame:CGRectMake(padddingLeft, btY, btWidth, Size(45))];
        [backupBT goldSmallBtnStyle:Localized(@"备份助记词",nil)];
        [backupBT addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backupBT];

        UIButton *deleteBT = [[UIButton alloc] initWithFrame:CGRectMake(backupBT.maxX+Size(10), backupBT.minY, backupBT.width, backupBT.height)];
        [deleteBT customerBtnStyle:Localized(@"删除钱包",nil) andBkgImg:@"deletewallet"];
        [deleteBT addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBT];
    }else{
        UIButton *deleteBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, btY, kScreenWidth - 2*padddingLeft, Size(45))];
        [deleteBT customerBtnStyle:Localized(@"删除钱包",nil) andBkgImg:@"deletewalletBig"];
        [deleteBT addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBT];
    }
    
}

#pragma mark - cell点击事件
-(void)btnClick:(UIButton *)sender
{
    [self dismissKeyboardAction];
    if (sender.tag == 1000) {
        //修改密码
        ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc]init];
        viewController.walletModel = _walletModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (sender.tag == 1001) {
        //导出私钥
        ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
        controller.walletModel = _walletModel;
        [self presentViewController:controller animated:YES completion:nil];
        controller.sureBlock = ^() {
            _privateKeySidePullView = [[CommonSidePullView alloc]initWithWidth:Size(190) sidePullViewType:CommonSidePullViewType_privateKey];
            [self.view addSubview:_privateKeySidePullView];
            [_privateKeySidePullView show];
        };
        
    }else if (sender.tag == 1002) {
        //导入KeyStore
        ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
        controller.walletModel = _walletModel;
        [self presentViewController:controller animated:YES completion:nil];
        controller.sureBlock = ^() {
            CommonSidePullView *keystoreRemindSidePullView = [[CommonSidePullView alloc]initWithWidth:Size(190) sidePullViewType:CommonSidePullViewType_keyStoreRemind];
            [self.view addSubview:keystoreRemindSidePullView];
            [keystoreRemindSidePullView show];
            keystoreRemindSidePullView.dismissBlock = ^() {
                _keystoreSidePullView = [[CommonSidePullView alloc]initWithWidth:Size(268) sidePullViewType:CommonSidePullViewType_keyStore];
                [self.view addSubview:_keystoreSidePullView];
                [_keystoreSidePullView show];
            };
        };
    }
}

#pragma 删除钱包
-(void)deleteAction
{
    ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
    controller.walletModel = _walletModel;
    [self presentViewController:controller animated:YES completion:nil];
    controller.sureBlock = ^() {
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        //如果删除的钱包是当前默认的钱包则要清除钱包交易记录数据缓存
        WalletModel *defaultMode = list[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
        if ([defaultMode.walletName isEqualToString:_walletModel.walletName]) {
            [CacheUtil clearTokenCoinTradeListCacheFile];
        }
        
        /***********更新当前钱包信息***********/
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([model.walletName isEqualToString:_walletModel.walletName]) {
                [list removeObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        /***********更新当前选中的钱包位置信息***********/
        [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
        if (list.count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
        }
        
        [self backAction];
    };
}

#pragma mark - 保存信息
-(void)saveData
{
    [self dismissKeyboardAction];
    [self createLoadingView:Localized(@"保存信息中···", nil)];
    if (![walletNameTF.text isEqualToString:_walletModel.walletName]) {
        /***********更新当前钱包信息***********/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([model.walletName isEqualToString:_walletModel.walletName]) {
                [model setWalletName:walletNameTF.text];
                [list replaceObjectAtIndex:i withObject:model];
                _walletModel = list[i];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    }
    //延迟执行
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}

-(void)delayMethod
{
    [self hiddenLoadingView];
    [self hudShowWithString:Localized(@"保存成功", nil) delayTime:1.5];
    
    titLb.text = _walletModel.walletName;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
}

#pragma 收款码
-(void)showAddressCodeAction
{
    _codeSidePullView = [[CommonSidePullView alloc]initWithWidth:Size(190) sidePullViewType:CommonSidePullViewType_address];
    [self.view addSubview:_codeSidePullView];
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[CommonSidePullView class]]) {
            view.userInteractionEnabled = NO;
        }
    }
    [_codeSidePullView show];
    _codeSidePullView.dismissBlock = ^() {
        for (UIView *view in self.view.subviews) {
            if (![view isKindOfClass:[CommonSidePullView class]]) {
                view.userInteractionEnabled = YES;
            }
        }
    };
}

#pragma 备份助记词
-(void)backupAction
{
    ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
    controller.walletModel = _walletModel;
    [self presentViewController:controller animated:YES completion:nil];
    controller.sureBlock = ^() {
        BackupFileBeforeViewController *controller = [[BackupFileBeforeViewController alloc]init];
        controller.walletModel = _walletModel;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navi animated:YES completion:nil];
    };
}

//密码是否加密
-(void)secretBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        passwordDesTF.secureTextEntry = NO;
    }else{
        passwordDesTF.secureTextEntry = YES;
    }
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //判断钱包名是否有重复
    /*************获取钱包列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    for (WalletModel *model in walletList) {
        if ([walletNameTF.text isEqualToString:model.walletName] && ![walletNameTF.text isEqualToString:_walletModel.walletName]) {
            [self hudShowWithString:Localized(@"钱包名已存在", nil) delayTime:1.5];
        }
    }
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [walletNameTF resignFirstResponder];
}

@end
