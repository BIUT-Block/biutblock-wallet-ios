//
//  ConfirmPasswordViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2019/1/2.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import "ConfirmPasswordViewController.h"
#import "CommonTableViewCell.h"

@interface ConfirmPasswordViewController ()
{
    UITextField *passwordTF;
    UIButton *sureBT;
    
    NSString *passwordStr;
}
@end

@implementation ConfirmPasswordViewController

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
    
    UIButton *cancelBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(70+20), KStatusBarHeight+Size(11), Size(70), Size(24))];
    [cancelBT greenBorderBtnStyle:Localized(@"取消",nil) andBkgImg:@"continue"];
    [cancelBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBT];
    //图片
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(Size(20), cancelBT.maxY +Size(50), Size(42), Size(45))];
    IV.image = [UIImage imageNamed:@"confirmPassword"];
    [self.view addSubview:IV];
    
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(IV.minX, IV.maxY+Size(35), kScreenWidth -IV.minX*2, Size(55))];
    tipLb.font = BoldSystemFontOfSize(20);
    tipLb.textColor = TEXT_BLACK_COLOR;
    tipLb.text = Localized(@"输入密码\n确认密码", nil);
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:tipLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(5);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    tipLb.attributedText = msgStr;
    tipLb.numberOfLines = 2;
    [self.view addSubview:tipLb];
    
    //密码
    UILabel *passwordDesLb = [[UILabel alloc] initWithFrame:CGRectMake(tipLb.minX, tipLb.maxY +Size(25), tipLb.width, Size(25))];
    passwordDesLb.font = BoldSystemFontOfSize(11);
    passwordDesLb.textColor = TEXT_BLACK_COLOR;
    passwordDesLb.text = Localized(@"密码*", nil);
    NSMutableAttributedString *passwordStr = [[NSMutableAttributedString alloc] initWithString:passwordDesLb.text];
    [passwordStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(passwordDesLb.text.length-1,1)];
    passwordDesLb.attributedText = passwordStr;
    [self.view addSubview:passwordDesLb];
    CommonTableViewCell *pswCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    pswCell.frame = CGRectMake(passwordDesLb.minX, passwordDesLb.maxY, passwordDesLb.width, Size(36));
    [self.view addSubview:pswCell];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(pswCell.minX +Size(10), passwordDesLb.maxY, pswCell.width -Size(20), pswCell.height)];
    passwordTF.font = SystemFontOfSize(12);
    passwordTF.textColor = TEXT_BLACK_COLOR;
    passwordTF.placeholder = Localized(@"请输入当前密码", nil);
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTF];
    
    UIButton *sureBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20), passwordTF.maxY +Size(25), kScreenWidth - 2*Size(20), Size(45))];
    [sureBT goldBigBtnStyle:Localized(@"确认", nil)];
    [sureBT addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBT];
    
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制输入12位
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (passwordTF.text.length >= 12) {
        passwordTF.text = [textField.text substringToIndex:12];
        return NO;
    }
    return YES;
}

#pragma mark 确认
-(void)sureAction
{
    [self dismissKeyboardAction];
    
    if ([passwordTF.text isEqualToString:_walletModel.loginPassword]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.sureBlock) {
                self.sureBlock();
            }
        }];
    }else{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"输入密码", nil) contentText:Localized(@"无效的密码\n请重新输入", nil) imageName:@"exclamation_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_exclamation_mark];
        [alert show];
    }
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [passwordTF resignFirstResponder];
}

@end
