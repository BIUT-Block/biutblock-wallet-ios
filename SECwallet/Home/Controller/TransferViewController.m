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

@interface TransferViewController ()<TradeDetailViewDelegate,UITextFieldDelegate,AddressListViewControllerDelegate>
{
    UIScrollView *addressContentView;
    UITextField *addressTF;
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
    titleLb.text = Localized(@"SEC转账",nil);
    [self.view addSubview:titleLb];
    
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(45), Size(200), Size(25))];
    addressLb.font = BoldSystemFontOfSize(10);
    addressLb.textColor = TEXT_BLACK_COLOR;
    addressLb.text = Localized(@"收款人钱包地址", nil);
    [self.view addSubview:addressLb];
    CommonTableViewCell *addressCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(addressCell.width -Size(20 +20), (addressCell.height -Size(20))/2, Size(20), Size(20))];
    [addressBtn setBackgroundImage:[UIImage imageNamed:@"contact"] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(addressListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [addressCell addSubview:addressBtn];
    
    //金额
    UILabel *moneyDesLb = [[UILabel alloc] initWithFrame:CGRectMake(addressLb.minX, addressCell.maxY +Size(4), addressLb.width, addressLb.height)];
    moneyDesLb.font = BoldSystemFontOfSize(10);
    moneyDesLb.textColor = TEXT_BLACK_COLOR;
    moneyDesLb.text = Localized(@"转账金额", nil);
    [self.view addSubview:moneyDesLb];
    CommonTableViewCell *moneyCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    moneyCell.frame = CGRectMake(moneyDesLb.minX, moneyDesLb.maxY, addressCell.width,addressCell.height);
    [self.view addSubview:moneyCell];
    moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(Size(10), 0, moneyCell.width -Size(20), moneyCell.height)];
    moneyTF.font = SystemFontOfSize(12);
    moneyTF.textColor = TEXT_BLACK_COLOR;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [moneyCell addSubview:moneyTF];
    
    //备注
    UILabel *remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(moneyDesLb.minX, moneyCell.maxY +Size(4), moneyDesLb.width, moneyDesLb.height)];
    remarkLb.font = BoldSystemFontOfSize(10);
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
    CGSize size = [textField.text calculateSize:SystemFontOfSize(12) maxWidth:kScreenWidth*2];
    if (size.width > kScreenWidth -Size(75)) {
        addressTF.frame = CGRectMake(0, 0, size.width, Size(36));
        [addressContentView setContentSize:CGSizeMake(size.width+Size(10), Size(36))];
    }else{
        addressTF.frame = CGRectMake(0, 0, kScreenWidth -Size(15 +45), Size(36));
        [addressContentView setContentSize:CGSizeMake(kScreenWidth -Size(15 +45), Size(36))];
    }
}

#pragma mark 下一步
-(void)nextAction
{
    addressTF.text = @"0xfa9461cc20fbb1b0937aa07ec6afc5e660fe2afd";
    [self dismissKeyboardAction];
    if (addressTF.text.length == 0) {
        [self hudShowWithString:@"请输入收款人钱包地址" delayTime:1.5];
        return;
    }
    //判断扫描的是否为钱包地址(前缀是0x并且长度为42位)
    if (!([addressTF.text hasPrefix:@"0x"] && addressTF.text.length == 42)) {
        [self hudShowWithString:@"地址不正确，请重新输入" delayTime:1.5];
        return;
    }
    if ([addressTF.text isEqualToString:_walletModel.address]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"同一地址之间不能转账哦" message:@"您的收款地址和当前钱包地址一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView show];
        return;
    }
    if (moneyTF.text.length == 0) {
        [self hudShowWithString:@"请输入转账金额" delayTime:1.5];
        return;
    }
    if ([moneyTF.text floatValue] == 0) {
        [self hudShowWithString:@"转账金额不能为零" delayTime:1.5];
        return;
    }
    if ([moneyTF.text floatValue] > [_tokenCoinModel.tokenNum floatValue]) {
        [self hudShowWithString:@"代币余额不足，无法转账" delayTime:1.5];
        return;
    }
    if ([_walletModel.balance floatValue] == 0) {
        [self hudShowWithString:@"钱包余额不足，无法转账" delayTime:1.5];
        return;
    }
    
    NSString *gasStr = [gasLb.text componentsSeparatedByString:@"eth"].firstObject;
    [self.tradeDetailView initTradeDetailViewWith:addressTF.text payAddress:_walletModel.address gasPrice:gasStr sum:moneyTF.text tokenName:_tokenCoinModel.name];
}

