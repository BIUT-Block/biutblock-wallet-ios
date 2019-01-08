//
//  AddressCodePayViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "AddressCodePayViewController.h"
#import "CommonTableViewCell.h"

@interface AddressCodePayViewController ()<UITextFieldDelegate>
{
    CommonTableViewCell *cell;
    UILabel *sumErrorLb;
    UITextField *sumTF;
    BOOL isError;
}
@end

@implementation AddressCodePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(246, 252, 251, 1);
    [self addContentView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = COLOR(246, 252, 251, 1);
    
}

#pragma mark - 底部收款视图
- (void)addContentView
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];
    
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, backBT.maxY +Size(10), kScreenWidth, Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = [NSString stringWithFormat:@"SEC %@",Localized(@"收款",nil)] ;
    [self.view addSubview:titleLb];
    
    //地址
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(65), titleLb.maxY +Size(30), kScreenWidth -Size(65)*2, Size(40))];
    addressLb.font = SystemFontOfSize(10);
    addressLb.textColor = TEXT_DARK_COLOR;
    addressLb.numberOfLines = 2;
    addressLb.textAlignment = NSTextAlignmentCenter;
    addressLb.text = _walletModel.address;
    [self.view addSubview:addressLb];
    
    cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(addressLb.minX, addressLb.maxY +Size(15), addressLb.width, Size(30));
    cell.contentView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:cell];
    sumErrorLb = [[UILabel alloc]init];
    [self.view addSubview:sumErrorLb];
    sumTF = [[UITextField alloc]initWithFrame:CGRectMake(Size(10), 0, cell.width -Size(10 *2), cell.height)];
    sumTF.font = SystemFontOfSize(12);
    sumTF.textColor = TEXT_BLACK_COLOR;
    sumTF.keyboardType = UIKeyboardTypeDecimalPad;
    sumTF.delegate = self;
    [sumTF addTarget:self action:@selector(checkSumAction:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:sumTF];
    
    //支付码
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(addressLb.minX, cell.maxY +Size(15), kScreenWidth-addressLb.minX*2, Size(190))];
    bkgView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:bkgView];
    UIImageView *payCode = [[UIImageView alloc]initWithFrame:CGRectMake(Size(20), Size(20), bkgView.width-Size(20 *2), bkgView.height-Size(20 *2))];
    payCode.image = [NSString twoDimensionCodeWithUrl:_walletModel.address];
    [bkgView addSubview:payCode];
    
    //复制收款地址
    UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(bkgView.minX, bkgView.maxY +Size(30), bkgView.width, Size(45))];
    [copyBT goldBigBtnStyle:Localized(@"复制收款地址", nil)];
    [copyBT addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBT];
    
}

#pragma 复制收款地址
-(void)copyAction
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _walletModel.address;
    [self hudShowWithString:@"已复制" delayTime:1];
}

-(void)checkSumAction:(id)sender
{
    UITextField *field = (UITextField *)sender;
    //限制输入小数点后八位
    if ([field.text floatValue] > [_walletModel.balance floatValue]) {
        sumErrorLb.hidden = NO;
        [sumErrorLb remindError:@"超过最大输入值" withY:cell.minY -Size(20)];
        cell.contentView.backgroundColor = REMIND_COLOR;
        isError = YES;
    }else{
        sumErrorLb.hidden = YES;
        cell.contentView.backgroundColor = WHITE_COLOR;
        isError = NO;
    }
    
    if ([field.text containsString:@"."]) {
        NSString *decimalStr = [field.text componentsSeparatedByString:@"."].lastObject;
        if (decimalStr.length > 8) {
            sumErrorLb.hidden = NO;
            [sumErrorLb remindError:@"小数点后只允许输入8位" withY:cell.minY -Size(20)];
            cell.contentView.backgroundColor = REMIND_COLOR;
            isError = YES;
            return;
        }else{
            sumErrorLb.hidden = YES;
            cell.contentView.backgroundColor = WHITE_COLOR;
            isError = NO;
        }
    }
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isError == YES) {
        sumErrorLb.hidden = YES;
        cell.contentView.backgroundColor = WHITE_COLOR;
        textField.text = @"";
    }
}

@end
