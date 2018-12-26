//
//  CommonSidePullView.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/25.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "CommonSidePullView.h"
#import "WalletModel.h"

#define kAssetsViewWidth      kScreenWidth -Size(50)
#define kAssetsViewHeight     kScreenHeight +KNaviHeight
#define KToStatusBarHeight    (IS_iPhoneX ? Size(38) : (IS_IOS11 ? Size(18) : 0))


@interface CommonSidePullView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) WalletModel *currentWallet;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *sidePullView;
@property (nonatomic, assign) CGFloat sidePullViewWidth;
@property (nonatomic, assign) CGFloat sidePullViewHeight;
@end


@implementation CommonSidePullView

- (id)initWithWidth:(CGFloat)width sidePullViewType:(CommonSidePullViewType)sidePullViewType
{
    if (self = [super init]) {
        self.backgroundColor = BACKGROUND_DARK_COLOR;
        self.frame = CGRectMake(kScreenWidth, 0, width, kScreenHeight);
        _sidePullViewWidth = width;
        _sidePullViewHeight = kScreenHeight;
        //设置阴影
        CALayer *layer = [self layer];
        layer.shadowOffset = CGSizeMake(0, Size(3)); //(0,0)时是四周都有阴影
        layer.shadowRadius = Size(5);
        layer.shadowColor = [UIColor darkGrayColor].CGColor;
        layer.shadowOpacity = Size(0.3);
        //关闭按钮
        UIButton *closeBT = [[UIButton alloc] initWithFrame:CGRectMake(_sidePullViewWidth -Size(40 +15), Size(28), Size(40), Size(24))];
        [closeBT greenBorderBtnStyle:Localized(@"关闭",nil) andBkgImg:@"continue"];
        [closeBT addTarget:self action:@selector(dismissSidePullView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBT];
        
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
        NSData* datapath = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
        NSMutableArray *walletList = [NSMutableArray array];
        walletList = [unarchiver decodeObjectForKey:@"walletList"];
        [unarchiver finishDecoding];
        _currentWallet = walletList[[[AppDefaultUtil sharedInstance].defaultWalletIndex intValue]];
        
        if (sidePullViewType == CommonSidePullViewType_address) {
            
            UILabel *tip1Lb = [[UILabel alloc] initWithFrame:CGRectMake(0, Size(155), _sidePullViewWidth, Size(20))];
            tip1Lb.font = SystemFontOfSize(10);
            tip1Lb.textColor = COLOR(64, 83, 92, 1);
            tip1Lb.textAlignment = NSTextAlignmentCenter;
            tip1Lb.text = Localized(@"二维码", nil);
            [self addSubview:tip1Lb];
            
            //二维码
            UIImageView *codeIV = [[UIImageView alloc] initWithFrame:CGRectMake((_sidePullViewWidth -Size(100))/2, tip1Lb.maxY +Size(30), Size(100), Size(100))];
            codeIV.image = [NSString twoDimensionCodeWithUrl:_currentWallet.address];
            [self addSubview:codeIV];
            
            UILabel *tip2Lb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), codeIV.maxY +Size(15), Size(100), Size(20))];
            tip2Lb.font = SystemFontOfSize(10);
            tip2Lb.textColor = COLOR(64, 83, 92, 1);
            tip2Lb.text = Localized(@"钱包地址", nil);
            [self addSubview:tip2Lb];
            
            UITextView *contentTV = [[UITextView alloc]initWithFrame:CGRectMake(tip2Lb.minX, tip2Lb.maxY +Size(3), Size(146), Size(46))];
            contentTV.userInteractionEnabled = NO;
            contentTV.backgroundColor = COLOR(244, 245, 246, 1);
            contentTV.layer.borderWidth = Size(0.5);
            contentTV.layer.borderColor = COLOR(209, 210, 211, 1).CGColor;
            contentTV.layer.cornerRadius = Size(5);
            contentTV.font = SystemFontOfSize(10);
            contentTV.textColor = COLOR(64, 83, 92, 1);
            contentTV.text = _currentWallet.address;
            [self addSubview:contentTV];
            
            UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(contentTV.minX, contentTV.maxY+Size(20), contentTV.width, Size(30))];
            [copyBT goldSmallBtnStyle:Localized(@"复制",nil)];
            copyBT.tag = 100;
            [copyBT addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:copyBT];
            
        }else if (sidePullViewType == CommonSidePullViewType_privateKey) {
            
            UILabel *tip1Lb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), Size(125), _sidePullViewWidth, Size(20))];
            tip1Lb.font = SystemFontOfSize(12);
            tip1Lb.textColor = COLOR(64, 83, 92, 1);
            tip1Lb.text = Localized(@"导出私钥", nil);
            [self addSubview:tip1Lb];
            
            UILabel *tip2Lb = [[UILabel alloc] initWithFrame:CGRectMake(tip1Lb.minX, tip1Lb.maxY +Size(30), Size(146), Size(60))];
            tip2Lb.font = SystemFontOfSize(10);
            tip2Lb.numberOfLines = 4;
            tip2Lb.textColor = COLOR(237, 28, 57, 1);
            tip2Lb.text = Localized(@"安全警告：privateKey未经加密且导出有风险。建议使用助记词或者Keystore进行备份", nil);
            [self addSubview:tip2Lb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:tip2Lb.text];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(4);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            tip2Lb.attributedText = msgStr;
            
            UITextView *contentTV = [[UITextView alloc]initWithFrame:CGRectMake(tip2Lb.minX, tip2Lb.maxY +Size(25), Size(146), Size(46))];
            contentTV.userInteractionEnabled = NO;
            contentTV.backgroundColor = COLOR(244, 245, 246, 1);
            contentTV.layer.borderWidth = Size(0.5);
            contentTV.layer.borderColor = COLOR(209, 210, 211, 1).CGColor;
            contentTV.layer.cornerRadius = Size(5);
            contentTV.font = SystemFontOfSize(10);
            contentTV.textColor = COLOR(64, 83, 92, 1);
            contentTV.text = _currentWallet.privateKey;
            [self addSubview:contentTV];
            
            UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(contentTV.minX, contentTV.maxY+Size(20), contentTV.width, Size(30))];
            [copyBT goldSmallBtnStyle:Localized(@"复制",nil)];
            copyBT.tag = 101;
            [copyBT addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:copyBT];
            
        }else if (sidePullViewType == CommonSidePullViewType_keyStore) {
            
            UILabel *tip1Lb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), Size(125), _sidePullViewWidth, Size(20))];
            tip1Lb.font = SystemFontOfSize(12);
            tip1Lb.textColor = COLOR(64, 83, 92, 1);
            tip1Lb.text = Localized(@"导出KeyStore", nil);
            [self addSubview:tip1Lb];
            
            UILabel *tit1Lb = [[UILabel alloc] initWithFrame:CGRectMake(tip1Lb.minX, tip1Lb.maxY+Size(30), Size(100), Size(15))];
            tit1Lb.font = SystemFontOfSize(12);
            tit1Lb.textColor = COLOR(144, 162, 171, 1);
            tit1Lb.text = Localized(@"离线保存", nil);
            [self addSubview:tit1Lb];
            UILabel *tip2Lb = [[UILabel alloc] initWithFrame:CGRectMake(tit1Lb.minX, tit1Lb.maxY, Size(230), Size(55))];
            tip2Lb.font = SystemFontOfSize(10);
            tip2Lb.numberOfLines = 3;
            tip2Lb.textColor = COLOR(156, 173, 180, 1);
            tip2Lb.text = Localized(@"请将Keystore文件复制并粘贴到安全的离线位置进行保存。不要保存到电子邮件，记事本，网络，聊天App，这是非常危险的。", nil);
            [self addSubview:tip2Lb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:tip2Lb.text];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(4);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            tip2Lb.attributedText = msgStr;
            
            UILabel *tit2Lb = [[UILabel alloc] initWithFrame:CGRectMake(tip2Lb.minX, tip2Lb.maxY+Size(15), Size(200), Size(15))];
            tit2Lb.font = SystemFontOfSize(12);
            tit2Lb.textColor = COLOR(144, 162, 171, 1);
            tit2Lb.text = Localized(@"不要网上传输", nil);
            [self addSubview:tit2Lb];
            UILabel *tip3Lb = [[UILabel alloc] initWithFrame:CGRectMake(tit2Lb.minX, tit2Lb.maxY, tip2Lb.width, tip2Lb.height)];
            tip3Lb.font = SystemFontOfSize(10);
            tip3Lb.numberOfLines = 3;
            tip3Lb.textColor = COLOR(156, 173, 180, 1);
            tip3Lb.text = Localized(@"不要通过网络工具传输密钥库文件。一旦被黑客入侵，将导致无法弥补的资产损失。通过扫描QR码传输离线设备。", nil);
            [self addSubview:tip3Lb];
            //设置行间距
            NSMutableAttributedString *msgStr1 = [[NSMutableAttributedString alloc] initWithString:tip3Lb.text];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle1.lineSpacing = Size(4);
            [msgStr1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, msgStr1.length)];
            tip3Lb.attributedText = msgStr1;
            
            UITextView *contentTV = [[UITextView alloc]initWithFrame:CGRectMake(tip3Lb.minX, tip3Lb.maxY +Size(10), Size(230), Size(85))];
            contentTV.userInteractionEnabled = NO;
            contentTV.backgroundColor = COLOR(244, 245, 246, 1);
            contentTV.layer.borderWidth = Size(0.5);
            contentTV.layer.borderColor = COLOR(209, 210, 211, 1).CGColor;
            contentTV.layer.cornerRadius = Size(5);
            contentTV.font = SystemFontOfSize(10);
            contentTV.textColor = COLOR(64, 83, 92, 1);
            contentTV.text = _currentWallet.keyStore;
            [self addSubview:contentTV];
            
            UIButton *copyBT = [[UIButton alloc] initWithFrame:CGRectMake(contentTV.minX, contentTV.maxY+Size(15), contentTV.width, Size(30))];
            [copyBT goldSmallBtnStyle:Localized(@"复制Keystore",nil)];
            copyBT.tag = 102;
            [copyBT addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:copyBT];
            
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

