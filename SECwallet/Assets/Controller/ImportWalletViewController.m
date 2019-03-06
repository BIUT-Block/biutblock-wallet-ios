//
//  ImportWalletViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ImportWalletViewController.h"
#import "WalletModel.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import "CommonTableViewCell.h"
#import "SECwallet-Swift.h"

#define KInputTVViewHeight   Size(100)
#define KInputDesViewHeight  Size(25)
#define KInputTFViewHeight   Size(15)

@interface ImportWalletViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UILabel *inputTVErrorLb;
    UITextView *inputTV;
    //密码
    CommonTableViewCell *pswCell;
    UILabel *passwordDesLb;
    UILabel *passwordErrorLb;
    UITextField *passwordTF;
    UIView *level1View;
    UIView *level2View;
    UIView *level3View;
    
    //确认密码
    CommonTableViewCell *re_pswCell;
    UILabel *re_passwordDesLb;
    UILabel *re_passwordErrorLb;
    UITextField *re_passwordTF;

    //密码提示
    CommonTableViewCell *pswTipCell;
    UILabel *passwordTipDesLb;
    UITextField *passwordTipTF;
    
    UIButton *importBT;
    
    UILabel *importTipLb;
    
    UILabel *placeholderLb;
    
    NSTimer *_importTimer;   //导入计时器
    int _timing; //定时
    BOOL hasImportSuccess;
    
    NSMutableArray *walletList;
}

@end

@implementation ImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data2 = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
    walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    
    [self initSubViews];
}

