//
//  ChangePasswordViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/13.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ImportWalletManageViewController.h"
#import "CommonTableViewCell.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
{
    UILabel *pswErrorLb;
    CommonTableViewCell *pswCell;
    UITextField *passwordTF;       //密码
    
    UILabel *newpswErrorLb;
    CommonTableViewCell *newpswCell;
    UITextField *newpasswordTF;    //新密码
    UILabel *placeholder;
    UIView *level1View;
    UIView *level2View;
    UIView *level3View;
    
    UILabel *re_pswErrorLb;
    CommonTableViewCell *re_pswCell;
    UITextField *re_passwordTF;   //重复新密码
    UITextField *passwordTipTF;   //密码提示
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    UIButton *completeBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(60+20), KStatusBarHeight+Size(11), Size(60), Size(24))];
    [completeBT greenBorderBtnStyle:Localized(@"完成",nil) andBkgImg:@"smallRightBtn"];
    [completeBT addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBT];
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), completeBT.maxY +Size(10), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"更改密码",nil);
    [self.view addSubview:titleLb];
    
    //当前密码
    pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswCell.frame = CGRectMake(titleLb.minX, titleLb.maxY +Size(30), kScreenWidth -titleLb.minX*2, Size(42));
    [self.view addSubview:pswCell];
    pswErrorLb = [[UILabel alloc]init];
    [self.view addSubview:pswErrorLb];
    UILabel *passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(10), 0, Size(110), pswCell.height)];
    passwordDesLb.font = BoldSystemFontOfSize(11);
    passwordDesLb.textColor = TEXT_BLACK_COLOR;
    passwordDesLb.text = Localized(@"当前密码*", nil);
    NSMutableAttributedString *pswStr = [[NSMutableAttributedString alloc] initWithString:passwordDesLb.text];
    [pswStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(passwordDesLb.text.length-1,1)];
    passwordDesLb.attributedText = pswStr;
    [pswCell addSubview:passwordDesLb];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordDesLb.maxX +Size(10), passwordDesLb.minY, Size(145), pswCell.height)];
    passwordTF.delegate = self;
    passwordTF.font = SystemFontOfSize(12);
    passwordTF.textColor = TEXT_BLACK_COLOR;
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.placeholder = Localized(@"请输入当前密码", nil);
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pswCell addSubview:passwordTF];
    [passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //密码强度
    CGFloat width = Size(18); CGFloat height = Size(5);
    level3View = [[UIView alloc]initWithFrame:CGRectMake(pswCell.minX+Size(10), pswCell.maxY+Size(15-height)/2, width*3, height)];
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
    //新密码
    newpswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    newpswCell.frame = CGRectMake(pswCell.minX, pswCell.maxY +Size(15), pswCell.width, pswCell.height);
    [self.view addSubview:newpswCell];
    newpswErrorLb = [[UILabel alloc]init];
    [self.view addSubview:newpswErrorLb];
    UILabel *newpasswordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(passwordDesLb.minX, 0, passwordDesLb.width, newpswCell.height)];
    newpasswordDesLb.font = BoldSystemFontOfSize(11);
    newpasswordDesLb.textColor = TEXT_BLACK_COLOR;
    newpasswordDesLb.text = Localized(@"新密码*", nil);
    NSMutableAttributedString *newpswStr = [[NSMutableAttributedString alloc] initWithString:newpasswordDesLb.text];
    [newpswStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(newpasswordDesLb.text.length-1,1)];
    newpasswordDesLb.attributedText = newpswStr;
    [newpswCell addSubview:newpasswordDesLb];
    newpasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(newpasswordDesLb.maxX +Size(10), 0, passwordTF.width, newpswCell.height)];
    newpasswordTF.delegate = self;
    newpasswordTF.font = SystemFontOfSize(12);
    newpasswordTF.textColor = TEXT_BLACK_COLOR;
    newpasswordTF.keyboardType = UIKeyboardTypeASCIICapable;
    newpasswordTF.secureTextEntry = YES;
    newpasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [newpswCell addSubview:newpasswordTF];
    [newpasswordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    placeholder = [[UILabel alloc]initWithFrame:CGRectMake(newpasswordTF.minX, 0, newpasswordTF.width, newpasswordTF.height)];
    placeholder.font = SystemFontOfSize(7);
    placeholder.textColor = TEXT_LightDark_COLOR;
    placeholder.numberOfLines = 2;
    placeholder.text = Localized(@"8~30位数字，英文字母以及特殊字符至少2种组合", nil);
    [newpswCell addSubview:placeholder];
    
    //确认密码
    re_pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    re_pswCell.frame = CGRectMake(newpswCell.minX, newpswCell.maxY +Size(15), pswCell.width, pswCell.height);
    [self.view addSubview:re_pswCell];
    re_pswErrorLb = [[UILabel alloc]init];
    [self.view addSubview:re_pswErrorLb];
    UILabel *re_passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(passwordDesLb.minX, 0, passwordDesLb.width, re_pswCell.height)];
    re_passwordDesLb.font = BoldSystemFontOfSize(11);
    re_passwordDesLb.textColor = TEXT_BLACK_COLOR;
    re_passwordDesLb.text = Localized(@"确认密码*", nil);
    NSMutableAttributedString *re_pswStr = [[NSMutableAttributedString alloc] initWithString:re_passwordDesLb.text];
    [re_pswStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(re_passwordDesLb.text.length-1,1)];
    re_passwordDesLb.attributedText = re_pswStr;
    [re_pswCell addSubview:re_passwordDesLb];
    re_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordDesLb.maxX +Size(10), 0, passwordTF.width, passwordTF.height)];
    re_passwordTF.delegate = self;
    re_passwordTF.font = SystemFontOfSize(12);
    re_passwordTF.textColor = TEXT_BLACK_COLOR;
    re_passwordTF.placeholder = Localized(@"请再次确认密码", nil);
    re_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    re_passwordTF.secureTextEntry = YES;
    re_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [re_pswCell addSubview:re_passwordTF];
    [re_passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //密码提示
    CommonTableViewCell *pswTipCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswTipCell.frame = CGRectMake(re_pswCell.minX, re_pswCell.maxY +Size(15), re_pswCell.width, re_pswCell.height);
    [self.view addSubview:pswTipCell];
    UILabel *passwordTipDesLb = [[UILabel alloc] initWithFrame:CGRectMake(re_passwordDesLb.minX, 0, re_passwordDesLb.width, pswTipCell.height)];
    passwordTipDesLb.font = BoldSystemFontOfSize(11);
    passwordTipDesLb.textColor = TEXT_BLACK_COLOR;
    passwordTipDesLb.text = Localized(@"密码提示", nil);
    [pswTipCell addSubview:passwordTipDesLb];
    passwordTipTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTipDesLb.maxX +Size(10), 0, re_passwordTF.width, pswTipCell.height)];
    passwordTipTF.font = SystemFontOfSize(12);
    passwordTipTF.textColor = TEXT_BLACK_COLOR;
    passwordTipTF.placeholder = Localized(@"选填", nil);
    passwordTipTF.delegate = self;
    [pswTipCell addSubview:passwordTipTF];
    
    UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(30), pswTipCell.maxY +Size(30), pswTipCell.width, Size(30))];
    desLb.font = SystemFontOfSize(10);
    desLb.textColor = TEXT_DARK_COLOR;
    desLb.numberOfLines = 2;
    desLb.text = Localized(@"忘记密码？\n导入助记词或私钥可重置密码", nil);
    [self.view addSubview:desLb];
    UIButton *importBtn = [[UIButton alloc] initWithFrame:CGRectMake(desLb.minX, desLb.maxY+Size(20), kScreenWidth-desLb.minX*2, Size(50))];
    [importBtn customerBtnStyle:[NSString stringWithFormat:@"         %@",Localized(@"马上导入",nil)] andBkgImg:@"importNow"];
    importBtn.titleLabel.font = SystemFontOfSize(10);
    [importBtn setTitleColor:TEXT_GREEN_COLOR forState:UIControlStateNormal];
    [importBtn addTarget:self action:@selector(importBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:importBtn];
}