-(void)copyAction:(UIButton *)sender
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    if (sender.tag == 100) {
        pastboard.string = _currentWallet.address;
    }else if (sender.tag == 101) {
        pastboard.string = _currentWallet.privateKey;
    }else if (sender.tag == 102) {
        pastboard.string = _currentWallet.keyStore;
    }
    
//    [self hudShowWithString:@"已复制" delayTime:2];
}

- (void)leftBtnClicked:(id)sender
{
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissSidePullView];
    
}
- (void)rightBtnClicked:(id)sender
{
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissSidePullView];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    topVC.view.backgroundColor = CLEAR_COLOR;
    //从右向左移动
    [UIView animateWithDuration:0.20 animations:^{
        self.frame = CGRectMake(kScreenWidth-_sidePullViewWidth, 0, _sidePullViewWidth, _sidePullViewHeight);
        [topVC.view addSubview:self];
    }];
    
}

- (void)dismissSidePullView
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [_backView removeFromSuperview];
    _backView = nil;
    
//    UIViewController *topVC = [self appRootViewController];
    //从左向右移动
    [UIView animateWithDuration:0.20 animations:^{
        self.frame = CGRectMake(kScreenWidth, 0, _sidePullViewWidth, _sidePullViewHeight);
//        [topVC.view addSubview:self];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        _backView.backgroundColor = BLACK_COLOR;
        _backView.alpha = 0.0f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:_backView];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [super willMoveToSuperview:newSuperview];
}

@end