-(void)initSubViews
{
    /***********************导入助记词***********************/
    inputTVErrorLb = [[UILabel alloc]init];
    [self.view addSubview:inputTVErrorLb];
    inputTV = [[UITextView alloc]initWithFrame:CGRectMake(Size(20), Size(48), kScreenWidth -Size(20)*2, KInputTVViewHeight)];
    inputTV.backgroundColor = DARK_COLOR;
    inputTV.layer.cornerRadius = Size(8);
    inputTV.font = SystemFontOfSize(12);
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
    passwordDesLb.font = BoldSystemFontOfSize(11);
    passwordDesLb.textColor = TEXT_BLACK_COLOR;
    passwordDesLb.text = Localized(@"密码*", nil);
    NSMutableAttributedString *passwordStr = [[NSMutableAttributedString alloc] initWithString:passwordDesLb.text];
    [passwordStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(passwordDesLb.text.length-1,1)];
    passwordDesLb.attributedText = passwordStr;
    [self.view addSubview:passwordDesLb];
    //密码强度
    CGFloat width = Size(18); CGFloat height = Size(5);
    level3View = [[UIView alloc]initWithFrame:CGRectMake(Size(80)+Size(15), passwordDesLb.minY+(passwordDesLb.height -height)/2, width*3, height)];
    level3View.layer.borderWidth = Size(1);
    level3View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
    level3View.layer.cornerRadius = Size(3);
    [self.view addSubview:level3View];
    level2View = [[UIView alloc]initWithFrame:CGRectMake(level3View.minX, level3View.minY, width*2, height)];
    level2View.layer.borderWidth = Size(1);
    level2View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
    level2View.layer.cornerRadius = Size(3);
    [self.view addSubview:level2View];
    level1View = [[UIView alloc]initWithFrame:CGRectMake(level3View.minX, level3View.minY, width, height)];
    level1View.layer.borderWidth = Size(1);
    level1View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
    level1View.layer.cornerRadius = Size(3);
    [self.view addSubview:level1View];
    passwordErrorLb = [[UILabel alloc]init];
    [self.view addSubview:passwordErrorLb];
    pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswCell.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, Size(36));
    [self.view addSubview:pswCell];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(inputTV.minX +Size(10), passwordDesLb.maxY, pswCell.width -Size(20), pswCell.height)];
    passwordTF.delegate = self;
    passwordTF.font = SystemFontOfSize(12);
    passwordTF.textColor = TEXT_BLACK_COLOR;
    passwordTF.placeholder = Localized(@"8~30位数字，英文字母以及特殊字符至少2种组合", nil);
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:passwordTF.placeholder];
    [placeholder addAttribute:NSFontAttributeName
                        value:SystemFontOfSize(8)
                        range:NSMakeRange(0, passwordTF.placeholder.length)];
    passwordTF.attributedPlaceholder = placeholder;
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTF];
    [passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //确认密码
    re_passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, pswCell.maxY +Size(3), inputTV.width, KInputDesViewHeight)];
    re_passwordDesLb.font = BoldSystemFontOfSize(11);
    re_passwordDesLb.textColor = TEXT_BLACK_COLOR;
    re_passwordDesLb.text = Localized(@"确认密码*", nil);
    NSMutableAttributedString *re_passwordStr = [[NSMutableAttributedString alloc] initWithString:re_passwordDesLb.text];
    [re_passwordStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(re_passwordDesLb.text.length-1,1)];
    re_passwordDesLb.attributedText = re_passwordStr;
    [self.view addSubview:re_passwordDesLb];
    re_passwordErrorLb = [[UILabel alloc]init];
    [self.view addSubview:re_passwordErrorLb];
    re_pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    re_pswCell.frame = CGRectMake(pswCell.minX, re_passwordDesLb.maxY, pswCell.width, pswCell.height);
    [self.view addSubview:re_pswCell];
    re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.minX, re_passwordDesLb.maxY, passwordTF.width, passwordTF.height)];
    re_passwordTF.delegate = self;
    re_passwordTF.font = SystemFontOfSize(12);
    re_passwordTF.textColor = TEXT_BLACK_COLOR;
    re_passwordTF.placeholder = Localized(@"请再次确认密码", nil);
    re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    re_passwordTF.secureTextEntry = YES;
    re_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:re_passwordTF];
    [re_passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    //密码提示
    passwordTipDesLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, re_pswCell.maxY +Size(3), inputTV.width, KInputDesViewHeight)];
    passwordTipDesLb.font = BoldSystemFontOfSize(11);
    passwordTipDesLb.textColor = TEXT_BLACK_COLOR;
    passwordTipDesLb.text = Localized(@"密码提示", nil);
    [self.view addSubview:passwordTipDesLb];
    pswTipCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswTipCell.frame = CGRectMake(re_pswCell.minX, passwordTipDesLb.maxY, re_pswCell.width, re_pswCell.height);
    [self.view addSubview:pswTipCell];
    passwordTipTF = [[UITextField alloc] initWithFrame:CGRectMake(re_passwordTF.minX, passwordTipDesLb.maxY, re_passwordTF.width, re_passwordTF.height)];
    passwordTipTF.font = SystemFontOfSize(12);
    passwordTipTF.textColor = TEXT_BLACK_COLOR;
    passwordTipTF.placeholder = Localized(@"选填", nil);
    passwordTipTF.delegate = self;
    [self.view addSubview:passwordTipTF];
    [passwordTipTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    /*****************导入钱包*****************/
    importBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), passwordTipTF.maxY +Size(35), kScreenWidth - 2*Size(20), Size(45))];
    [importBT darkBtnStyle:Localized(@"开始导入", nil)];
    [importBT addTarget:self action:@selector(beginImportAction) forControlEvents:UIControlEventTouchUpInside];
    importBT.userInteractionEnabled = NO;
    [self.view addSubview:importBT];
    

    if (_importWalletType == ImportWalletType_keyStore) {
        
        importTipLb = [[UILabel alloc] initWithFrame:CGRectMake(inputTV.minX, Size(55), inputTV.width, Size(40))];
        importTipLb.font = SystemFontOfSize(11);
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
        passwordDesLb.text = Localized(@"KeyStore密码*", nil);
        NSMutableAttributedString *passwordStr = [[NSMutableAttributedString alloc] initWithString:passwordDesLb.text];
        [passwordStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(passwordDesLb.text.length-1,1)];
        passwordDesLb.attributedText = passwordStr;
        level3View.frame = CGRectMake(Size(120)+Size(15), passwordDesLb.minY+(passwordDesLb.height -height)/2, width*3, height);
        level2View.frame = CGRectMake(level3View.minX, level3View.minY, width*2, height);
        level1View.frame = CGRectMake(level3View.minX, level3View.minY, width, height);
        
        pswCell.frame = CGRectMake(inputTV.minX, passwordDesLb.maxY, inputTV.width, Size(36));
        passwordTF.frame = CGRectMake(inputTV.minX +Size(10), passwordDesLb.maxY, inputTV.width-Size(20), pswCell.height);
        passwordTF.placeholder = nil;
        passwordTF.secureTextEntry = YES;
        passwordTF.placeholder = Localized(@"KeyStore密码", nil);
        passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        re_pswCell.hidden = YES;
        re_passwordDesLb.hidden = YES;
        re_passwordTF.hidden = YES;
        pswTipCell.hidden = YES;
        passwordTipDesLb.hidden = YES;
        passwordTipTF.hidden = YES;
        
        importBT.frame = CGRectMake(Size(20), pswCell.maxY +Size(35), kScreenWidth - 2*Size(20), Size(45));
        placeholderLb.text = Localized(@"Keystore文本内容", nil);
        
    }else if (_importWalletType == ImportWalletType_privateKey) {

        placeholderLb.text = Localized(@"明文私钥", nil);
    }
}

