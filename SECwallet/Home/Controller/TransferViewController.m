//
//  TransferViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/15.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TransferViewController.h"
#import "CommonHtmlShowViewController.h"
#import "TradeDetailView.h"
#import "AddressListViewController.h"
#import "ethers/Account.h"
#import "ethers/JsonRpcProvider.h"
#import "ethers/SecureData.h"
#import "CommonTableViewCell.h"
#import "ConfirmPasswordViewController.h"
#import "SECwallet-Swift.h"

@interface TransferViewController ()<TradeDetailViewDelegate,UITextFieldDelegate,AddressListViewControllerDelegate>
{
    UILabel *addressLb;
    UILabel *addressErrorLb;
    CommonTableViewCell *addressCell;
    UIScrollView *addressContentView;
    UITextField *addressTF;
    
    UILabel *moneyDesLb;
    UILabel *moneyErrorLb;
    CommonTableViewCell *moneyCell;
    UITextField *moneyTF;
    
    UITextField *remarkTF;   //备注
    UILabel *gasLb;
}

@property (nonatomic, strong) TradeDetailView *tradeDetailView;

@end

@implementation TransferViewController

//------- 懒加载 -------//
- (TradeDetailView *)tradeDetailView {
    if (!_tradeDetailView) {
        _tradeDetailView = [[TradeDetailView alloc]init];
        _tradeDetailView.delegate = self;
    }
    return _tradeDetailView;
}

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

    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(10), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = [NSString stringWithFormat:@"SEC %@",Localized(@"转账",nil)];
    [self.view addSubview:titleLb];
    
    addressLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(45), Size(200), Size(25))];
    addressLb.font = BoldSystemFontOfSize(11);
    addressLb.textColor = TEXT_BLACK_COLOR;
    addressLb.text = Localized(@"收款人钱包地址*", nil);
    NSMutableAttributedString *addressStr = [[NSMutableAttributedString alloc] initWithString:addressLb.text];
    [addressStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(addressLb.text.length-1,1)];
    addressLb.attributedText = addressStr;
    [self.view addSubview:addressLb];
    addressErrorLb = [[UILabel alloc]init];
    [self.view addSubview:addressErrorLb];
    addressCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addressCell.frame = CGRectMake(addressLb.minX, addressLb.maxY, kScreenWidth-addressLb.minX*2, Size(36));
    [self.view addSubview:addressCell];
    addressContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(Size(10), 0, addressCell.width -Size(10 +45), addressCell.height)];
    addressContentView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [addressCell addSubview:addressContentView];
    addressTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, addressContentView.width, addressContentView.height)];
    addressTF.font = SystemFontOfSize(12);
    addressTF.textColor = TEXT_BLACK_COLOR;
    addressTF.delegate = self;
    addressTF.keyboardType = UIKeyboardTypeNamePhonePad;
    [addressContentView addSubview:addressTF];
    //地址薄
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(addressCell.width -Size(30), 0, Size(30), addressCell.height)];
    [addressBtn addTarget:self action:@selector(addressListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [addressCell addSubview:addressBtn];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(addressCell.width -Size(8 +20), (addressCell.height -Size(10))/2, Size(8), Size(10))];
    iv.image = [UIImage imageNamed:@"addressBook"];
    [addressCell addSubview:iv];
    
    //金额
    moneyDesLb = [[UILabel alloc] initWithFrame:CGRectMake(addressLb.minX, addressCell.maxY +Size(4), addressLb.width, addressLb.height)];
    moneyDesLb.font = BoldSystemFontOfSize(11);
    moneyDesLb.textColor = TEXT_BLACK_COLOR;
    moneyDesLb.text = Localized(@"转账金额*", nil);
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:moneyDesLb.text];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(moneyDesLb.text.length-1,1)];
    moneyDesLb.attributedText = moneyStr;
    [self.view addSubview:moneyDesLb];
    moneyErrorLb = [[UILabel alloc]init];
    [self.view addSubview:moneyErrorLb];
    moneyCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    moneyCell.frame = CGRectMake(moneyDesLb.minX, moneyDesLb.maxY, addressCell.width,addressCell.height);
    [self.view addSubview:moneyCell];
    moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(Size(10), 0, moneyCell.width -Size(20), moneyCell.height)];
    moneyTF.delegate = self;
    moneyTF.font = SystemFontOfSize(12);
    moneyTF.textColor = TEXT_BLACK_COLOR;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [moneyCell addSubview:moneyTF];
    
    //备注
    UILabel *remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(moneyDesLb.minX, moneyCell.maxY +Size(4), moneyDesLb.width, moneyDesLb.height)];
    remarkLb.font = BoldSystemFontOfSize(11);
    remarkLb.textColor = TEXT_BLACK_COLOR;
    remarkLb.text = Localized(@"备注", nil);
    [self.view addSubview:remarkLb];
    CommonTableViewCell *markCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    markCell.frame = CGRectMake(remarkLb.minX, remarkLb.maxY, moneyCell.width, moneyCell.height);
    [self.view addSubview:markCell];
    remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(moneyTF.minX, 0, moneyTF.width, moneyTF.height)];
    remarkTF.font = SystemFontOfSize(12);
    remarkTF.textColor = TEXT_BLACK_COLOR;
    [markCell addSubview:remarkTF];
    
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake(markCell.minX, markCell.maxY +Size(40), markCell.width, Size(45))];
    [nextBT goldBigBtnStyle:Localized(@"下一步", nil)];
    [nextBT addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
    
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == addressTF) {
        CGSize size = [textField.text calculateSize:SystemFontOfSize(12) maxWidth:kScreenWidth*2];
        if (size.width > kScreenWidth -Size(75)) {
            addressTF.frame = CGRectMake(0, 0, size.width, Size(36));
            [addressContentView setContentSize:CGSizeMake(size.width+Size(10), Size(36))];
        }else{
            addressTF.frame = CGRectMake(0, 0, kScreenWidth -Size(15 +45), Size(36));
            [addressContentView setContentSize:CGSizeMake(kScreenWidth -Size(15 +45), Size(36))];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == addressTF) {
        addressCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == moneyTF) {
        moneyCell.contentView.backgroundColor = DARK_COLOR;
    }
}

