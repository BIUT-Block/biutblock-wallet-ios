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

#define kHeaderHeight    Size(212) +KStatusBarHeight

@interface WalletDetailViewController ()<UITextFieldDelegate>
{
    UITextField *walletNameTF;     //钱包名称
    UITextField *passwordDesTF;   //密码提示
    UIButton *secretBtn;  //加密按钮
}

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
//    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(Size(15), Size(10)+KStatusBarHeight, Size(25), Size(15))];
//    backIV.image = [UIImage imageNamed:@"backIcon"];
//    [headerView addSubview:backIV];
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(25), Size(10)+KStatusBarHeight, Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [headerView addSubview:backBT];
//    //保存按钮
//    UIButton *saveBT = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -Size(45 +15), backIV.minY, Size(45), Size(20))];
//    saveBT.titleLabel.font = SystemFontOfSize(18);
//    [saveBT setTitleColor:BACKGROUND_DARK_COLOR forState:UIControlStateNormal];
//    [saveBT setTitle:@"保存" forState:UIControlStateNormal];
//    [saveBT addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:saveBT];
//    UIImageView *addressIV = [[UIImageView alloc]initWithFrame:CGRectMake(addressBkgView.maxX +Size(5), addressLb.minY +Size(5), Size(20), Size(20))];
//    addressIV.image = [UIImage imageNamed:@"codeIcon"];
//    [cell.contentView addSubview:addressIV];
//    UIButton *addressBT = [[UIButton alloc]initWithFrame:CGRectMake(addressBkgView.minX, addressBkgView.minY, addressBkgView.width +Size(20), Size(20))];
//    [addressBT addTarget:self action:@selector(showAddressCodeAction) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:addressBT];
    
    
    //标题
    UILabel *desLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(25), Size(52), Size(100), Size(10))];
    desLb.textColor = TEXT_LightDark_COLOR;
    desLb.font = SystemFontOfSize(8);
    desLb.text = Localized(@"钱包名称",nil);
    [headerView addSubview:desLb];
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(desLb.minX, desLb.maxY, kScreenWidth, Size(20))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.text = _walletModel.walletName;
    [headerView addSubview:titLb];
    //头像
    UIImageView *headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(50))/2, titLb.maxY +Size(25), Size(50), Size(50))];
    headerIcon.image = [UIImage imageNamed:_walletModel.walletIcon];
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
    UILabel *nameDesLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(10), 0, Size(80), nameCell.height)];
    nameDesLb.font = SystemFontOfSize(10);
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
        pswTipDesLb.font = SystemFontOfSize(10);
        pswTipDesLb.textColor = TEXT_BLACK_COLOR;
        pswTipDesLb.text = @"密码提示";
        [pswTipCell.contentView addSubview:pswTipDesLb];
        passwordDesTF = [[UITextField alloc] initWithFrame:CGRectMake(pswTipDesLb.maxX, pswTipDesLb.minY, walletNameTF.width, walletNameTF.height)];
        passwordDesTF.font = SystemFontOfSize(15);
        passwordDesTF.textColor = TEXT_DARK_COLOR;
        passwordDesTF.keyboardType = UIKeyboardTypeNamePhonePad;
        passwordDesTF.secureTextEntry = YES;
        passwordDesTF.text = _walletModel.passwordTip;
        passwordDesTF.userInteractionEnabled = NO;
        [pswTipCell.contentView addSubview:passwordDesTF];
        /*****************密码可见、不可见*****************/
        secretBtn = [[UIButton alloc] initWithFrame:CGRectMake(pswTipCell.width -Size(18 +10), (pswTipCell.height -Size(14))/2, Size(18), Size(14))];
        [secretBtn setBackgroundImage:[UIImage imageNamed:@"secrecy"] forState:UIControlStateNormal];
        [secretBtn setBackgroundImage:[UIImage imageNamed:@"noSecrecy"] forState:UIControlStateSelected];
        [secretBtn addTarget:self action:@selector(secretBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [pswTipCell.contentView addSubview:secretBtn];
    }else{
        pswTipCell.frame = CGRectMake(nameCell.minX, nameCell.maxY, nameCell.width, 0);
    }
    
    NSArray *iconArr = @[@"addressBook",@"addressBook",@"addressBook"];
    NSArray *titArr = @[Localized(@"修改密码",nil),Localized(@"导出私钥",nil),Localized(@"导出Keystore",nil)];
    for (int i = 0; i< iconArr.count; i++) {
        CommonTableViewCell *staticCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        staticCell.frame = CGRectMake(pswTipCell.minX, pswTipCell.maxY +Size(7) +(nameCell.height +Size(7))*i, pswTipCell.width, nameCell.height);
        staticCell.icon.image = [UIImage imageNamed:iconArr[i]];
        staticCell.staticTitleLb.text = titArr[i];
        staticCell.accessoryIV.image = [UIImage imageNamed:@"accessory_right"];
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
        [deleteBT goldSmallBtnStyle:Localized(@"删除钱包",nil)];
        [deleteBT addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBT];
    }else{
        UIButton *deleteBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, btY, kScreenWidth - 2*padddingLeft, Size(45))];
        [deleteBT goldBigBtnStyle:Localized(@"删除钱包",nil)];
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *pswTF = alertController.textFields.firstObject;
            if (pswTF.text.length == 0) {
                [self hudShowWithString:@"密码不能为空" delayTime:1];
                return;
            }else{
                if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                    CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:@"导出私钥" contentText:_walletModel.privateKey imageName:nil leftButtonTitle:@"复制" rightButtonTitle:nil alertViewType:CommonAlertViewType_Check_mark];
                    [alert show];
                    alert.leftBlock = ^() {
                        //复制
                        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                        pastboard.string = _walletModel.privateKey;
                        [self hudShowWithString:@"已复制" delayTime:1];
                    };
                }else{
                    [self hudShowWithString:@"密码不正确" delayTime:1];
                    return;
                }
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.secureTextEntry = YES;
        }];
        [self presentViewController:alertController animated:true completion:nil];
    }else if (sender.tag == 1002) {
        //导入KeyStore
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *pswTF = alertController.textFields.firstObject;
            if (pswTF.text.length == 0) {
                [self hudShowWithString:@"密码不能为空" delayTime:1];
                return;
            }else{
                if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                    ExportKeyStoreViewController *viewController = [[ExportKeyStoreViewController alloc]init];
                    viewController.keyStore = _walletModel.keyStore;
                    [self.navigationController pushViewController:viewController animated:YES];
                }else{
                    [self hudShowWithString:@"密码不正确" delayTime:1];
                    return;
                }
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.secureTextEntry = YES;
        }];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

#pragma 删除钱包
-(void)deleteAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
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
                
            }else{
                [self hudShowWithString:@"密码不正确" delayTime:1];
                return;
            }
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 保存信息
-(void)saveData
{
    [self dismissKeyboardAction];
    [self createLoadingView:@"正在保存..."];
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
    [self hudShowWithString:@"保存成功" delayTime:1.5];
//    [_infoTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
}

#pragma 收款码
-(void)showAddressCodeAction
{
    AddressCodePayViewController *viewController = [[AddressCodePayViewController alloc] init];
    viewController.walletModel = _walletModel;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma 备份助记词
-(void)backupAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                BackupFileBeforeViewController *controller = [[BackupFileBeforeViewController alloc]init];
                controller.walletModel = _walletModel;
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }else{
                [self hudShowWithString:@"密码不正确" delayTime:1];
                return;
            }
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertController animated:true completion:nil];
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
            [self hudShowWithString:@"钱包名已存在" delayTime:1.5];
        }
    }
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [walletNameTF resignFirstResponder];
}

@end
