//
//  ImportWalletViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ImportWalletViewController.h"
#import "CommonHtmlShowViewController.h"
#import "WalletModel.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import "CommonTableViewCell.h"

#define KInputTVViewHeight   Size(100)
#define KInputDesViewHeight  Size(25)
#define KInputTFViewHeight   Size(15)

@interface ImportWalletViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UITextView *inputTV;
    //密码
    CommonTableViewCell *pswCell;
    UILabel *passwordDesLb;
    UITextField *passwordTF;
    
    //重复密码
    CommonTableViewCell *re_pswCell;
    UILabel *re_passwordDesLb;
    UITextField *re_passwordTF;

    //密码提示
    CommonTableViewCell *pswTipCell;
    UILabel *passwordTipDesLb;
    UITextField *passwordTipTF;
    
    UIButton *agreementBtn;
    UIButton *importBT;
    
    UILabel *importTipLb;
    
    UILabel *placeholderLb;
    
    NSTimer *_importTimer;   //导入计时器
    int _timing; //定时
    BOOL hasImportSuccess;
}

@end

@implementation ImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

-(void)initSubViews
{
    /***********************导入助记词***********************/
    inputTV = [[UITextView alloc]initWithFrame:CGRectMake(Size(20), Size(48), kScreenWidth -Size(20)*2, KInputTVViewHeight)];
    inputTV.backgroundColor = DARK_COLOR;
    inputTV.layer.cornerRadius = Size(8);
    inputTV.font = SystemFontOfSize(14);
    inputTV.textColor = TEXT_BLACK_COLOR;
    inputTV.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTV.delegate = self;
    [self.view addSubview:inputTV];
    placeholderLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(8), Size(8), inputTV.width, Size(20))];
    placeholderLb.font = SystemFontOfSize(10);
    placeholderLb.textColor = COLOR(176, 175, 175, 1);
    placeholderLb.text = Localized(@"助记词，按空格分隔", nil);
    [inputTV addSubview:placeholderLb];
    //密码
    passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, inputTV.maxY +Size(3), inputTV.width, KInputDesViewHeight)];
    passwordDesLb.font = BoldSystemFontOfSize(10);
    passwordDesLb.textColor = TEXT_BLACK_COLOR;
    passwordDesLb.text = Localized(@"密码", nil);
    [self.view addSubview:passwordDesLb];
    
    pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswCell.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, Size(36));
    [self.view addSubview:pswCell];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(inputTV.minX +Size(10), passwordDesLb.maxY, pswCell.width -Size(20), pswCell.height)];
    passwordTF.font = SystemFontOfSize(8);
    passwordTF.textColor = TEXT_BLACK_COLOR;
    passwordTF.placeholder = Localized(@"8~30位数字，英文字母以及特殊字符至少2种组合", nil);
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTF];
    
    //重复密码
    re_passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, pswCell.maxY +Size(3), inputTV.width, KInputDesViewHeight)];
    re_passwordDesLb.font = BoldSystemFontOfSize(10);
    re_passwordDesLb.textColor = TEXT_BLACK_COLOR;
    re_passwordDesLb.text = Localized(@"重复密码", nil);
    [self.view addSubview:re_passwordDesLb];
    re_pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    re_pswCell.frame = CGRectMake(pswCell.minX, re_passwordDesLb.maxY, pswCell.width, pswCell.height);
    [self.view addSubview:re_pswCell];
    re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.minX, re_passwordDesLb.maxY, passwordTF.width, passwordTF.height)];
    re_passwordTF.font = SystemFontOfSize(8);
    re_passwordTF.textColor = TEXT_BLACK_COLOR;
    re_passwordTF.placeholder = Localized(@"请再次确认密码", nil);
    re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    re_passwordTF.secureTextEntry = YES;
    re_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:re_passwordTF];

    //密码提示
    passwordTipDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, re_pswCell.maxY +Size(3), inputTV.width, KInputDesViewHeight)];
    passwordTipDesLb.font = BoldSystemFontOfSize(10);
    passwordTipDesLb.textColor = TEXT_BLACK_COLOR;
    passwordTipDesLb.text = Localized(@"密码提示（选填）", nil);
    [self.view addSubview:passwordTipDesLb];
    pswTipCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswTipCell.frame = CGRectMake(re_pswCell.minX, passwordTipDesLb.maxY, re_pswCell.width, re_pswCell.height);
    [self.view addSubview:pswTipCell];
    passwordTipTF = [[UITextField alloc] initWithFrame:CGRectMake(re_passwordTF.minX, passwordTipDesLb.maxY, re_passwordTF.width, re_passwordTF.height)];
    passwordTipTF.font = SystemFontOfSize(10);
    passwordTipTF.textColor = TEXT_BLACK_COLOR;
    passwordTipTF.placeholder = Localized(@"选填", nil);
    passwordTipTF.delegate = self;
    [self.view addSubview:passwordTipTF];
    
    /*****************用户协议*****************/
    NSString *str = Localized(@" 我已仔细阅读并同意服务条款", nil);
    CGSize size = [str calculateSize:BoldSystemFontOfSize(8) maxWidth:kScreenWidth];
    agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(inputTV.minX, passwordTipTF.maxY + Size(17),size.width +Size(20), Size(20))];
    [agreementBtn setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    [agreementBtn setTitle:str forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = BoldSystemFontOfSize(8);
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocolun"] forState:UIControlStateNormal];
    [agreementBtn setImage:[UIImage imageNamed:@"invest_protocol"] forState:UIControlStateSelected];
    agreementBtn.selected = NO;
    [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];
    
    /*****************导入钱包*****************/
    importBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), agreementBtn.maxY +Size(13), kScreenWidth - 2*Size(20), Size(45))];
    [importBT darkBtnStyle:Localized(@"开始导入", nil)];
    [importBT addTarget:self action:@selector(beginImportAction) forControlEvents:UIControlEventTouchUpInside];
    importBT.userInteractionEnabled = NO;
    [self.view addSubview:importBT];
    

    if (_importWalletType == ImportWalletType_keyStore) {
        
        importTipLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, Size(55), inputTV.width, Size(40))];
        importTipLb.font = SystemFontOfSize(10);
        importTipLb.textColor = TEXT_DARK_COLOR;
        importTipLb.numberOfLines = 2;
        importTipLb.text = Localized(@"直接复制粘贴以太坊官方钱包keyStore文件内容至输入框。", nil);
        //设置行间距
        NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:importTipLb.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = Size(5);
        [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
        importTipLb.attributedText = msgStr;
        [self.view addSubview:importTipLb];
        inputTV.frame = CGRectMake(importTipLb.minX, importTipLb.maxY +Size(18), importTipLb.width, KInputTVViewHeight);
        
        passwordDesLb.frame = CGRectMake(inputTV.minX, inputTV.maxY +Size(20), inputTV.width, KInputDesViewHeight);
        passwordDesLb.text = Localized(@"keyStore密码", nil);
        pswCell.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, Size(36));
        passwordTF.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, KInputTFViewHeight);
        passwordTF.placeholder = nil;
        passwordTF.secureTextEntry = YES;
        passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        re_pswCell.hidden = YES;
        re_passwordDesLb.hidden = YES;
        re_passwordTF.hidden = YES;
        pswTipCell.hidden = YES;
        passwordTipDesLb.hidden = YES;
        passwordTipTF.hidden = YES;
        
        agreementBtn.frame = CGRectMake(inputTV.minX, pswCell.maxY + Size(17),size.width +Size(20), Size(20));
        importBT.frame = CGRectMake(Size(20), agreementBtn.maxY +Size(13), kScreenWidth - 2*Size(20), Size(45));
        
        placeholderLb.text = Localized(@"keystore文本内容", nil);
        
    }else if (_importWalletType == ImportWalletType_privateKey) {

        placeholderLb.text = Localized(@"明文私钥", nil);
    }
}

