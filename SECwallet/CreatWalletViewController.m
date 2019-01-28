//
//  CreatStoreViewController.m
//  CEC_wallet
//
//  Created by Laughing on 2017/9/6.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CreatWalletViewController.h"
#import "CommonTableViewCell.h"
#import "RootViewController.h"
#import "BackupRemindViewController.h"
#import "ImportWalletManageViewController.h"
#import "WalletModel.h"
#import "SECwallet-Swift.h"

@interface CreatWalletViewController ()<UITextFieldDelegate>
{
    UILabel *nameDesLb;
    CommonTableViewCell *nameCell;
    UITextField *walletNameTF;     //钱包名称
    UILabel *nameErrorLb;
    
    UILabel *passwordDesLb;
    CommonTableViewCell *pswCell;
    UITextField *passwordTF;       //密码
    UILabel *passwordErrorLb;
    
    UILabel *re_passwordDesLb;
    CommonTableViewCell *re_pswCell;
    UITextField *re_passwordTF;   //确认密码
    UILabel *re_passwordErrorLb;
    
    UITextField *passwordTipTF;   //密码提示
    
    UIButton *creatBT;
    WalletModel *tempModel;
    
    NSMutableArray *walletList;
}

@end

@implementation CreatWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    /*************获取钱包列表*************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    
    [self addSubView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
        
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)addSubView
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];
    if (_isNoBack == YES) {
        backBT.hidden = YES;
    }
    UIButton *importBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(70+20), KStatusBarHeight+Size(11), Size(80), Size(24))];
    [importBT greenBorderBtnStyle:Localized(@"导入钱包",nil) andBkgImg:@"centerRightBtn"];
    [importBT addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:importBT];
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), importBT.maxY +Size(20), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"创建钱包",nil);
    [self.view addSubview:titleLb];
    
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY, kScreenWidth -titleLb.minX*2, Size(50))];
    tipLb.font = SystemFontOfSize(9);
    tipLb.textColor = TEXT_BLACK_COLOR;
    tipLb.text = Localized(@"密码用于保护私钥和交易授权，强度非常重要。SEC钱包不存储密码，也无法帮您找回，请务必牢记。", nil);
    tipLb.numberOfLines = 4;
    //设置行间距
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:tipLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(2);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    tipLb.attributedText = msgStr;
    [self.view addSubview:tipLb];
    //钱包名
    nameDesLb = [[UILabel alloc] initWithFrame:CGRectMake(tipLb.minX, tipLb.maxY +Size(20), tipLb.width, Size(25))];
    nameDesLb.font = BoldSystemFontOfSize(11);
    nameDesLb.textColor = TEXT_BLACK_COLOR;
    nameDesLb.text = Localized(@"钱包名称*", nil);
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:nameDesLb.text];
    [nameStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(nameDesLb.text.length-1,1)];
    nameDesLb.attributedText = nameStr;
    [self.view addSubview:nameDesLb];
    nameErrorLb = [[UILabel alloc]init];
    [self.view addSubview:nameErrorLb];
    nameCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    nameCell.frame = CGRectMake(nameDesLb.minX, nameDesLb.maxY, nameDesLb.width, Size(36));
    [self.view addSubview:nameCell];
    walletNameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameDesLb.minX +Size(10), nameDesLb.maxY, nameCell.width -Size(20), nameCell.height)];
    walletNameTF.delegate = self;
    walletNameTF.font = SystemFontOfSize(12);
    walletNameTF.textColor = TEXT_BLACK_COLOR;
    walletNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    walletNameTF.placeholder = Localized(@"例如：wallet01", nil);
    [self.view addSubview:walletNameTF];
    //密码
    passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(nameDesLb.minX, nameCell.maxY +Size(3), nameDesLb.width, nameDesLb.height)];
    passwordDesLb.font = BoldSystemFontOfSize(11);
    passwordDesLb.textColor = TEXT_BLACK_COLOR;
    passwordDesLb.text = Localized(@"密码*", nil);
    NSMutableAttributedString *passwordStr = [[NSMutableAttributedString alloc] initWithString:passwordDesLb.text];
    [passwordStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(passwordDesLb.text.length-1,1)];
    passwordDesLb.attributedText = passwordStr;
    [self.view addSubview:passwordDesLb];
    passwordErrorLb = [[UILabel alloc]init];
    [self.view addSubview:passwordErrorLb];
    pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswCell.frame = CGRectMake(passwordDesLb.minX, passwordDesLb.maxY, nameCell.width, nameCell.height);
    [self.view addSubview:pswCell];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(pswCell.minX +Size(10), passwordDesLb.maxY, pswCell.width -Size(20), pswCell.height)];
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
    
    //确认密码
    re_passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(passwordDesLb.minX, pswCell.maxY +Size(3), passwordDesLb.width, passwordDesLb.height)];
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
    
    //密码提示
    UILabel *passwordTipDesLb = [[UILabel alloc] initWithFrame:CGRectMake(re_passwordDesLb.minX, re_pswCell.maxY +Size(3), re_pswCell.width, re_passwordDesLb.height)];
    passwordTipDesLb.font = BoldSystemFontOfSize(11);
    passwordTipDesLb.textColor = TEXT_BLACK_COLOR;
    passwordTipDesLb.text = Localized(@"密码提示", nil);
    [self.view addSubview:passwordTipDesLb];
    CommonTableViewCell *pswTipCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswTipCell.frame = CGRectMake(re_pswCell.minX, passwordTipDesLb.maxY, re_pswCell.width, re_pswCell.height);
    [self.view addSubview:pswTipCell];
    passwordTipTF = [[UITextField alloc] initWithFrame:CGRectMake(re_passwordTF.minX, passwordTipDesLb.maxY, re_passwordTF.width, re_passwordTF.height)];
    passwordTipTF.font = SystemFontOfSize(12);
    passwordTipTF.textColor = TEXT_BLACK_COLOR;
    passwordTipTF.placeholder = Localized(@"选填", nil);
    passwordTipTF.delegate = self;
    [self.view addSubview:passwordTipTF];

    /*****************创建钱包*****************/
    creatBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), passwordTipTF.maxY +Size(40), kScreenWidth - 2*Size(20), Size(45))];
    [creatBT darkBtnStyle:Localized(@"创建钱包", nil)];
    [creatBT addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
    creatBT.userInteractionEnabled = NO;
    [self.view addSubview:creatBT];
    
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == walletNameTF || textField == passwordTipTF) {
        //限制输入12位
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if (walletNameTF.text.length >= 12) {
            walletNameTF.text = [textField.text substringToIndex:12];
            return NO;
        }
        if (passwordTipTF.text.length >= 12) {
            passwordTipTF.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == walletNameTF) {
        nameCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == passwordTF) {
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == re_passwordTF) {
        re_pswCell.contentView.backgroundColor = DARK_COLOR;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (walletNameTF.text.length > 0 && passwordTF.text.length > 0 && re_passwordTF.text.length > 0) {
        [creatBT goldBigBtnStyle:Localized(@"创建钱包", nil)];
        creatBT.userInteractionEnabled = YES;
    }else{
        [creatBT darkBtnStyle:Localized(@"创建钱包", nil)];
        creatBT.userInteractionEnabled = NO;
    }
}

#pragma mark 创建钱包 
-(void)creatAction
{
    [self dismissKeyboardAction];
    if (walletNameTF.text.length == 0) {
        nameErrorLb.hidden = NO;
        [nameErrorLb remindError:@"请输入钱包名称" withY:nameDesLb.minY];
        nameCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        nameErrorLb.hidden = YES;
        nameCell.contentView.backgroundColor = DARK_COLOR;
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
    //判断钱包名是否有重复
    for (WalletModel *model in walletList) {
        if ([walletNameTF.text isEqualToString:model.walletName]) {
            nameErrorLb.hidden = NO;
            [nameErrorLb remindError:@"钱包已存在" withY:nameDesLb.minY];
            nameCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            nameErrorLb.hidden = YES;
            nameCell.contentView.backgroundColor = DARK_COLOR;
        }
    }
    //判断钱包超过10个
    if (walletList.count == 10) {
        [self hudShowWithString:Localized(@"钱包个数超过限制", nil) delayTime:2];
        return;
    }
    
    [self requestCreatWalletBy:passwordTF.text];
}

#pragma 创建钱包
-(void)requestCreatWalletBy:(NSString *)password
{
    //创建钱包 等5秒钟，创建比较慢
    [self createLoadingView:Localized(@"创建钱包中···", nil)];
    [HSEther hs_createWithPwd:passwordTF.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey) {
        [self hiddenLoadingView];
        /*************默认钱包信息*************/
        SECBlockJSAPI *secAPI = [[SECBlockJSAPI alloc]init];
        NSString *privateKeyStr = [privateKey componentsSeparatedByString:@"x"].lastObject;
        [secAPI privKeyToMnemonic:privateKeyStr completion:^(NSString * mnemonicPhrase) {
                        
            NSArray *originalArr = [mnemonicPhrase componentsSeparatedByString:@" "];
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSString *item in originalArr) {
                if (![resultArrM containsObject:item]) {
                    [resultArrM addObject:item];
                }
            }
            if ([originalArr isEqualToArray:resultArrM]) {
                //随机生成钱包ICON
                int i = arc4random() % 2;
                NSString *iconStr = [NSString stringWithFormat:@"wallet%d",i];
                tempModel = [[WalletModel alloc]initWithWalletName:walletNameTF.text andWalletPassword:passwordTF.text andLoginPassword:passwordTF.text andPasswordTip:passwordTipTF.text andAddress:address andMnemonicPhrase:mnemonicPhrase andPrivateKey:privateKeyStr andKeyStore:keyStore andBalance:@"0" andBalance_CNY:@"0" andWalletIcon:iconStr andTokenCoinList:@[@"SEC"] andIsBackUpMnemonic:0 andIsFromMnemonicImport:0];
                
                /*************先获取钱包列表将最新钱包排在末尾并设置为默认钱包*************/
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
                NSData* data2 = [NSData dataWithContentsOfFile:path];
                NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
                NSMutableArray *list = [NSMutableArray array];
                list = [unarchiver decodeObjectForKey:@"walletList"];
                [unarchiver finishDecoding];
                NSMutableData* data = [NSMutableData data];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                if (list.count > 0) {
                    [list insertObject:tempModel atIndex:list.count];
                    [archiver encodeObject:list forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:[NSString stringWithFormat:@"%ld",list.count-1]];
                }else{
                    NSMutableArray *list1 = [NSMutableArray array];
                    [list1 insertObject:tempModel atIndex:0];
                    [archiver encodeObject:list1 forKey:@"walletList"];
                    [archiver finishEncoding];
                    [data writeToFile:path atomically:YES];
                    [[AppDefaultUtil sharedInstance] setDefaultWalletIndex:@"0"];
                }
                
                CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"创建钱包", nil) contentText:[NSString stringWithFormat:@"%@\n",Localized(@"钱包创建成功", nil)] imageName:@"Check_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_Check_mark];
                [alert show];
                alert.leftBlock = ^() {
                    BackupRemindViewController *controller = [[BackupRemindViewController alloc]init];
                    controller.walletModel = tempModel;
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
                    [self presentViewController:navi animated:YES completion:nil];
                };
            }else{
                //重新获取助记词
                [self hudShowWithString:@"创建钱包失败，请重试！" delayTime:2];
            }
        }];
    }];
}

#pragma mark 导入钱包
-(void)importAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [walletNameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];

}

@end
