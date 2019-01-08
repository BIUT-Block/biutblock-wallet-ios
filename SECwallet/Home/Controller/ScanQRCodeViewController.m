//
//  ViewController.m
//  CALScanQRCode
//
//  Created by Cain on 5/2/16.
//  Copyright © 2016 Cain. All rights reserved.
//

#import "ScanQRCodeViewController.h"

@interface ScanQRCodeViewController ()

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItemTitle:Localized(@"扫一扫", nil)];
    
    __block ScanQRCodeViewController* blockSelf = self;
    [self setCALScanQRCodeGetMetadataStringValue:^(NSString *codeValue) {
        //判断扫描的是否为钱包地址
        NSString *tempStr;
        if ([codeValue containsString:@"###"]) {
            tempStr = [codeValue componentsSeparatedByString:@"###"].firstObject;
        }else{
            tempStr = codeValue;
        }
        //字符串前缀是0x并且长度为42位  0x7facd7954e31bec3b337a6f161bb711c825a96c0
        if ([tempStr hasPrefix:@"0x"] == YES && tempStr.length == 42) {
            [blockSelf.delegate getScanCode:codeValue];
            [blockSelf backAction];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Localized(@"地址不正确，请重新扫描！", nil) message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:Localized(@"确定", nil), nil];
            [alertView show];
            [blockSelf backAction];
        }
    }]; 
    
}

@end
