//
//  BackupFileBeforeViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/8.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupFileBeforeViewController.h"
#import "BackupFileViewController.h"
#import "WalletModel.h"

@interface BackupFileBeforeViewController ()

@end

@implementation BackupFileBeforeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"请勿截图", nil) contentText:Localized(@"如果有人获取你的助记词将直接获取你的资产！\n请抄下助记词并放在安全的地方。", nil) imageName:nil leftButtonTitle:Localized(@"知道了", nil) rightButtonTitle:nil alertViewType:CommonAlertViewType_remind];
        [alert show];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)setupUI
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];

    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(35), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"备份助记词",nil);
    [self.view addSubview:titleLb];
    
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(35), kScreenWidth, Size(20))];
    titLb.font = SystemFontOfSize(10);
    titLb.textColor = TEXT_DARK_COLOR;
    titLb.text = Localized(@"抄写下你的钱包助记词", nil);
    [self.view addSubview:titLb];
    
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titLb.maxY +Size(10), kScreenWidth -Size(20)*2, Size(45))];
    remindLb.font = SystemFontOfSize(10);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.numberOfLines = 3;
    remindLb.text = Localized(@"助记词用于恢复钱包或重置钱包密码，将它准确的抄写到纸上，并存放在的只有你知道的安全的地方。", nil);
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:remindLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(3);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    remindLb.attributedText = msgStr;
    [self.view addSubview:remindLb];
    
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(remindLb.minX, remindLb.maxY +Size(20), remindLb.width, Size(75))];
    bkgView.backgroundColor = DARK_COLOR;
    bkgView.layer.cornerRadius = Size(5);
    [self.view addSubview:bkgView];
    UILabel *fileDataLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(8), Size(8), bkgView.width -Size(16), bkgView.height-Size(16))];
    fileDataLb.font = BoldSystemFontOfSize(12);
    fileDataLb.textColor = TEXT_BLACK_COLOR;
    fileDataLb.numberOfLines = 3;
    fileDataLb.text = _walletModel.mnemonicPhrase;
    NSMutableAttributedString *msgStr1 = [[NSMutableAttributedString alloc] initWithString:fileDataLb.text];
    [msgStr1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr1.length)];
    fileDataLb.attributedText = msgStr1;
    [bkgView addSubview:fileDataLb];
    
    /*****************下一步*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake(titleLb.minX, bkgView.maxY +Size(25), kScreenWidth -titleLb.minX*2, Size(45))];
    [nextBT goldBigBtnStyle:@"下一步"];
    [nextBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

-(void)nextAction
{
    BackupFileViewController *controller = [[BackupFileViewController alloc]init];
    controller.walletModel = _walletModel;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