#pragma 导入钱包
-(void)beginImportAction
{
    [self dismissKeyboardAction];
    if (_importWalletType == ImportWalletType_mnemonicPhrase) {
        //验证输入
        if (inputTV.text.length == 0) {
            inputTVErrorLb.hidden = NO;
            [inputTVErrorLb remindError:@"请输入助记词" withY:inputTV.minY -KInputDesViewHeight];
            inputTV.backgroundColor = REMIND_COLOR;
            return;
        }else{
            inputTVErrorLb.hidden = YES;
            inputTV.backgroundColor = DARK_COLOR;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"请输入8~30位密码" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"密码格式错误" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if (re_passwordTF.text.length == 0) {
            re_passwordErrorLb.hidden = NO;
            [re_passwordErrorLb remindError:@"请再次输入密码" withY:re_passwordDesLb.minY];
            re_pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            re_passwordErrorLb.hidden = YES;
            re_pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            re_passwordErrorLb.hidden = NO;
            [re_passwordErrorLb remindError:@"两次密码输入不一致，请重新输入！" withY:re_passwordDesLb.minY];
            re_pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            re_passwordErrorLb.hidden = YES;
            re_pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        //判断钱包超过10个
        if (walletList.count == 10) {
            [self hudShowWithString:Localized(@"钱包个数超过限制", nil) delayTime:2];
            return;
        }

        SECBlockJSAPI *secAPI = [[SECBlockJSAPI alloc]init];
        [secAPI mnemonicToPrivKey:inputTV.text completion:^(NSString * privateKey) {
            if ([privateKey isEqualToString:@"undefined"]) {
                inputTVErrorLb.hidden = NO;
                [inputTVErrorLb remindError:@"助记词有误" withY:inputTV.minY -KInputDesViewHeight];
                inputTV.backgroundColor = REMIND_COLOR;
                [self hiddenLoadingView];
                return;
            }else{
                inputTVErrorLb.hidden = YES;
                inputTV.backgroundColor = DARK_COLOR;
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
                        alert.rightBlock = ^() {
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
                        };
                        return;
                    }
                }
                
                //导入助记词
                [self createLoadingView:Localized(@"导入钱包中···", nil)];
                //添加计时器
                dispatch_async(dispatch_get_main_queue(), ^{
                    _timing = 10;
                    hasImportSuccess = NO;
                    _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
                });
                [HSEther hs_importWalletForPrivateKey:privateKey pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
                    [self hiddenLoadingView];
                    hasImportSuccess = YES;
                    if (error == HSWalletImportPrivateKeySuc) {
                        //导入无须判断重名
                        NSString *nameStr = @"New Import";
                        //分配钱包ICON
                        NSString *iconStr;
                        if ((list.count +1)%2 != 0) {
                            iconStr = @"wallet0";
                        }else{
                            iconStr = @"wallet1";
                        }
                        /*************默认钱包信息*************/
                        NSString *privateKeyStr = [privateKey componentsSeparatedByString:@"x"].lastObject;
                        WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyStr andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:1];
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
        }];
        
    }else if (_importWalletType == ImportWalletType_keyStore) {

        //验证输入
        if (inputTV.text.length == 0) {
            inputTVErrorLb.hidden = NO;
            [inputTVErrorLb remindError:@"请输入KeyStore" withY:inputTV.minY -KInputDesViewHeight];
            inputTV.backgroundColor = REMIND_COLOR;
            return;
        }else{
            inputTVErrorLb.hidden = YES;
            inputTV.backgroundColor = DARK_COLOR;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"请输入8~30位密码" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"密码格式错误" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        //导入KeyStore
        [self createLoadingView:Localized(@"导入钱包中···", nil)];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 10;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importKeyStore:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletErrorKeyStoreLength) {
                inputTVErrorLb.hidden = NO;
                [inputTVErrorLb remindError:@"KeyStore长度不够" withY:inputTV.minY -KInputDesViewHeight];
                inputTV.backgroundColor = REMIND_COLOR;
            }else if (error == HSWalletErrorKeyStoreValid) {
                inputTVErrorLb.hidden = NO;
                [inputTVErrorLb remindError:@"keyStore解密失败" withY:inputTV.minY -KInputDesViewHeight];
                inputTV.backgroundColor = REMIND_COLOR;
            }else if (error == HSWalletImportKeyStoreSuc) {
                inputTVErrorLb.hidden = YES;
                inputTV.backgroundColor = DARK_COLOR;
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
                        alert.rightBlock = ^() {
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
                        };
                        return;
                    }
                }

                NSString *nameStr = @"New Import";
                //分配钱包ICON
                NSString *iconStr;
                if ((list.count +1)%2 != 0) {
                    iconStr = @"wallet0";
                }else{
                    iconStr = @"wallet1";
                }
                /*************默认钱包信息*************/
                NSString *privateKeyStr = [privateKey componentsSeparatedByString:@"x"].lastObject;
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyStr andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
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
            inputTVErrorLb.hidden = NO;
            [inputTVErrorLb remindError:@"请输入私钥" withY:inputTV.minY -KInputDesViewHeight];
            inputTV.backgroundColor = REMIND_COLOR;
            return;
        }else{
            inputTVErrorLb.hidden = YES;
            inputTV.backgroundColor = DARK_COLOR;
        }
        if (inputTV.text.length != 64) {
            inputTVErrorLb.hidden = NO;
            [inputTVErrorLb remindError:@"请输入正确的私钥" withY:inputTV.minY -KInputDesViewHeight];
            inputTV.backgroundColor = REMIND_COLOR;
            return;
        }else{
            inputTVErrorLb.hidden = YES;
            inputTV.backgroundColor = DARK_COLOR;
        }
        if (passwordTF.text.length >30 || passwordTF.text.length <8) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"请输入8~30位密码" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if ([NSString validatePassword:passwordTF.text] == NO) {
            passwordErrorLb.hidden = NO;
            [passwordErrorLb remindError:@"密码格式错误" withY:passwordDesLb.minY];
            pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            passwordErrorLb.hidden = YES;
            pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if (re_passwordTF.text.length == 0) {
            re_passwordErrorLb.hidden = NO;
            [re_passwordErrorLb remindError:@"请再次输入密码" withY:re_passwordDesLb.minY];
            re_pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            re_passwordErrorLb.hidden = YES;
            re_pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        if (![passwordTF.text isEqualToString:re_passwordTF.text]) {
            re_passwordErrorLb.hidden = NO;
            [re_passwordErrorLb remindError:@"两次密码输入不一致，请重新输入！" withY:re_passwordDesLb.minY];
            re_pswCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            re_passwordErrorLb.hidden = YES;
            re_pswCell.contentView.backgroundColor = DARK_COLOR;
        }
        //导入私钥
        [self createLoadingView:Localized(@"导入钱包中···", nil)];
        //添加计时器
        dispatch_async(dispatch_get_main_queue(), ^{
            _timing = 10;
            hasImportSuccess = NO;
            _importTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        });
        [HSEther hs_importWalletForPrivateKey:inputTV.text pwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
            [self hiddenLoadingView];
            hasImportSuccess = YES;
            if (error == HSWalletImportPrivateKeySuc) {
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
                        alert.rightBlock = ^() {
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
                        };
                        return;
                    }
                }
                
                NSString *nameStr = @"New Import";
                //分配钱包ICON
                NSString *iconStr;
                if ((list.count +1)%2 != 0) {
                    iconStr = @"wallet0";
                }else{
                    iconStr = @"wallet1";
                }
                /*************默认钱包信息*************/
                NSString *privateKeyStr = [privateKey componentsSeparatedByString:@"x"].lastObject;
                WalletModel *model = [[WalletModel alloc]initWithWalletName:nameStr andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyStr andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:1 andIsFromMnemonicImport:0];
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
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == passwordTF) {
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == re_passwordTF) {
        re_pswCell.contentView.backgroundColor = DARK_COLOR;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_importWalletType == ImportWalletType_keyStore) {
        if (inputTV.text.length > 0 && passwordTF.text.length > 0) {
            [importBT goldBigBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = YES;
        }else{
            [importBT darkBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = NO;
        }
    }else{
        if (inputTV.text.length > 0 && passwordTF.text.length > 0 && re_passwordTF.text.length > 0) {
            [importBT goldBigBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = YES;
        }else{
            [importBT darkBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = NO;
        }
    }
}

#pragma UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeholderLb.hidden = YES;
    [IQKeyboardManager sharedManager].shouldFixTextViewClip = NO;
    [IQKeyboardManager sharedManager].canAdjustTextView = NO;
    inputTV.backgroundColor = DARK_COLOR;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        placeholderLb.hidden = YES;
    }else{
        placeholderLb.hidden = NO;
    }
    if (_importWalletType == ImportWalletType_keyStore) {
        if (inputTV.text.length > 0 && passwordTF.text.length > 0) {
            [importBT goldBigBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = YES;
        }else{
            [importBT darkBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = NO;
        }
    }else{
        if (inputTV.text.length > 0 && passwordTF.text.length > 0 && re_passwordTF.text.length > 0) {
            [importBT goldBigBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = YES;
        }else{
            [importBT darkBtnStyle:Localized(@"开始导入", nil)];
            importBT.userInteractionEnabled = NO;
        }
    }
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == passwordTipTF) {
        if (passwordTipTF.text.length >= 12) {
            passwordTipTF.text = [textField.text substringToIndex:12];
        }
    }else{
        if (textField.text.length >= 30) {
            textField.text = [textField.text substringToIndex:30];
        }
    }
    if (textField == passwordTF) {
        //密码强度
        if (textField.text.length==0) {
            [self pswStrengthLevel:0];
        }else if ([NSString checkIsHaveNumAndLetter:textField.text] == 1) {
            [self pswStrengthLevel:1];
        }else if ([NSString checkIsHaveNumAndLetter:textField.text] == 2) {
            if (textField.text.length<8) {
                [self pswStrengthLevel:1];
            }else if (textField.text.length>=8) {
                [self pswStrengthLevel:2];
            }
        }else if ([NSString checkIsHaveNumAndLetter:textField.text] == 3) {
            if (textField.text.length<8) {
                [self pswStrengthLevel:1];
            }else if (textField.text.length>=8 && textField.text.length<=12) {
                [self pswStrengthLevel:2];
            }else{
                [self pswStrengthLevel:3];
            }
        }
    }
}
-(void)pswStrengthLevel:(int)level
{
    if (level == 0) {
        level1View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level1View.backgroundColor = WHITE_COLOR;
        level2View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level2View.backgroundColor = WHITE_COLOR;
        level3View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level3View.backgroundColor = WHITE_COLOR;
    }else if (level == 1){
        level1View.layer.borderColor = COLOR(239, 28, 56, 1).CGColor;
        level1View.backgroundColor = COLOR(239, 28, 56, 1);
        level2View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level2View.backgroundColor = WHITE_COLOR;
        level3View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level3View.backgroundColor = WHITE_COLOR;
    }else if (level == 2){
        level1View.layer.borderColor = COLOR(239, 28, 56, 1).CGColor;
        level1View.backgroundColor = COLOR(239, 28, 56, 1);
        level2View.layer.borderColor = COLOR(244, 171, 54, 1).CGColor;
        level2View.backgroundColor = COLOR(244, 171, 54, 1);
        level3View.layer.borderColor = COLOR(210, 210, 210, 210).CGColor;
        level3View.backgroundColor = WHITE_COLOR;
    }else if (level == 3){
        level1View.layer.borderColor = COLOR(239, 28, 56, 1).CGColor;
        level1View.backgroundColor = COLOR(239, 28, 56, 1);
        level2View.layer.borderColor = COLOR(244, 171, 54, 1).CGColor;
        level2View.backgroundColor = COLOR(244, 171, 54, 1);
        level3View.layer.borderColor = COLOR(41, 216, 147, 1).CGColor;
        level3View.backgroundColor = COLOR(41, 216, 147, 1);
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