//协议
-(void)agreementBtnAction:(UIButton *)btn
{
    [self dismissKeyboardAction];
    agreementBtn.selected = !agreementBtn.selected;
    if (!agreementBtn.selected) {
        [importBT darkBtnStyle:Localized(@"开始导入", nil)];
        importBT.userInteractionEnabled = NO;
    }else{
        [importBT goldBigBtnStyle:Localized(@"开始导入", nil)];
        importBT.userInteractionEnabled = YES;
    }
}
//查看协议内容
-(void)seeProtocol:(UIButton *)btn
{
    CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.commonHtmlShowViewType = CommonHtmlShowViewType_RgsProtocol;
    viewController.titleStr = @"商户协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 导入钱包
-(void)beginImportAction
{
    [self dismissKeyboardAction];
    if (_importWalletType == ImportWalletType_mnemonicPhrase) {
        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:Localized(@"请输入助记词", nil) delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:Localized(@"请输入8~30位密码", nil) delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:Localized(@"请输入数字和字母组合密码", nil) delayTime:1.5];
            return;
        }
        if (re_passwordTF.text.length == 0) {
            [self hudShowWithString:Localized(@"请再次输入密码", nil) delayTime:1.5];
            return;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            [self hudShowWithString:Localized(@"两次密码输入不一致，请重新输入！", nil) delayTime:1.5];
            return;
        }
    
        //导入助记词
        [self createLoadingView:Localized(@"导入钱包中···", nil)];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_inportMnemonics:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorMnemonicsLength) {
                [self hudShowWithString:Localized(@"助记词长度不够", nil) delayTime:1.5];
            }else if (error == HSWalletErrorMnemonicsCount) {
                [self hudShowWithString:Localized(@"助记词个数不够", nil) delayTime:1.5];
            }else if (error == HSWalletErrorMnemonicsValidWord) {
                [self hudShowWithString:Localized(@"助记词有误", nil) delayTime:1.5];
            }else if (error == HSWalletImportMnemonicsSuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.mnemonicPhrase]) {
                        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"温馨提示", nil) contentText:Localized(@"钱包已存在，是否设置为新密码？\n（请牢记钱包新密码）", nil) imageName:@"question_mark" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"确定", nil) alertViewType:CommonAlertViewType_question_mark];
                        [alert show];
                        return;
                    }
                }
                //不存在就保存钱包
                [self hudShowWithString:Localized(@"助记词导入成功", nil) delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:1];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
        
    }else if (_importWalletType == ImportWalletType_keyStore) {

        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:Localized(@"请输入KeyStore", nil) delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:Localized(@"请输入8~30位密码", nil) delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:Localized(@"请输入数字和字母组合密码", nil) delayTime:1.5];
            return;
        }
        //导入KeyStore
        [self createLoadingView:Localized(@"导入钱包中···", nil)];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importKeyStore:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorKeyStoreLength) {
                [self hudShowWithString:Localized(@"KeyStore长度不够", nil) delayTime:1.5];
            }else if (error == HSWalletErrorKeyStoreValid) {
                [self hudShowWithString:Localized(@"密码不正确", nil) delayTime:1.5];
            }else if (error == HSWalletImportKeyStoreSuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.keyStore]) {
                        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"温馨提示", nil) contentText:Localized(@"钱包已存在，是否设置为新密码？\n（请牢记钱包新密码）", nil) imageName:@"question_mark" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"确定", nil) alertViewType:CommonAlertViewType_question_mark];
                        [alert show];
                        return;
                    }
                }
                
                //不存在就保存钱包
                [self hudShowWithString:Localized(@"KeyStore导入成功", nil) delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
        
    }else if (_importWalletType == ImportWalletType_privateKey) {
        
        //验证输入
        if (inputTV.text.length == 0) {
            [self hudShowWithString:Localized(@"请输入私钥", nil) delayTime:1.5];
            return;
        }
        if (inputTV.text.length != 64) {
            [self hudShowWithString:Localized(@"请输入正确的私钥", nil) delayTime:1.5];
            return;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            [self hudShowWithString:Localized(@"请输入8~30位密码", nil) delayTime:1.5];
            return;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            [self hudShowWithString:Localized(@"请输入数字和字母组合密码", nil) delayTime:1.5];
            return;
        }
        if (re_passwordTF.text.length == 0) {
            [self hudShowWithString:Localized(@"请再次输入密码", nil) delayTime:1.5];
            return;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            [self hudShowWithString:Localized(@"两次密码输入不一致，请重新输入！", nil) delayTime:1.5];
            return;
        }
        //导入私钥
        [self createLoadingView:Localized(@"导入钱包中···", nil)];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 5;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importWalletForPrivateKey:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorPrivateKeyLength) {
                [self hudShowWithString:Localized(@"私钥长度不够", nil) delayTime:1.5];
            }else if (error == HSWalletImportPrivateKeySuc) {
                
                /*************先获取钱包列表并将最新钱包排在第一位*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                //判断是否已存在
                for (WalletModel *model in list) {
                    if ([inputTV.text isEqualToString:model.privateKey]) {
                        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"温馨提示", nil) contentText:Localized(@"钱包已存在，是否设置为新密码？\n（请牢记钱包新密码）", nil) imageName:@"question_mark" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"确定", nil) alertViewType:CommonAlertViewType_question_mark];
                        [alert show];
                        return;
                    }
                }
                
                //不存在就保存钱包
                [self hudShowWithString:Localized(@"私钥导入成功", nil) delayTime:1.5];
                //随机生成用户名
                NSString *nameStr = [NSString getRandomStringWithNum:8];
                //随机生成钱包ICON
                int i = arc4random() % 6;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                /*************默认钱包信息*************/
                NSArray *privateKeyArr = [privateKey componentsSeparatedByString:@"x"];
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyArr.lastObject andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:model atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:model atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                [self backToHomeAction];
            }
        }];
    }
}