#pragma mark 完成
-(void)savePassword
{
    [self dismissKeyboardAction];
    if (passwordTF.text.length >30 || passwordTF.text.length <8) {
        pswErrorLb.hidden = NO;
        [pswErrorLb remindError:@"请输入8~30位密码" withY:pswCell.minY-Size(25)];
        pswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        pswErrorLb.hidden = YES;
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([NSString validatePassword:passwordTF.text] == NO) {
        pswErrorLb.hidden = NO;
        [pswErrorLb remindError:@"密码格式错误" withY:pswCell.minY-Size(25)];
        pswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        pswErrorLb.hidden = YES;
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if (![passwordTF.text isEqualToString:_walletModel.loginPassword]) {
        pswErrorLb.hidden = NO;
        [pswErrorLb remindError:@"当前密码验证失败" withY:pswCell.minY-Size(25)];
        pswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        pswErrorLb.hidden = YES;
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }
    
    if (newpasswordTF.text.length >30 || newpasswordTF.text.length <8) {
        newpswErrorLb.hidden = NO;
        [newpswErrorLb remindError:@"请输入8~30位密码" withY:newpswCell.minY-Size(20)];
        newpswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        newpswErrorLb.hidden = YES;
        newpswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([NSString validatePassword:newpasswordTF.text] == NO) {
        newpswErrorLb.hidden = NO;
        [newpswErrorLb remindError:@"密码格式错误" withY:newpswCell.minY-Size(20)];
        newpswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        newpswErrorLb.hidden = YES;
        newpswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if (re_passwordTF.text.length == 0) {
        re_pswErrorLb.hidden = NO;
        [re_pswErrorLb remindError:@"请再次输入密码" withY:re_pswCell.minY-Size(20)];
        re_pswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        re_pswErrorLb.hidden = YES;
        re_pswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if (![newpasswordTF.text isEqualToString:re_passwordTF.text]) {
        re_pswErrorLb.hidden = NO;
        [re_pswErrorLb remindError:@"两次密码输入不一致，请重新输入！" withY:re_pswCell.minY-Size(20)];
        re_pswCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        re_pswErrorLb.hidden = YES;
        re_pswCell.contentView.backgroundColor = DARK_COLOR;
    }
    if (newpasswordTF.text.length > 0) {
        [self createLoadingView:nil];
        /***********更新当前钱包信息***********/
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *list = [NSMutableArray array];
        list = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        for (int i = 0; i< list.count; i++) {
            WalletModel *model = list[i];
            if ([model.privateKey isEqualToString:_walletModel.privateKey]) {
                [model setLoginPassword:newpasswordTF.text];
                [model setPasswordTip:passwordTipTF.text];
                [list replaceObjectAtIndex:i withObject:model];
            }
        }
        //替换list中当前钱包信息
        NSMutableData* data = [NSMutableData data];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:list forKey:@"walletList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
        //延迟执行
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
}
-(void)delayMethod
{
    [self hiddenLoadingView];
    [self backAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == passwordTF) {
        pswCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == newpasswordTF) {
        placeholder.hidden = YES;
        newpswCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == re_passwordTF) {
        re_pswCell.contentView.backgroundColor = DARK_COLOR;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == newpasswordTF && newpasswordTF.text.length == 0) {
        placeholder.hidden = NO;
    }
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == passwordTipTF) {
        //限制输入12位
        if (textField.text.length >= 12) {
            passwordTipTF.text = [textField.text substringToIndex:12];
        }
    }else{
        if (textField.text.length >= 30) {
            textField.text = [textField.text substringToIndex:30];
        }
    }
    if (textField == newpasswordTF) {
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

-(void)importBtnAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [passwordTF resignFirstResponder];
    [newpasswordTF resignFirstResponder];
    [re_passwordTF resignFirstResponder];
    [passwordTipTF resignFirstResponder];
}

@end
