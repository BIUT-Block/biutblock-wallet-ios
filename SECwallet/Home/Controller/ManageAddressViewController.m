//
//  EditAddressViewController.m
//  SECwallet
//
//  Created by 通证控股 on 2018/10/17.
//  Copyright © 2018年 通证控股. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "CommonTableViewCell.h"
#import "ScanQRCodeViewController.h"

@interface ManageAddressViewController ()<ScanQRCodeViewControllerDelegate,UITextFieldDelegate>
{
    UILabel *nameErrorLb;
    CommonTableViewCell *nameCell;
    UILabel *nameLb;
    UITextField *nameTF;       //姓名
    
    UILabel *addressErrorLb;
    CommonTableViewCell *addressCell;
    UILabel *addressLb;
    UITextField *addressTF;    //地址
    UIScrollView *addressContentView;
    UITextField *phoneTF;      //电话
    UITextField *emailTF;      //邮箱
    UITextField *remarkTF;     //备注
    
    UIButton *saveBtn;
}

@end

@implementation ManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardAction)];
    [self.view addGestureRecognizer:tap];
    
}
//解决手势和cell点击事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)addSubView
{
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), 0, Size(200), Size(22))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    if (_manageAddressViewType == ManageAddressViewType_add) {
        titleLb.text = Localized(@"新增地址",nil);
    }else{
        titleLb.text = Localized(@"编辑地址",nil);
    }
    [self.view addSubview:titleLb];
    
    //姓名
    nameLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), titleLb.maxY+Size(35), kScreenWidth -Size(20*2), Size(25))];
    nameLb.font = BoldSystemFontOfSize(11);
    nameLb.textColor = TEXT_BLACK_COLOR;
    nameLb.text = Localized(@"联系人姓名*", nil);
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:nameLb.text];
    [nameStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(nameLb.text.length-1,1)];
    nameLb.attributedText = nameStr;
    [self.view addSubview:nameLb];
    nameErrorLb = [[UILabel alloc]init];
    [self.view addSubview:nameErrorLb];
    nameCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    nameCell.frame = CGRectMake(nameLb.minX, nameLb.maxY, nameLb.width, Size(42));
    [self.view addSubview:nameCell];
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(Size(10), 0, nameLb.width-Size(20), nameCell.height)];
    nameTF.delegate = self;
    nameTF.font = SystemFontOfSize(12);
    nameTF.textColor = TEXT_BLACK_COLOR;
    if (_manageAddressViewType == ManageAddressViewType_edit) {
        nameTF.text = _currentModel.name;
    }
    [nameCell addSubview:nameTF];
    
    
    addressLb = [[UILabel alloc]initWithFrame:CGRectMake(nameLb.minX, nameCell.maxY +Size(3), nameLb.width, nameLb.height)];
    addressLb.font = BoldSystemFontOfSize(11);
    addressLb.textColor = TEXT_BLACK_COLOR;
    addressLb.text = Localized(@"联系人钱包地址*", nil);
    NSMutableAttributedString *addressStr = [[NSMutableAttributedString alloc] initWithString:addressLb.text];
    [addressStr addAttribute:NSForegroundColorAttributeName value:TEXT_RED_COLOR range:NSMakeRange(addressLb.text.length-1,1)];
    addressLb.attributedText = addressStr;
    [self.view addSubview:addressLb];
    addressErrorLb = [[UILabel alloc]init];
    [self.view addSubview:addressErrorLb];
    addressCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addressCell.frame = CGRectMake(addressLb.minX, addressLb.maxY, nameCell.width, nameCell.height);
    [self.view addSubview:addressCell];
    addressContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(nameTF.minX, 0, addressCell.width -nameTF.minX-Size(45), addressCell.height)];
    addressContentView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [addressCell addSubview:addressContentView];
    addressTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, addressContentView.width, addressContentView.height)];
    addressTF.delegate = self;
    addressTF.font = SystemFontOfSize(12);
    addressTF.textColor = TEXT_BLACK_COLOR;
    addressTF.keyboardType = UIKeyboardTypeNamePhonePad;
    if (_manageAddressViewType == ManageAddressViewType_edit) {
        addressTF.text = _currentModel.address;
    }
    [addressContentView addSubview:addressTF];
    //扫一扫
    UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(addressCell.width -Size(20 +20), (addressCell.height -Size(20))/2, Size(20), Size(20))];
    [scanBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [addressCell addSubview:scanBtn];

    //手机号
    UILabel *phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(addressLb.minX, addressCell.maxY +Size(4), addressLb.width, addressLb.height)];
    phoneLb.font = BoldSystemFontOfSize(11);
    phoneLb.textColor = TEXT_BLACK_COLOR;
    phoneLb.text = Localized(@"手机号码", nil);
    [self.view addSubview:phoneLb];
    CommonTableViewCell *phoneCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    phoneCell.frame = CGRectMake(phoneLb.minX, phoneLb.maxY, nameCell.width, nameCell.height);
    [self.view addSubview:phoneCell];
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.minX, 0, phoneCell.width -nameTF.minX*2, phoneCell.height)];
    phoneTF.font = SystemFontOfSize(12);
    phoneTF.textColor = TEXT_BLACK_COLOR;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    if (_manageAddressViewType == ManageAddressViewType_edit) {
        phoneTF.text = _currentModel.phone;
    }
    [phoneCell addSubview:phoneTF];

    //邮箱
    UILabel *emailLb = [[UILabel alloc]initWithFrame:CGRectMake(phoneCell.minX, phoneCell.maxY+Size(4), phoneCell.width, phoneLb.height)];
    emailLb.font = BoldSystemFontOfSize(11);
    emailLb.textColor = TEXT_BLACK_COLOR;
    emailLb.text = Localized(@"邮箱", nil);
    [self.view addSubview:emailLb];
    CommonTableViewCell *emailCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    emailCell.frame = CGRectMake(emailLb.minX, emailLb.maxY, phoneCell.width, phoneCell.height);
    [self.view addSubview:emailCell];
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.minX, 0, phoneTF.width, phoneTF.height)];
    emailTF.font = SystemFontOfSize(12);
    emailTF.textColor = TEXT_BLACK_COLOR;
    emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    if (_manageAddressViewType == ManageAddressViewType_edit) {
        emailTF.text = _currentModel.email;
    }
    [emailCell addSubview:emailTF];

    //备注
    UILabel *remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(nameLb.minX, emailCell.maxY +Size(4), nameLb.width, nameLb.height)];
    remarkLb.font = BoldSystemFontOfSize(11);
    remarkLb.textColor = TEXT_BLACK_COLOR;
    remarkLb.text = Localized(@"备注", nil);
    [self.view addSubview:remarkLb];
    CommonTableViewCell *markCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    markCell.frame = CGRectMake(remarkLb.minX, remarkLb.maxY, phoneCell.width, phoneCell.height);
    [self.view addSubview:markCell];
    remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(emailTF.minX, 0, emailTF.width, emailTF.height)];
    remarkTF.font = SystemFontOfSize(12);
    remarkTF.textColor = TEXT_BLACK_COLOR;
    if (_manageAddressViewType == ManageAddressViewType_edit) {
        remarkTF.text = _currentModel.remark;
    }
    [markCell addSubview:remarkTF];
    
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(markCell.minX, markCell.maxY +Size(45), kScreenWidth - 2*markCell.minX, Size(45))];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        [saveBtn darkBtnStyle:Localized(@"确认新增", nil)];
    }else{
        [saveBtn darkBtnStyle:Localized(@"保存修改", nil)];
    }
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.userInteractionEnabled = NO;
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == addressTF) {
        CGSize size = [textField.text calculateSize:SystemFontOfSize(12) maxWidth:kScreenWidth*2];
        if (size.width > kScreenWidth -Size(75)) {
            addressTF.frame = CGRectMake(Size(0), 0, size.width+Size(10), addressContentView.height);
            [addressContentView setContentSize:CGSizeMake(size.width, addressTF.height)];
        }else{
            addressTF.frame = CGRectMake(Size(0), 0, kScreenWidth -Size(15 +45), addressContentView.height);
            [addressContentView setContentSize:CGSizeMake(kScreenWidth -Size(15 +45), addressTF.height)];
        }
    }
    
    if (nameTF.text.length > 0 && addressTF.text.length > 0) {
        if (_manageAddressViewType == ManageAddressViewType_add) {
            [saveBtn goldBigBtnStyle:Localized(@"确认新增", nil)];
        }else{
            [saveBtn goldBigBtnStyle:Localized(@"保存修改", nil)];
        }
        saveBtn.userInteractionEnabled = YES;
    }else{
        if (_manageAddressViewType == ManageAddressViewType_add) {
            [saveBtn darkBtnStyle:Localized(@"确认新增", nil)];
        }else{
            [saveBtn darkBtnStyle:Localized(@"保存修改", nil)];
        }
        saveBtn.userInteractionEnabled = NO;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == nameTF) {
        nameCell.contentView.backgroundColor = DARK_COLOR;
    }else if (textField == addressTF) {
        addressCell.contentView.backgroundColor = DARK_COLOR;
    }
}
#pragma mark 完成
-(void)saveAction
{
    [self dismissKeyboardAction];
    if (nameTF.text.length == 0) {
        nameErrorLb.hidden = NO;
        [nameErrorLb remindError:@"请输入联系人姓名" withY:nameLb.minY];
        nameCell.contentView.backgroundColor = REMIND_COLOR;
        return;
    }else{
        nameErrorLb.hidden = YES;
        nameCell.contentView.backgroundColor = DARK_COLOR;
    }
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
    if (phoneTF.text.length > 0) {
        if ([NSString validateMobile:phoneTF.text] == NO) {
            [self hudShowWithString:Localized(@"号码格式不正确，请重新输入", nil) delayTime:1.5];
            return;
        }
    }
    if (emailTF.text.length > 0) {
        if ([NSString validateEmail:emailTF.text] == NO) {
            [self hudShowWithString:Localized(@"邮箱格式不正确，请重新输入", nil) delayTime:1.5];
            return;
        }
    }
    
    /***************判断地址已存在****************/
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"addressList"];
    NSData* data2 = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
    NSMutableArray *list = [NSMutableArray array];
    list = [unarchiver decodeObjectForKey:@"addressList"];
    [unarchiver finishDecoding];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        for (AddressModel *model in list) {
            if ([model.name isEqualToString:nameTF.text] && [model.address isEqualToString:addressTF.text] && [model.phone isEqualToString:phoneTF.text]) {
                addressErrorLb.hidden = NO;
                [addressErrorLb remindError:@"该地址已存在" withY:addressLb.minY];
                addressCell.contentView.backgroundColor = REMIND_COLOR;
                return;
            }else{
                addressErrorLb.hidden = YES;
                addressCell.contentView.backgroundColor = DARK_COLOR;
            }
        }
    }else if (_manageAddressViewType == ManageAddressViewType_edit) {
        [list enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.name isEqualToString:_currentModel.name] && [obj.address isEqualToString:_currentModel.address] && [obj.phone isEqualToString:_currentModel.phone]) {
                *stop = YES;
                if (*stop == YES) {
                    [list removeObject:obj];
                }
            }
            *stop = NO; //移除了数组中的元素之后继续执行
            if (*stop) {
                NSLog(@"array is %@",list);
            }
        }];
        for (AddressModel *model in list) {
            if ([model.name isEqualToString:nameTF.text] && [model.address isEqualToString:addressTF.text] && [model.phone isEqualToString:phoneTF.text]) {
                addressErrorLb.hidden = NO;
                [addressErrorLb remindError:@"该地址已存在" withY:addressLb.minY];
                addressCell.contentView.backgroundColor = REMIND_COLOR;
                return;
            }else{
                addressErrorLb.hidden = YES;
                addressCell.contentView.backgroundColor = DARK_COLOR;
            }
        }
    }
    
    [self createLoadingView:nil];
    AddressModel *model = [[AddressModel alloc]initWithName:nameTF.text andPhone:phoneTF.text andAddress:addressTF.text andEmail:emailTF.text andRemark:remarkTF.text];
    /*************先获取地址列表并将最新地址排在第一位*************/
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    if (_manageAddressViewType == ManageAddressViewType_add) {
        if (list.count > 0) {
            [list insertObject:model atIndex:0];
            [archiver encodeObject:list forKey:@"addressList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
        }else{
            NSMutableArray *list1 = [NSMutableArray array];
            [list1 insertObject:model atIndex:0];
            [archiver encodeObject:list1 forKey:@"addressList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
        }
    }else if (_manageAddressViewType == ManageAddressViewType_edit) {
        //先删除当前地址在插入保存的地址
        [list enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.name isEqualToString:_currentModel.name] && [obj.address isEqualToString:_currentModel.address] && [obj.phone isEqualToString:_currentModel.phone]) {
                *stop = YES;
                if (*stop == YES) {
                    [list removeObject:obj];
                }
            }
            *stop = NO; //移除了数组中的元素之后继续执行
            if (*stop) {
                NSLog(@"array is %@",list);
            }
        }];

        [list insertObject:model atIndex:0];
        [archiver encodeObject:list forKey:@"addressList"];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    }
    
    //延迟执行
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}
-(void)delayMethod
{
    [self hiddenLoadingView];
    [self backAction];
}

#pragma 扫一扫
-(void)scanAction
{
    [self dismissKeyboardAction];
    ScanQRCodeViewController *controller = [[ScanQRCodeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 点击空白处收回键盘
-(void)dismissKeyboardAction
{
    [nameTF resignFirstResponder];
    [addressTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [emailTF resignFirstResponder];
    [remarkTF resignFirstResponder];
}

#pragma ScanQRCodeViewControllerDelegate
-(void)getScanCode:(NSString *)codeStr
{
    if ([codeStr containsString:@"###"]) {
        NSArray *arr = [codeStr componentsSeparatedByString:@"###"];
        addressTF.text = arr[0];
    }else{
        addressTF.text = codeStr;
    }
    CGSize size = [addressTF.text calculateSize:SystemFontOfSize(12) maxWidth:kScreenWidth*2];
    addressTF.frame = CGRectMake(0, 0, size.width+Size(10), addressContentView.height);
    [addressContentView setContentSize:CGSizeMake(size.width+Size(10), addressTF.height)];
}

@end