- (void)countdown
{
    if (_timing != 0) {
        _timing --;
    }else{
        //倒计时结束
        [self hiddenLoadingView];
        if (hasImportSuccess == NO) {
            [self hudShowWithString:Localized(@"导入失败，请重新输入", nil) delayTime:2];
        }
        _importTimer = nil;
        [_importTimer invalidate];
        [_importTimer setFireDate:[NSDate distantFuture]];
        hasImportSuccess = YES;
    }
}

#pragma 导入成功进入首页
-(void)backToHomeAction
{
    //进入首页
    RootViewController *controller = [[RootViewController alloc] init];
    AppDelegateInstance.window.rootViewController = controller;
    [AppDelegateInstance.window makeKeyAndVisible];
    /*************导入钱包成功后删除之前代币数据缓存*************/
    [CacheUtil clearTokenCoinTradeListCacheFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == passwordTipTF) {
        //限制输入12位
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if (passwordTipTF.text.length >= 12) {
            passwordTipTF.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        /***********更新当前钱包密码***********/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([inputTV.text isEqualToString:model.mnemonicPhrase]) {
                [model setLoginPassword:passwordTF.text];
                [list replaceObjectAtIndex:i withObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        
        [self backAction];
    }
}

#pragma UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeholderLb.hidden = YES;
    [IQKeyboardManager sharedManager].shouldFixTextViewClip = NO;
    [IQKeyboardManager sharedManager].canAdjustTextView = NO;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        placeholderLb.hidden = YES;
    }else{
        placeholderLb.hidden = NO;
    }    
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [inputTV resignFirstResponder];
    [passwordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];
    [passwordTipTF resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //移除定时器
    [_importTimer setFireDate:[NSDate distantFuture]];
    _importTimer = nil;
    [_importTimer invalidate];
    [super viewDidDisappear:animated];
}

@end