#pragma mark 下一步
-(void)nextAction
{
    [self dismissKeyboardAction];
    if (addressTF.text.length == 0) {
        addressErrorLb.hidden = NO;
        [addressErrorLb remindError:@"请输入收款人钱包地址" withY:addressLb.minY];
        addressCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        addressErrorLb.hidden = YES;
        addressCell.contentView.backgroundColor = DARK_COLOR;
    }
    //判断扫描的是否为钱包地址(前缀是0x并且长度为42位)
    if (!([addressTF.text hasPrefix:@"0x"] && addressTF.text.length == 42)) {
        addressErrorLb.hidden = NO;
        [addressErrorLb remindError:@"地址不正确，请重新输入" withY:addressLb.minY];
        addressCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        addressErrorLb.hidden = YES;
        addressCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([addressTF.text isEqualToString:_walletModel.address]) {
        addressErrorLb.hidden = NO;
        [addressErrorLb remindError:@"同一地址之间不能转账" withY:addressLb.minY];
        addressCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        addressErrorLb.hidden = YES;
        addressCell.contentView.backgroundColor = DARK_COLOR;
    }
    if (moneyTF.text.length == 0) {
        moneyErrorLb.hidden = NO;
        [moneyErrorLb remindError:@"请输入转账金额" withY:moneyDesLb.minY];
        moneyCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        moneyErrorLb.hidden = YES;
        moneyCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([moneyTF.text doubleValue] == 0) {
        moneyErrorLb.hidden = NO;
        [moneyErrorLb remindError:@"转账金额不能为零" withY:moneyDesLb.minY];
        moneyCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        moneyErrorLb.hidden = YES;
        moneyCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([_walletModel.balance doubleValue] < [moneyTF.text doubleValue] && [moneyTF.text doubleValue] > 0) {
        moneyErrorLb.hidden = NO;
        [moneyErrorLb remindError:@"余额不足" withY:moneyDesLb.minY];
        moneyCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        moneyErrorLb.hidden = YES;
        moneyCell.contentView.backgroundColor = DARK_COLOR;
    }
    if ([moneyTF.text containsString:@"."]) {
        NSString *decimalStr = [moneyTF.text componentsSeparatedByString:@"."].lastObject;
        if (decimalStr.length > 8) {
            moneyErrorLb.hidden = NO;
            [moneyErrorLb remindError:@"小数点后只允许输入8位" withY:moneyDesLb.minY];
            moneyCell.contentView.backgroundColor = REMIND_COLOR;
            return;
        }else{
            moneyErrorLb.hidden = YES;
            moneyCell.contentView.backgroundColor = DARK_COLOR;
        }
    }
    
    NSString *gasStr = [gasLb.text componentsSeparatedByString:@"sec"].firstObject;
    [self.tradeDetailView initTradeDetailViewWith:addressTF.text payAddress:_walletModel.address gasPrice:gasStr sum:moneyTF.text tokenName:_tokenCoinModel.name];
}

#pragma TradeDetailViewDelegate
-(void)clickFinish
{
    ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
    controller.walletModel = _walletModel;
    [self presentViewController:controller animated:YES completion:nil];
    controller.sureBlock = ^() {
        /***************************开始转账****************************/
        [self createLoadingView:Localized(@"正在转账...", nil)];
        //去掉0x
        NSString *privateKey = [_walletModel.privateKey componentsSeparatedByString:@"x"].lastObject;
        NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
        NSString *to = [addressTF.text componentsSeparatedByString:@"x"].lastObject;
        NSString *value = moneyTF.text;
        NSString *inputData = remarkTF.text.length > 0 ? remarkTF.text : @"";
        NSString *jsonStr = [NSString stringWithFormat:@"{\"privateKey\":\"%@\",\"from\":\"%@\",\"to\":\"%@\",\"value\":\"%@\",\"inputData\":\"%@\"}",privateKey,from,to,value,inputData];
        SECBlockJSAPI *secAPI = [[SECBlockJSAPI alloc]init];
        [secAPI txSign:jsonStr completion:^(NSString * value) {
            NSDictionary *dic = [NSString parseJSONStringToNSDictionary:value];
            NSMutableDictionary *ddd = [[NSMutableDictionary alloc]initWithDictionary:dic];
            AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
            [client invokeMethod:@"sec_sendRawTransaction" withParameters:@[ddd] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self hiddenLoadingView];
                NSDictionary *dic = responseObject;
                NSInteger status = [dic[@"status"] integerValue];
                if (status == 1) {
                    [self backAction];
                    [self.delegate transferSuccess:nil];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Localized(@"转账失败", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"知道了", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hiddenLoadingView];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"转账失败" message:nil delegate:nil cancelButtonTitle:Localized(@"知道了", nil) otherButtonTitles:nil, nil];
                [alert show];
            }];
        }];
    };
}

#pragma 地址薄
-(void)addressListBtnAction
{
    [self dismissKeyboardAction];
    AddressListViewController *controller = [[AddressListViewController alloc]init];
    controller.delegate = self;
    controller.isDelegate = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [addressTF resignFirstResponder];
    [moneyTF resignFirstResponder];
    [remarkTF resignFirstResponder];
}

#pragma AddressListViewControllerDelegate
-(void)sendScanCode:(NSString *)codeStr
{
    if ([codeStr containsString:@"###"]) {
        NSArray *arr = [codeStr componentsSeparatedByString:@"###"];
        addressTF.text = arr[0];
        moneyTF.text = arr[1];
    }else{
        addressTF.text = codeStr;
    }
    CGSize size = [addressTF.text calculateSize:SystemFontOfSize(12) maxWidth:kScreenWidth*2];
    addressTF.frame = CGRectMake(0, 0, size.width+Size(10), Size(36));
    [addressContentView setContentSize:CGSizeMake(size.width, Size(36))];
}

@end