-(void)tipBtnAction
{
    [self dismissKeyboardAction];
    CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.commonHtmlShowViewType = CommonHtmlShowViewType_RgsProtocol;
    viewController.titleStr = @"什么是GAS费用？";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma TradeDetailViewDelegate
-(void)clickFinish
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入钱包密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pswTF = alertController.textFields.firstObject;
        if (pswTF.text.length == 0) {
            [self hudShowWithString:@"密码不能为空" delayTime:1];
            return;
        }else{
            if ([pswTF.text isEqualToString:_walletModel.loginPassword]) {
                /***************************开始转账****************************/
                [self createLoadingView:Localized(@"正在转账...", nil)];
//                __block Account *a;
//                __block JsonRpcProvider *e = [[JsonRpcProvider alloc]initWithChainId:ChainIdHomestead url:[NSURL URLWithString:BaseServerUrl]];
//                NSData *jsonData = [_walletModel.keyStore dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                    options:NSJSONReadingMutableContainers
//                                                                      error:&err];
//                //地址
//                __block NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
//                __block Transaction *transaction = [Transaction transactionWithFromAddress:[Address addressWithString:addressStr]];
//                //1 account自己解密
//                NSLog(@"1 开始新建钱包");
//                __block Signature *signature;
////                NSString *r_str;NSString *s_str;NSString *v_str;
//                [Account decryptSecretStorageJSON:_walletModel.keyStore password:_walletModel.walletPassword callback:^(Account *account, NSError *NSError) {
//                    if (NSError == nil){
//                        a = account;
//                        transaction.nonce = 1;  //????
//                        NSLog(@"4 开始获取gasPrice");
//                        transaction.gasPrice = [BigNumber bigNumberWithDecimalString:@"0"];
//                        transaction.toAddress = [Address addressWithString:addressTF.text];
//                        //转账金额
//                        BigNumber *b = [BigNumber bigNumberWithDecimalString:moneyTF.text];
//                        transaction.value = b;
//                        //如果是eth转账
//                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"0"];
//                        transaction.data = [SecureData secureDataWithCapacity:0].data;
//                        //签名
//                        [a sign:transaction];
//                        //发送
////                        NSData *signedTransaction = [transaction serialize];
//                        NSLog(@"6 开始转账");
//                        signature = transaction.signature;
//                        NSLog(@"\n%@\n%@\n%d",[SecureData dataToHexString:signature.r],[SecureData dataToHexString:signature.s],signature.v);
//
//                    }else{
//                        NSLog(@"密码错误");
//                    }
//                }];
//
//
                //地址去掉0x
                NSString *from = [_walletModel.address componentsSeparatedByString:@"x"].lastObject;
                NSString *to = [addressTF.text componentsSeparatedByString:@"x"].lastObject;
                NSString *value = [NSString hex_16_StringFromDecimal:[moneyTF.text integerValue]];
                value = moneyTF.text;
                NSString *timestamp = [NSString stringWithFormat:@"%0.f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000];
//                NSDictionary *data = @{@"v":@(signature.v),@"r":[[SecureData dataToHexString:signature.r] componentsSeparatedByString:@"x"].lastObject,@"s":[[SecureData dataToHexString:signature.s] componentsSeparatedByString:@"x"].lastObject};
                NSString *inputData = remarkTF.text.length > 0 ? remarkTF.text : @"";
                
                //            timestamp: 1543457005562, // number
                //            from: 'fa9461cc20fbb1b0937aa07ec6afc5e660fe2afd', // 40 bytes address
                //            to: '8df9628de741b3d42c6f4a29ed4572b0f05fe8b4', // 40 bytes address
                //            value: '110.5235', // string
                //            gasLimit: '0', // string, temporarily set to 0
                //            gas: '0', // string, temporarily set to 0
                //            gasPrice: '0', // string, temporarily set to 0
                //            inputData: 'Sec test transaction', // string, user defined extra messages
                //            data: {
                //            v: 28, // number
                //            r: 'f17c29dd068953a474675a65f59c75c6189c426d1c60f43570cc7220ca3616c3', // 64 bytes string
                //            s: '54f9ff243b903b7419dd566f277eedadf6aa55161f5d5e42005af29b14577902' // 64 bytes string
                //            }
                
                NSDictionary *data = @{@"v":@(28
                             ),@"r":@"f17c29dd068953a474675a65f59c75c6189c426d1c60f43570cc7220ca3616c3",@"s":@"54f9ff243b903b7419dd566f277eedadf6aa55161f5d5e42005af29b14577902"};
                from = @"fa9461cc20fbb1b0937aa07ec6afc5e660fe2afd";
                to = @"8df9628de741b3d42c6f4a29ed4572b0f05fe8b4";
                value = @"110.5235";
                timestamp = @"1543457005562";
                inputData = @"Sec test transaction";
                
                AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BaseServerUrl]];
                [client invokeMethod:@"sec_sendRawTransaction" withParameters:@[@{@"timestamp":@([timestamp integerValue]),
                                                                                  @"from":from,
                                                                                  @"to":to,
                                                                                  @"value":value,
                                                                                  @"gasLimit":@"0",
                                                                                  @"gas":@"0",
                                                                                  @"gasPrice":@"0",
                                                                                  @"inputData":inputData,
                                                                                  @"data":data}] requestId:@(1) success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                      NSDictionary *dic = responseObject;
                                                                                      NSInteger status = [dic[@"status"] integerValue];
                                                                                      if (status == 1) {
                                                                                          [self hiddenLoadingView];
                                                                                          [self hudShowWithString:@"转账成功" delayTime:3];
                                                                                          //延迟执行
                                                                                          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:4.0];
                                                                                      }
                                                                                      
                                                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                      [self hiddenLoadingView];
                                                                                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"转账失败" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                                                                      [alert show];
                                                                                  }];
                
                
                
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

-(void)delayMethod
{
    int sum = [_tokenCoinModel.tokenNum intValue] - [moneyTF.text intValue];
    _tokenCoinModel.tokenNum = [NSString stringWithFormat:@"%d",sum];
    [self backAction];
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
